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




#define E_FOG
#define USE_MOJANG_FOG_COLOR
#define E_FOG_COLOR float3(0.3, 0.4, 0.7)
#define MIX_E_FOG_WITH_MOJANG_FOG
#define E_UNDERWATER_FOG
#define E_UNDERWATER_FOG_COLOR float3(0.2, 0.4, 0.8)

#define E_SHADOW
#define E_SHADOW_WIDTH 0.87
#define E_SHADOW_FADE_IN
#define CAVE_DARKNESS 0.2
#define FADE_IN_E_SHADOW_WIDTH float2(0.025, 1.0 / 0.025)

//#define USE_MOJANG_TORCH_LIGHT_AND_SHADOW

#define E_TORCH_LIGHT
#define E_TORCH_LIGHT_COLOR float3(1.3, 0.95, 0.25)
#define E_TORCH_LIGHT_OFFSET -0.4
//#define USE_TORCH_LIGHT_OF_CHRISMAS_SHADERS
//#define EXPERIMENTAL_LIGHT

#define ENERGY_COLOR_MAP
#define SUN_LIGHT
#define FOG_BASED_NIGHT_LIGHT
#define SCREEN_BASED_BLOOM

#define TRANSPARENT_WATER
#define TRANSPARENT_WATER_OFFSET 0.65
#define E_WATER
#define E_WATER_COLOR_NEAR float3(0.1, 0.3, 0.5)
#define E_WATER_COLOR_FAR float3(0.3, 0.5, 0.6)

#define REFLECTION
#define WATER_COLOR float3(0.1, 0.25, 0.5)	//Only If REFLECTION is defined!
#define E_SKY_COLOR float3(0.1, 0.35, 0.7)
#define SKY_HEIGH 270.0

#define FAKE_BUMP_EFFECT	//A generated 3D effect - looks weird sometimes!
#define FACT 0.00065

//REFLECTION
#define SKY_COLOR float4(0.1, 0.35, 0.7, 0.5)

#define CLOUD 									//No, I don`t mean the Youtuber, sry

#define CLOUD_Z_MOVE_SCALE 0.05					//This sets how fast and in which
#define CLOUD_X_MOVE_SCALE 0.001				//direction the clouds are moving!

#define ROUND_SKY_FACTOR 4.0					//This two numbers will change the roundness of the sky,
#define ROUND_SKY_FACTOR_TOO 15.0				//It is hard to explain, so just play a bit through with it!

#define CLOUD_RAIN_COLOR float3(0.25, 0.3, 0.3)

#define MIX_SKY_AND_FOG							//recommend
//END




/*float hash( float n )
{
  return frac(cos(n)*41415.92653);
}

float Enoise( float3 x )
{
  float3 p  = floor(x);
  float3 f  = smoothstep(0.0, 1.0, frac(x));
  float n = p.x + p.y*57.0 + 113.0*p.z;

  return lerp(lerp(lerp( hash(n+  0.0), hash(n+  1.0),f.x),lerp( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),lerp(lerp( hash(n+113.0), hash(n+114.0),f.x),lerp( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
}

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

    return s;//1.0
}

float st2(float2 p){
	float s;
    float ss = 2.0;
    float f = 45.0;

   	p += floor(p * (f));

    s = sin(p.x + TIME * ss) * sin(p.y + TIME * ss);

    return s;//0.3
}*/

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

/**
*returns the difference of the two given colors from 0.0 to ...
*/
float getColorDifference(float3 c1, float3 c2){
	float3 d = abs(c1 - c2);	//think about using length function
	return (d.r + d.g*0.0f + d.b);//1.0f;
}


float getRain(){
  return min(1.0, max(0.0, 1.0-pow(FOG_CONTROL.y,5.0))*2.0);
};

float clacCodeBasedNoiseTexture(min16float2 a){
  float ca = sin(a.x + TIME*0.1 + a.y - a.x + sin(a.x+TIME*0.1) + cos(a.y + a.y - a.x));
  float cc = sin(a.x+(cos(a.y)*0.1));
  float cd = 0.0;

  return ca*1.5*cc;
};

float getFlackering(min16float t){

	t*=0.005;

	t *= abs(sin(t) + cos(t)) / 2 + 0.5f;

	t*= 200;

	float f = cos(t*1.2) + sin(t);
	f /= 2.0f;

	f += cos(t/2);
	f *= sin(t/4);

	f += cos(t + 45.0f);
	f -= sin(cos(t*0.05f) * sin(t*0.02f) * 90.0f);

	f *= 0.5f;

	return abs(f);
}










  static const float3 UNIT_Y = float3(0.0,1.0,0.0);
  static const float maxDist = 0.9579790980632242;




void main( in PS_Input PSInput, out PS_Output PSOutput )
{
	//if pixel shader is used, return 0.0f
#ifdef BYPASS_PIXEL_SHADER
    PSOutput.color = float4(0.0f, 0.0f, 0.0f, 0.0f);
    return;
#else

//SOME VALUES
	float4 fog = float4(E_FOG_COLOR, 0.0f);
	float shadow = 0.0f; //0.0 = no shadow - 1.0 = full shadow

	#ifdef FAKE_BUMP_EFFECT
		float2 mUv = float2(PSInput.uv0.x- 0.1f * FACT, PSInput.uv0.y - 0.2f * FACT);	//another uv for the 3D effect
	#endif

	bool water = false; //Rendering on water?
	bool nether = false; //Rendering in the nether?
	bool underwater = false; //Rendering underwater?
//END

//SET
#ifdef NEAR_WATER
	water = true;	//if we are rendering water set water to true

#else
	//if the fog starts directly at the player, we are underwater!
	if(FOG_CONTROL.x < 0.01){
		underwater = true;
	}

#endif

#ifdef USE_MOJANG_FOG_COLOR
	fog = FOG_COLOR;	//if the standard Fog should be used set the Fog to the standard
#endif

//END

//Get Color of the current texture
#if !defined(TEXEL_AA) || !defined(TEXEL_AA_FEATURE) || (VERSION < 0xa000 /*D3D_FEATURE_LEVEL_10_0*/)
	float4 diffuse = TEXTURE_0.Sample(TextureSampler0, PSInput.uv0 );

	#ifdef FAKE_BUMP_EFFECT	//For the fake 3D effect calculate another color
		float4 dxm = TEXTURE_0.Sample( TextureSampler0, float2(mUv.x, PSInput.uv0.y) );
		float4 dym = TEXTURE_0.Sample( TextureSampler0, float2(PSInput.uv0.x, mUv.y) );
	#endif

#else
	float4 diffuse = texture2D_AA(TEXTURE_0, TextureSampler0, PSInput.uv0 );

	#ifdef FAKE_BUMP_EFFECT //For the fake 3D effect calculate another color
		float4 dxm = texture2D_AA(TEXTURE_0, TextureSampler0, float2(mUv.x, PSInput.uv0.y) );
		float4 dym = texture2D_AA(TEXTURE_0, TextureSampler0, float2(PSInput.uv0.x, mUv.y) );
	#endif

#endif

//diffuse.rgb = float3(0.75, 0.75, 0.75);

#ifdef FAKE_BUMP_EFFECT
	float4 d5 = lerp(dxm, dym, 0.5);	//Now mix (lerp in hlsl) the two extra colors we have got
#endif

if(PSInput.color.g <= PSInput.color.r){	//this ignores grass, because it looks super creepy
	diffuse.rgb = lerp(diffuse.rgb, float3(diffuse.rgb * 0.5), max(0.0, min(1.0, getColorDifference(diffuse.rgb, d5.rgb)*3.0)) );
}

//fix far water bug - ESPE changes the water texture to a half transparent black texture, so it is easy to detect without
//messing up other stuff
if(diffuse.a < 0.5f && diffuse.a > 0.1f && diffuse.r == 0.0f && PSInput.color.g*diffuse.g <= 0.01f && PSInput.color.b*diffuse.b <= 0.01f){
		water = true;
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

#ifdef USE_MOJANG_TORCH_LIGHT_AND_SHADOW
	#if !defined(ALWAYS_LIT)
		diffuse = diffuse * TEXTURE_1.Sample(TextureSampler1, PSInput.uv1);
	#endif
#endif

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

#ifdef TRANSPARENT_WATER
	if(water){
		float le = length(PSInput.fragPos.xz) / (RENDER_DISTANCE * 0.5f) + TRANSPARENT_WATER_OFFSET;

		diffuse.a = min(1.0f, le);

	}
#endif

#ifdef E_WATER
	if(water){
		diffuse.rgb = lerp(E_WATER_COLOR_NEAR, E_WATER_COLOR_FAR, diffuse.a - TRANSPARENT_WATER_OFFSET);
	}
#endif

#ifdef E_SHADOW
	if(PSInput.uv1.y <= E_SHADOW_WIDTH){	//if rendering in shadow

		shadow = 1.0f;

		if(PSInput.uv1.y >= E_SHADOW_WIDTH - FADE_IN_E_SHADOW_WIDTH.x){
			#ifdef E_SHADOW_FADE_IN
				float fadeInE = (PSInput.uv1.y - (E_SHADOW_WIDTH - FADE_IN_E_SHADOW_WIDTH.x)) * FADE_IN_E_SHADOW_WIDTH.y;	//calculate fade in
				shadow = lerp(1.0f, 0.0f, fadeInE);
			#endif
		}
		shadow = max(0.0f, shadow - max(0.0f, PSInput.uv1.x + E_TORCH_LIGHT_OFFSET));
	}
#endif

#ifdef E_TORCH_LIGHT
	#ifdef USE_TORCH_LIGHT_OF_CHRISMAS_SHADERS
		diffuse.rgb = lerp(diffuse.rgb, float3(0.7f, 0.3f, 0.2f), max(0.0f, PSInput.uv1.x - 0.6f)*(abs(sin(TIME*5.0f-cos(TIME*2.0f)+sin(TIME)))*0.5+1.5));	//TODO: Messed up
	#else
		float3 experimental = float3(1.0f, 1.0f, 1.0f);

		#ifdef EXPERIMENTAL_LIGHT
			experimental =  diffuse.rgb * (float3(1.0f, 1.0f, 1.0f) - diffuse.rgb) * 2.7f;
		#endif

		//diffuse.rgb += max(float3(0.0f, 0.0f, 0.0f), E_TORCH_LIGHT_COLOR * (PSInput.uv1.x + E_TORCH_LIGHT_OFFSET)) * experimental;
		float3 light = E_TORCH_LIGHT_COLOR;
		float lightValue = max(0.0, PSInput.uv1.x + E_TORCH_LIGHT_OFFSET);

		diffuse.rgb *= max(float3(1.0f, 1.0f, 1.0f), light * (lightValue+1.0)*experimental);

	#endif
#endif

#ifdef E_SHADOW
	diffuse.rgb = lerp(diffuse.rgb, diffuse.rgb * max(CAVE_DARKNESS, min(0.5f, PSInput.uv1.y)), shadow);
#endif

#ifdef SUN_LIGHT
	diffuse.rgb *= max(float3(0.0f, 0.0f, 0.0f), float3(0.7f, 0.7f, 0.7f) - diffuse.rgb) * 1.5f + float3(1.0, 1.0f, 1.0f);
#endif

#ifdef FOG_BASED_NIGHT_LIGHT
	float ff = max(0.0f, 1.0f - PSInput.uv1.y * 0.7f) + max(0.0f, PSInput.uv1.x + E_TORCH_LIGHT_OFFSET);//0.3f+max(0.0, PSInput.uv1.x-0.5f)*1.2f;
	diffuse.rgb *= max(float3(ff, ff, ff), min(float3(0.5f, 0.5f, 0.5f), FOG_COLOR.rgb*2.0f) * 2.0f);

	float3 night = float3(1.0f, 1.0f, 1.0f);

	night.r = lerp(lerp(diffuse.g, diffuse.b, 0.5), diffuse.r, 0.5);
	night.g = lerp(lerp(diffuse.r, diffuse.b, 0.5), diffuse.g, 0.5);
	night.b = lerp(lerp(diffuse.r, diffuse.g, 0.5), diffuse.b, 0.5);

	diffuse.rgb = lerp(night, diffuse.rgb, min(1.0, max(float3(ff, ff, ff), FOG_COLOR.rgb*2.0)));
#endif

#ifdef ENERGY_COLOR_MAP
	diffuse = EnergyColorMap(diffuse);
#endif

//Don't use #ifdef FOG here, to fix the cutted fog bug - add it again if it hurts performance to much
#ifdef E_FOG
	float le = length(PSInput.fragPos.xz);

	if(underwater){
		#ifdef E_UNDERWATER_FOG
			le *= 0.1f;
			le = min(1.0f, le);
			#ifdef MIX_E_FOG_WITH_MOJANG_FOG
				fog.rgb = lerp(E_UNDERWATER_FOG_COLOR, fog.rgb, le);
			#endif

			diffuse.rgb = lerp(diffuse.rgb, fog.rgb, le);
		#endif
	}

	if(!underwater){

		le /= RENDER_DISTANCE;
		le = min(1.0f, le);

		#ifdef MIX_E_FOG_WITH_MOJANG_FOG
			fog.rgb = lerp(E_FOG_COLOR, fog.rgb, le);
		#endif

		diffuse.rgb = lerp(diffuse.rgb, fog.rgb, max(0.0f, le - 0.2f));
		diffuse.a = max(min(1.0f, fog.a * le), diffuse.a);
	}
#endif

#ifdef SCREEN_BASED_BLOOM
	diffuse.rgb = lerp(diffuse.rgb, diffuse.rgb*0.2f, max(0.0f, length(PSInput.RealScreenPos.xy)-0.3f));
#endif

	PSOutput.color = diffuse * float4(0.9f, 0.9f, 0.9f, 1.0f);

#ifdef VR_MODE
	// On Rift, the transition from 0 brightness to the lowest 8 bit value is abrupt, so clamp to
	// the lowest 8 bit value.
	PSOutput.color = max(PSOutput.color, 1 / 255.0f);
#endif

#endif // BYPASS_PIXEL_SHADER
}
