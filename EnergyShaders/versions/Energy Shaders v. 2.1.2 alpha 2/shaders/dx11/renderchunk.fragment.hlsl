#include "ShaderConstants.fxh"
#include "Util.fxh"

struct PS_Input
{
	float4 position : SV_Position;
	float3 fragPos : POSI;

#ifndef BYPASS_PIXEL_SHADER
	lpfloat4 color : COLOR;
	snorm float2 uv0 : TEXCOORD_0_FB_MSAA;
	snorm float2 uv1 : TEXCOORD_1_FB_MSAA;
#endif

#ifdef NEAR_WATER
	float cameraDist : TEXCOORD_2;
#endif

#ifdef FOG
	float4 fogColor : FOG_COLOR;
#endif
};

struct PS_Output
{
	float4 color : SV_Target;
};

void main( in PS_Input PSInput, out PS_Output PSOutput )
{
#ifdef BYPASS_PIXEL_SHADER
    PSOutput.color = float4(0.0f, 0.0f, 0.0f, 0.0f);
    return;
#else


float shE = 0.0;
float fadeInE = 0.0;
float shwE = 0.88;
float2 fSwE = float2(0.015,0.0);
fSwE.g = 1.0/fSwE.r;

float Red = 0.0;

float4 watercolor = float4(0.0, 0.0, 0.3, 0.05);
float4 farwatercolor = float4(0.05, 0.1, 0.4, 0.9);
float3 torchl = float3(0.5,0.45,0.05);

float tlfE = PSInput.uv1.r;
float tlmix = 0.0;

float rainE = 0.0;
float4 raincolor = float4(0.441,0.46,0.484, 0.0);
float holefog = FOG_COLOR.r+FOG_COLOR.g+FOG_COLOR.b;
float2 itsnight = float2(0.0, 0.0);
float nether = 0.0;
float uw = 0.0; //underwater
float3 fixPos = PSInput.fragPos.xyz + VIEW_POS.xyz;
float3 posE = PSInput.fragPos;

//is it night?
if(holefog <= 0.4){
    itsnight.r = 1.0;
    itsnight.g = 1.0-holefog*2.5;
}

//rainy?
if (FOG_CONTROL.x < 0.55 && FOG_CONTROL.x > 0.1){
  rainE = 1.0;
  raincolor.a = min(0.5,length(PSInput.fragPos.xyz)/RENDER_DISTANCE)*2.0;
  raincolor.a = min(1.0, raincolor.a + 0.3);
  raincolor.a = max(0.0, raincolor.a - max(0.0, PSInput.uv1.x - 0.5));
  
   raincolor.rgb = lerp(raincolor.rgb, FOG_COLOR.rgb, raincolor.a);
}

if(FOG_COLOR.r < 0.25 && FOG_COLOR.b<0.25 && ((FOG_CONTROL.x < 0.55 && FOG_CONTROL.x > 0.1)) && FOG_COLOR.r > 0.1){
  nether = 1.0;
}


//check if we are underwater
if(FOG_CONTROL.x <= 0.01){uw = 1.0;}


#if !defined(TEXEL_AA) || !defined(TEXEL_AA_FEATURE) || (VERSION < 0xa000 /*D3D_FEATURE_LEVEL_10_0*/) 
	float4 diffuse = TEXTURE_0.Sample(TextureSampler0, PSInput.uv0);
#else
	float4 diffuse = texture2D_AA(TEXTURE_0, TextureSampler0, PSInput.uv0 );
#endif

#ifdef SEASONS_FAR
	diffuse.a = 1.0f;
	PSInput.color.b = 1.0f;
#endif

#ifdef ALPHA_TEST
//If we know that all the verts in a triangle will have the same alpha, we should cull there first.
	#ifdef ALPHA_TO_COVERAGE
		float alphaThreshold = .05f;
	#else
		float alphaThreshold = .5f;
	#endif
	if(diffuse.a < alphaThreshold)
		discard;
#endif

	diffuse = diffuse * TEXTURE_1.Sample(TextureSampler1, PSInput.uv1);

#ifndef SEASONS

#if !defined(ALPHA_TEST) && !defined(BLEND)
	diffuse.a = PSInput.color.a;
#elif defined(BLEND)
	diffuse.a *= PSInput.color.a;

#ifdef NEAR_WATER
	float alphaFadeOut = saturate(PSInput.cameraDist.x);
	diffuse.a = lerp(diffuse.a, 1.0f, alphaFadeOut);
#endif

#endif	
	diffuse.rgb *= PSInput.color.rgb;
#else
	float2 uv = PSInput.color.xy;
	diffuse.rgb *= lerp(1.0f, TEXTURE_2.Sample(TextureSampler2, uv).rgb*2.0f, PSInput.color.b);
	diffuse.rgb *= PSInput.color.aaa;
	diffuse.a = 1.0f;
#endif

#ifdef FOG
	if(nether == 0.0){
		diffuse.rgb = lerp( diffuse.rgb, PSInput.fogColor.rgb, PSInput.fogColor.a);
	}
#endif

Red = max(0.0,1.0-diffuse.r);
torchl.r += Red;

//shadows
if(PSInput.uv1.g <= shwE){
	shE = 1.0;
	//fade in
	if(PSInput.uv1.g >= shwE-fSwE.r){
		fadeInE = (PSInput.uv1.g - (shwE-fSwE.r))*fSwE.g;
		shE = lerp(1.0, 0.0, fadeInE);
	}
}
shE = max(0.0,shE-(tlfE*1.3));






float nullp = (posE.y+1.5)*0.9;
float fadeInPS = 0.0;
float PSfact = 0.0;

if(posE.x < 0.3 && posE.x > -0.3 && posE.z < nullp+0.25 && posE.z > nullp-0.85){
  if(abs(posE.x) > 0.2){
    fadeInPS = (abs(posE.x) - 0.2)*10.0;
    PSfact = 1.0-fadeInPS;
    if(posE.z > nullp+0.15){
      PSfact = 1.0 - (fadeInPS*0.5 + (posE.z - (nullp +0.15))*5.0);
    }  
  }else if(posE.z > nullp+0.15){
    fadeInPS = (posE.z - (nullp +0.15))*10.0;
    
      PSfact = 1.0-fadeInPS;
  }else{
    PSfact = 1.0;
  }
}
if(posE.x < 0.5 && posE.x > -0.5 && posE.z < nullp-0.75 && posE.z > nullp-1.75){ 
  if(abs(posE.x) > 0.4){
    fadeInPS = (abs(posE.x) - 0.4)*10.0;
    PSfact = 1.0-fadeInPS;
    if(posE.z > nullp-0.85){
      PSfact = 1.0 - (fadeInPS*0.5 + (posE.z - (nullp -0.85))*5.0);
    }  
    else if(posE.z < nullp-1.65){
      PSfact = 1.0 - (fadeInPS*0.5 + (posE.z - (nullp -1.65))*(-5.0));
    }  
  }else if(posE.z > nullp-0.85 && PSfact == 0.0){
    fadeInPS = (posE.z - (nullp -0.85))*10.0;
    
    PSfact = 1.0-fadeInPS;
  }else if(posE.z < nullp-1.65){
    fadeInPS = (posE.z - (nullp - 1.65))*(-10.0);
    
    PSfact = 1.0-fadeInPS;  
  }else{
    PSfact = 1.0;
  } 
}
if(posE.x < 0.275 && posE.x > -0.275 && posE.z < nullp-1.65 && posE.z > nullp-2.139){ 
  if(abs(posE.x) > 0.175){
    fadeInPS = (abs(posE.x) - 0.175)*10.0;
    PSfact = 1.0-fadeInPS;
  }else{
    PSfact = 1.0;
  }
}
PSfact -= max(0.0,itsnight.g*2.0 + max(0.0, (PSInput.uv1.x-0.5)*2.0)+abs(posE.y+1.5)*0.01);
PSfact -= min(1.0, max(0.0, posE.y));
shE = min(1.0, shE+max(0.0,PSfact));








#ifdef FOG
	shE = max(0.0,shE-PSInput.fogColor.a*5.0);
#endif

//Water Color
#ifdef NEAR_WATER
	if(uw == 0.0){
		watercolor.a += itsnight.g * 0.09;
		farwatercolor.a += itsnight.g * 0.09;
		watercolor.b += itsnight.g * 0.5;
		watercolor.rg -= itsnight.g * 0.3;

		watercolor.rgb -= itsnight.g * 0.4;
		farwatercolor.rgb -= itsnight.g * 0.4;
		
		diffuse = lerp(watercolor, farwatercolor, PSInput.color.a - itsnight.g * 0.5);
	}
#endif

//sunlight
float isl_f = 1.0-(diffuse.r+diffuse.g+diffuse.b)/3.0;
float4 isl_v = float4(1.0+isl_f,0.9+isl_f,0.8+isl_f,1.0);

isl_v.rgb *= 1.0-shE*1.1;
isl_v.rgb = max(float3(1.0, 1.0, 1.0), isl_v.rgb);

diffuse.rgb *= isl_v.rgb;

float4 ug = float4(1.0, 1.0, 1.0, 1.0);
ug.a = min(1.0, max(0.0, PSInput.uv1.g + max(0.0, PSInput.uv1.r - 0.5) + 0.7));
ug.rgb = float3(0.39, 0.39, 0.39);



if(nether == 1.0){

	raincolor = float4(0.441,0.46,0.484, 0.0);
	raincolor.a = min(1.0, raincolor.a + 0.3);
	raincolor.a = max(0.0, raincolor.a - PSInput.uv1.x);

	ug.r = 0.78;
	raincolor.r = 0.79;
	raincolor.gb -= 0.343;
	raincolor.a = max(0.0, raincolor.a-0.35);
	ug.a = max(ug.a, ug.a);
	ug.gb = float2(0.0, 0.0);
}



diffuse.rgb = lerp(ug.rgb, diffuse.rgb, ug.a);
diffuse.rgb += torchl * max(0.0, PSInput.uv1.r - 0.5);
diffuse.rgb = lerp(diffuse.rgb, raincolor.rgb, raincolor.a);



if(itsnight.r == 1.0){
  float3 oldd = diffuse.rgb;
  float mixn = max(0.0, itsnight.g - PSInput.uv1.r);
 
  mixn = lerp(0.0, mixn, max(0.0, PSInput.uv1.g - 0.2)*2.1);
  #ifndef NEAR_WATER
	oldd.r *= 0.1;
	oldd.g *= 0.3;
	oldd.b *= 0.5;
  
	diffuse.rgb = lerp(diffuse.rgb, oldd*1.85, mixn);
  #endif
}

	PSOutput.color = diffuse;

#ifdef VR_MODE
	// On Rift, the transition from 0 brightness to the lowest 8 bit value is abrupt, so clamp to 
	// the lowest 8 bit value.
	PSOutput.color = max(PSOutput.color, 1 / 255.0f);
#endif

#endif // BYPASS_PIXEL_SHADER
}