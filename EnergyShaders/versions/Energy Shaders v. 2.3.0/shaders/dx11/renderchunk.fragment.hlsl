#include "ShaderConstants.fxh"
#include "Util.fxh"

struct PS_Input
{
	float4 position : SV_Position;
	float3 fragPos : POSI;
	float3 RealScreenPos : SPOSI;

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

float2 rando(float2 p){
  float2 np = frac(p * float2(443.897 , 441.423));
  np += dot(np, np.yx + float2(19.19, 19.19));
  np = frac((np.xx + np.yx)* np.xy) * 2.0 - 1.0;
  return np;
};

float st(float2 p){
	float s;
    
    float X = floor(p.x*90.0);
    float Y = floor(p.y*90.0);
    
    p += floor(p * 90.0) + X + Y;
    
    s = sin(p.x) * sin(p.y);
    
    return 1.0;
}

float st2(float2 p){
	float s;
    float ss = 2.0;
    float f = 45.0;

   	p += floor(p * (f));
    
    s = sin(p.x + TIME * ss) * sin(p.y + TIME * ss);
    
    return /*s*/0.3;
}

float4 EnergyColorMap(float4 c){
	float R,G,B;
	
	R = c.r;
	G = c.g;
	B = c.b;
	
	R = lerp(R,R * 1.5, max(0.0, R - (G + B)));
	G = lerp(G,G * 1.5, max(0.0, G - (R + B)));
	B = lerp(B,B * 1.5, max(0.0, B - (G + R)));

  return float4(R, G, B, c.a);
};

float3 worldPosToCloudPos(min16float3 CamPos, min16float3 p, float YOffset, float sky_height){
  
  if(p.y <= 0.0){
  	p.y = min(-3.0, p.y);
  }
  float3 NToCloud = normalize(reflect(p + float3(0.0, YOffset, 0.0) , normalize(CamPos)));

  
  float Expandfactor = sky_height / NToCloud.y;  

  float3 UnrealCloudPos = NToCloud * Expandfactor;
  
  
  return (UnrealCloudPos / RENDER_DISTANCE) / 40.0;
};

float wave1(min16float2 p, float f1, float f2, min16float t){
	
	float w1 = (sin(p.x*f1 + t) * sin(p.y*f2 + t));
	
	w1 = w1 - max(0.0, w1-0.8)*4.0;
	
	return w1;
};

float getRain(){
  return min(1.0, max(0.0, 1.0-pow(FOG_CONTROL.y,5.0))*2.0);
};


min16float unrealPos(min16float x, min16float z, float fact){
  min16float factor = length(min16float2(x, z));
  
  return fact - factor*15.0;
};

float clacCodeBasedNoiseTexture(min16float2 a){
  float ca = sin(a.x + TIME*0.1 + a.y - a.x + sin(a.x+TIME*0.1) + cos(a.y + a.y - a.x));
  float cc = sin(a.x+(cos(a.y)*0.1));
  float cd = 0.0;
  
  return ca*1.5*cc;
};

float4 CloudColor(float a, float3 fog){
  float3 cloudColor = float3(1.5, 1.5, 1.5);
  
  cloudColor *= fog*2.0;
  
  cloudColor = lerp(cloudColor, float3(1.3, 0.7, 0.95), max(0.0, fog.r));
  
    //cloudColor *= max(0.7, getRain());
    a -= (1.0 - getRain())*1.5;
  
  cloudColor = min(float3(1.0, 1.0, 1.0), cloudColor);
  
  return float4(cloudColor, min(0.95, a));
};

min16float4 calcClouds(min16float3 pos){
	min16float4 cloud = min16float4(0.0, 0.0, 0.0, 0.0);
	
	min16float x = pos.x;
	min16float z = pos.z;


	cloud.a = unrealPos(x ,z, 6.0);

	x *= 2.0 * (cloud.a*4.0);
	z *= 2.0 * (cloud.a*4.0);
	z += TIME * 0.05;
	x += TIME * 0.001;

	cloud.a = max(0.0, sin(x - cos(z*2.0)));
	cloud.a = clacCodeBasedNoiseTexture(min16float2(x, z));
	cloud.a = (lerp(clacCodeBasedNoiseTexture((min16float2(x, z*0.7))*5.0), cloud.a, cloud.a)*max(0.0, cloud.a))*2.0;
	cloud.a *= 0.2;
	cloud.a -= cloud.a * 0.2 * cloud.a;
	cloud.a *= max(0.0, min(1.0, unrealPos(pos.x, pos.z, 4.0)));

	cloud = CloudColor(cloud.a, FOG_COLOR.rgb);
	
	return cloud;
};

float4 AllReflections(min16float3 CamPos, min16float3 p, float sky_height, float3 sky_color, float YO){
	
	float3 AllR = sky_color;
		
	min16float3 CloudPos = worldPosToCloudPos(float3(0.0, 1.75, 0.0), p, YO, sky_height);
	float4 cloudReflection = calcClouds(CloudPos);
	
	min16float dis = length(CloudPos.xz);
	float3 HSky_color = lerp(sky_color, FOG_COLOR.rgb, clamp(dis*1.3, 0.0, 1.0));
	
	AllR = lerp(HSky_color, cloudReflection.rgb, 1.0-max(0.0, min(1.0, cloudReflection.a*0.2)));
	
	
	return float4(AllR, cloudReflection.a);
};

float4 waterColor(float4 Reflection, float a, float3 waterColor, float YO, float uvL){
	float4 wC = float4(lerp(waterColor, Reflection.rgb, min(1.0, max(0.0, a + Reflection.a - 0.035-YO)) - (1.0 - uvL*1.2)), a);
	return wC;
};



//SETTINGS!

//some variables YOU don't know xD
  //static const highp float pi = 3.14159265358979;

//Settings for the Shadows
    static const float shwE = 0.870; //The width of the Shadows... If you set it to 0.0 there will also be Sunlight in a cave :P
    static const float2 fSwE = float2(0.025, 1.0 / 0.025); //import: if you change the first, you must also change the third number! The 1.0 always(!) stays the same... but if you want you can also try to change it xD. If you want to know what that does: that the width of the fade in!
  
  static const bool Player_Shadow = true;
  
//for the water :D
	static const bool RefractionWaterWaves = false;
  //static const bool cloud_reflection = false; //not working on Win10!
  static const float4 watercolor = float4(0.0,0.0,0.9,0.05); //the water color near you
  static const float4 farwatercolor = float4(0.1, 0.3, 0.7, 0.9); //the water color in the distance...

//torchlight!!1!
  static const float3 torch_light = float3(0.5,0.45,0.05);
  
//Cave fog
  //static const bool Cave_fog = true;

  static const float3 UNIT_Y = float3(0.0,1.0,0.0);
  static const float maxDist = 0.9579790980632242;
  
void main( in PS_Input PSInput, out PS_Output PSOutput )
{
#ifdef BYPASS_PIXEL_SHADER
    PSOutput.color = float4(0.0f, 0.0f, 0.0f, 0.0f);
    return;
#else


float shE = 0.0;
float fadeInE = 0.0;

float blurRadius = 30.0;

float Red = 0.0;

float3 torchl = torch_light;

float tlmix = 0.0;

float4 raincolor = float4(0.441,0.46,0.484, 0.0);
float holefog = FOG_COLOR.r+FOG_COLOR.g+FOG_COLOR.b;
float2 itsnight = float2(0.0, 0.0);
float nether = 0.0;
float uw = 0.0; //underwater
float3 fixPos = PSInput.fragPos.xyz + VIEW_POS.xyz;
float3 posE = PSInput.fragPos;
min16float3 RposE = posE + VIEW_POS.xyz;
bool water = false;


//Far Water fix
if(frac(RposE.y) < 0.1 && frac(RposE.y) >= 0.0 && PSInput.color.r < 0.85 && PSInput.color.b > PSInput.color.g){
	#ifdef FOG
		water = true;
	#endif
}

#ifdef NEAR_WATER
	water = true;
#endif

//is it night?
if(holefog <= 0.4){
    itsnight.r = 1.0;
    itsnight.g = 1.0-holefog*1.0;
}

//rainy?


  
float rain = min(1.0, max(0.0, 1.0 - pow(FOG_CONTROL.y, 5.0))*2.0); 
raincolor.a = min(0.5,length(PSInput.fragPos.xyz)/RENDER_DISTANCE)*2.0;
raincolor.a = min(1.0, raincolor.a + 0.3);
raincolor.a = max(0.0, raincolor.a - max(0.0, PSInput.uv1.x - 0.5)) * rain;
raincolor.rgb = lerp(raincolor.rgb, FOG_COLOR.rgb, raincolor.a);
raincolor.a = max(0.0, raincolor.a - max(0.0, 0.8 - PSInput.uv1.y));


//check if we are underwater
if(FOG_CONTROL.x <= 0.01){uw = 1.0;}

//For the side of the screen, 0.0 if it is a the side...
float sideOfS = max(0.0,length(PSInput.RealScreenPos.xy));

sideOfS = (0.55 + min(max((PSInput.RealScreenPos.z-1.0)*0.1,0.0),0.45)) - max(0.0,sideOfS);
sideOfS = max(min( sideOfS *10.0, 1.0), 0.0);

float2 newUv0 = PSInput.uv0 + rando(PSInput.uv0)*0.0004;

//newUv0 = lerp(newUv0, PSInput.uv0 + 0.3 * 0.0004, sideOfS);

#if !defined(TEXEL_AA) || !defined(TEXEL_AA_FEATURE) || (VERSION < 0xa000 /*D3D_FEATURE_LEVEL_10_0*/) 
	float4 diffuse = TEXTURE_0.Sample(TextureSampler0, PSInput.uv0 );
	float4 ndiffuse = TEXTURE_0.Sample(TextureSampler0, newUv0);
	//float4 skyColor = TEXTURE_1.Sample( TextureSampler1, UNIT_Y.xy );
	
	//diffuse.rgb = skyColor.rgb;
	
	//float time = 1.0 - ((length(skyColor.rgb)) / maxDist); 
#else
	float4 diffuse = texture2D_AA(TEXTURE_0, TextureSampler0, PSInput.uv0 );
	float4 ndiffuse = texture2D_AA(TEXTURE_0, TextureSampler0, newUv0 );
#endif

if(ndiffuse.a == 0.0){
	ndiffuse = diffuse;
}

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
	ndiffuse *= TEXTURE_1.Sample(TextureSampler1, PSInput.uv1);

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
	ndiffuse.rgb *= PSInput.color.rgb;
#else
	float2 uv = PSInput.color.xy;
	diffuse.rgb *= lerp(1.0f, TEXTURE_2.Sample(TextureSampler2, uv).rgb*2.0f, PSInput.color.b);
	diffuse.rgb *= PSInput.color.aaa;
	
	ndiffuse.rgb *= lerp(1.0f, TEXTURE_2.Sample(TextureSampler2, uv).rgb*2.0f, PSInput.color.b);
	ndiffuse.rgb *= PSInput.color.aaa;
	
	diffuse.a = 1.0f;
#endif

#ifdef FOG
	if(nether == 0.0){
		diffuse.rgb = lerp( diffuse.rgb, PSInput.fogColor.rgb, PSInput.fogColor.a);
		ndiffuse.rgb = lerp( ndiffuse.rgb, PSInput.fogColor.rgb, PSInput.fogColor.a);
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
	shE = max(0.0,(shE) - max(0.0, PSInput.uv1.x - 0.5) * 5.0);
}



#ifdef FOG
	shE = max(0.0,shE-PSInput.fogColor.a*5.0);
#endif

//Water Color
if(water){
	/*
	if(uw == 0.0){
		float3 odi = diffuse.rgb;
		diffuse = lerp(float4(0.2, 0.3, 0.7, 0.3), float4(0.2, 0.5, 0.6, 0.7), PSInput.color.a);
		
		
		
		float rscale = 0.15; 
	float refrac = wave1(posE.xy + float2(0.5, 0.9) * 1.5 * rscale, 0.7, 1.8, - TIME*1.2) *  wave1(posE.xz * 0.5 * rscale, 1.12, 1.3, TIME*1.3)*wave1(posE.zx * 0.9 * rscale, 1.62, 0.5, TIME*1.6);
	
	float3 waterC = float3(0.1, 0.2, 1.9);
	
	float XZl = length(posE.xyz);
	
	float transparenzy = 1.0;//clamp((XZl/RENDER_DISTANCE)*10.5, 0.5, 1.0)*1.5;
	
	diffuse = waterColor(AllReflections(float3(0.0, 1.75, 0.0), posE.xyz, 200.0,  float3(0.1, 0.35, 0.7), refrac*5.0), transparenzy, waterC, 0.0, PSInput.uv1.y);
		
	}*/
	diffuse = lerp(float4(0.2, 0.3, 0.7, 0.3), float4(0.2, 0.5, 0.6, 0.7), PSInput.color.a);
}

if(RefractionWaterWaves){

	min16float x = fixPos.x;
	min16float z = fixPos.z;
	
	float wa = sin(x-z+0.5)-cos(x*2.0-z);
  
	diffuse.rgb *= max(1.0, wa*52.0);
}

//sunlight
float isl_f = 1.0-(diffuse.r+diffuse.g+diffuse.b)/3.0;
float4 isl_v = float4(1.0+isl_f,0.9+isl_f,0.8+isl_f,1.0);

isl_v.rgb *= 1.0-shE*1.1;
#ifdef FOG
	isl_v *= max(0.0, 1.0 - min(1.0, max(0.0, PSInput.fogColor.a - 0.7) * 0.5));
#endif

isl_v.rgb = max(float3(1.0, 1.0, 1.0), isl_v.rgb);


diffuse.rgb *= isl_v.rgb;
ndiffuse.rgb *= isl_v.rgb;

float4 ug = float4(1.0, 1.0, 1.0, 1.0);
ug.a = min(1.0, max(0.0, (PSInput.uv1.y * 1.3) + max(0.0, PSInput.uv1.r - 0.5) + 0.7));
ug.rgb = float3(0.32, 0.35, 0.55);



if(nether == 1.0){
	raincolor.a = min(1.0, raincolor.a+0.2);
	raincolor.rgb = lerp(float3(0.76, 0.3, 0.2), FOG_COLOR.rgb, raincolor.a);
	ug.rgb = FOG_COLOR.rgb;
	ug.a = 1.0;
}


if(uw == 0.0){
diffuse.rgb = lerp(ug.rgb, diffuse.rgb, ug.a);
diffuse.rgb = lerp(diffuse.rgb, raincolor.rgb, raincolor.a);

ndiffuse.rgb = lerp(ug.rgb, ndiffuse.rgb, ug.a);
ndiffuse.rgb = lerp(ndiffuse.rgb, raincolor.rgb, raincolor.a);
}

diffuse.rgb += torchl * max(0.0, PSInput.uv1.r - 0.5);
ndiffuse.rgb += torchl * max(0.0, PSInput.uv1.r - 0.5);



if(itsnight.r == 1.0){
  float3 oldd = diffuse.rgb;
  float mixn = max(0.0, itsnight.g - PSInput.uv1.r);
 
  mixn = lerp(0.0, mixn, max(0.0, PSInput.uv1.g - 0.2)*2.1);
 
	oldd.r *= 0.1;
	oldd.g *= 0.3;
	oldd.b *= 0.5;
	#ifndef FOG
		diffuse.rgb = lerp(diffuse.rgb, oldd*1.85, mixn);
		ndiffuse.rgb = lerp(ndiffuse.rgb, oldd*1.85, mixn);
	#else
		diffuse.rgb = lerp(diffuse.rgb, oldd*1.85, max(0.0, mixn - PSInput.fogColor.a));
		ndiffuse.rgb = lerp(ndiffuse.rgb, oldd*1.85, max(0.0, mixn - PSInput.fogColor.a));
		
	#endif
}

if(!water){
	float3 olddiffuse = diffuse.rgb;
	diffuse.rgb = lerp(ndiffuse.rgb, diffuse.rgb, /*- 0.6);*/ sideOfS - max(0.0, 0.8 - min(0.8, PSInput.RealScreenPos.z)));
		
}

	//diffuse.rgb *= time;
	PSOutput.color = EnergyColorMap(diffuse);

#ifdef VR_MODE
	// On Rift, the transition from 0 brightness to the lowest 8 bit value is abrupt, so clamp to 
	// the lowest 8 bit value.
	PSOutput.color = max(PSOutput.color, 1 / 255.0f);
#endif

#endif // BYPASS_PIXEL_SHADER
}