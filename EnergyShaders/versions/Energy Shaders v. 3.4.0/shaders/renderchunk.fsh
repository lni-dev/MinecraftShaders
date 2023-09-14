// __multiversion__
// This signals the loading code to prepend either #version 100 or #version 300 es as apropriate.

// To use centroid sampling we need to have version 300 es shaders, which requires changing:
// attribute to in
// varying to out when in vertex shaders or in when in fragment shaders
// defining an out vec4 FragColor and replacing uses of gl_FragColor with FragColor
// texture2D to texture
#if __VERSION__ >= 300

	// version 300 code

	#ifdef MSAA_FRAMEBUFFER_ENABLED
		#define _centroid centroid
	#else
		#define _centroid
	#endif

	#ifndef BYPASS_PIXEL_SHADER
		#if defined(TEXEL_AA) && defined(TEXEL_AA_FEATURE)
			_centroid in highp vec2 uv0;
			_centroid in highp vec2 uv1;
		#else
			_centroid in vec2 uv0;
			_centroid in vec2 uv1;
		#endif
	#endif

	#define varying in
	#define texture2D texture
	out vec4 FragColor;
	#define gl_FragColor FragColor
#else

	// version 100 code

	#ifndef BYPASS_PIXEL_SHADER
		varying vec2 uv0;
		varying vec2 uv1;
	#endif
#endif


varying vec4 color;
varying POS3 fragPos;
varying POS3 screenPos;

#include "shaders/util.h"


#define E_FOG
#define USE_MOJANG_FOG_COLOR
#define E_FOG_COLOR vec3(0.3, 0.4, 0.7)
#define MIX_E_FOG_WITH_MOJANG_FOG
#define E_UNDERWATER_FOG
#define E_UNDERWATER_FOG_COLOR vec3(0.2, 0.4, 0.8)

#define E_SHADOW
#define E_SHADOW_WIDTH 0.87
#define E_SHADOW_FADE_IN
#define FADE_IN_E_SHADOW_WIDTH vec2(0.025, 1.0 / 0.025)

//#define USE_MOJANG_TORCH_LIGHT_AND_SHADOW

#define E_TORCH_LIGHT
#define E_TORCH_LIGHT_COLOR vec3(0.9, 0.15, 0.05)
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
#define E_WATER_COLOR_NEAR vec3(0.2, 0.3, 0.6)
#define E_WATER_COLOR_FAR vec3(0.1, 0.2, 0.4)

//#define REFLECTION
#define WATER_COLOR vec3(0.1, 0.25, 0.5)	//Only If REFLECTION is defined!
#define E_SKY_COLOR vec3(0.1, 0.35, 0.7)
#define SKY_HEIGH 270.0

//#define FAKE_BUMP_EFFECT	//A generated 3D effect - looks weird sometimes!
#define FACT 0.00065

uniform sampler2D TEXTURE_0;
uniform sampler2D TEXTURE_1;
uniform sampler2D TEXTURE_2;

uniform float RENDER_DISTANCE;
uniform vec4 FOG_COLOR;
uniform vec2 FOG_CONTROL;
uniform highp float TIME;
uniform POS3 VIEW_POS;

vec4 EnergyColorMap(vec4 c){
	float R,G,B;

	R = c.r;
	G = c.g;
	B = c.b;

	R = mix(R,R * 1.5, max(0.0, R - (G + B)));
	G = mix(G,G * 1.5, max(0.0, G - (R + B)));
	B = mix(B,B * 1.5, max(0.0, B - (G + R)));

	return vec4(R, G, B, c.a);
}

//For Reflection

/*========================SETTINGS========================*/
/* You can Edit this to change the look of Energy Shaders */
/*        Energy Shaders is created by Pro Coder          */
/*========================SETTINGS========================*/

#define SKY_COLOR vec4(0.1, 0.35, 0.7, 0.5)

#define CLOUD 									//No, I don`t mean the Youtuber, sry

#define CLOUD_Z_MOVE_SCALE 0.05					//This sets how fast and in which
#define CLOUD_X_MOVE_SCALE 0.001				//direction the clouds are moving!

#define ROUND_SKY_FACTOR 4.0					//This two numbers will change the roundness of the sky,
#define ROUND_SKY_FACTOR_TOO 15.0				//It is hard to explain, so just play a bit through with it!

#define CLOUD_RAIN_COLOR vec3(0.25, 0.3, 0.3)

#define MIX_SKY_AND_FOG							//recommend

/*=====================STOP=====================*/
/* Stop here your Editing without permission of */
/*                   Pro Coder                  */
/*    Energy Shaders is created by Pro Coder    */
/*=====================STOP=====================*/


float getRain(){
  return min(1.0, max(0.0, 1.0-pow(FOG_CONTROL.y,5.0))*2.0);
}

highp float  unrealPos(highp float x, highp float z, float fact){
  highp float factor = length(vec2(x, z));

  return fact - factor * ROUND_SKY_FACTOR_TOO;
}

float clacCodeBasedNoiseTexture(vec2 a){
  float ca = sin(a.x + TIME*0.1 + a.y - a.x + sin(a.x+TIME*0.1) + cos(a.y + a.y - a.x));
  float cc = sin(a.x+(cos(a.y)*0.1));
  float cd = 0.0;

  return ca*1.5/*-cb*/*cc;
}

vec4 CloudColor(float a, vec3 fog, float dis){
  vec3 cloudColor = vec3(1.5);

  cloudColor *= fog*2.0;

  //cloudColor = mix(cloudColor, FOG_COLOR.rgb*1.2, 0.5);


  cloudColor *= mix(vec3(1.0) , CLOUD_RAIN_COLOR, getRain());
  a += 0.3*getRain();


  cloudColor = mix(cloudColor, fog, dis);


  cloudColor = min(vec3(1.0), cloudColor);

  return vec4(cloudColor, min(0.95, a));
}

vec3 worldPosToCloudPos(vec3 n, float sky_height){
	
	//Expand factor
	float Expandfactor = sky_height / n.y;

	//It is now it the heigh of the clouds, and it would be the right refletion, but the sky position doesn't equals the worldPos, so it is still not real :/
	vec3 UnrealCloudPos = n * Expandfactor;


	return (UnrealCloudPos / RENDER_DISTANCE) / 30.0;
}

vec4 calcClouds(POS3 pos){
	vec4 cloud = vec4(0.0);

	highp float dis = length(pos.xz);

	float disForSky = clamp(dis*1.3, 0.0, 1.0);
	float disForClouds = clamp(dis*2.7, 0.0, 2.0);

	disForClouds = disForClouds * max(1.0, 2.0-disForClouds);
	disForClouds = min(1.0, disForClouds - 0.055);


	highp float x = pos.x;
	highp float z = pos.z;


	cloud.a = 1.25 + max(0.0,0.7-disForClouds);//unrealPos(x ,z, ROUND_SKY_FACTOR+2.0);;//unrealPos(x ,z, 6.0);

	x *= 2.0 * (cloud.a*4.0);
	z *= 2.0 * (cloud.a*4.0);

	z += TIME * 0.05;
	x += TIME * 0.001;

	cloud.a = max(0.0, sin(x - cos(z*2.0)));
	cloud.a = clacCodeBasedNoiseTexture(vec2(x, z));
	cloud.a = (mix(clacCodeBasedNoiseTexture((vec2(x, z*0.7))*5.0), cloud.a, cloud.a)*max(0.0, cloud.a))*2.0;
	cloud.a *= 0.2;
	cloud.a -= cloud.a * 0.2 * cloud.a;
	cloud.a *= max(0.0, min(1.0, unrealPos(pos.x, pos.z, 8.0)));



	cloud = CloudColor(cloud.a, FOG_COLOR.rgb, disForClouds);

	//active this for sun reflection
	//cloud.a += ispointnear(pos.xz, vec2(0.0,0.1), 0.4)*10.0;



	return cloud;
}

float circleCosX(POS3 pos){
	return cos(pos.x) * cos(pos.z*0.5) * 0.75;
}

float circleCosZ(POS3 pos){
	return cos(pos.x*0.5) * cos(pos.x) * 0.75;
}

float circleSinX(POS3 pos){
	return sin(pos.x) * sin(pos.z*0.5) * 0.75;
}

float circleSinZ(POS3 pos){
	return sin(pos.x*0.5) * sin(pos.x) * 0.75;
}

float wave(POS3 pos){
	pos *= 10.0;
	float f = 0.0;

	
	f = clacCodeBasedNoiseTexture(pos.xz + sin(vec2(TIME*0.1))*45.0);
	f -= cos(pos.x *3.0+TIME)-sin(pos.z*2.0 +TIME)+cos(pos.z-TIME);
	
	
	
	f*0.1;
	
	return f;
}
float waves(POS3 pos){
	return 0.0;
}


vec4 waterColor(POS3 pos, POS3 CamPos){

	//pos.y += waves(pos);
	vec3 nextPoint = pos + normalize(pos-CamPos)*0.1; //Calculate the next point
	vec3 anp = nextPoint;
	nextPoint.y += waves(nextPoint);
	anp.x += 0.1;
	//now we have all three points of a Polygon, needed to create a normal
	
	vec3 v1 = nextPoint - pos;
	vec3 v2 = anp - pos;

	vec3 mNormal = normalize(cross(v1, v2));
	vec3 mReflect = normalize(reflect(pos, mNormal));
	
	vec3 cloudPos = worldPosToCloudPos(mReflect, SKY_HEIGH);
	
	vec4 cloudReflection = calcClouds(cloudPos);
	
	
	
	vec4 wC = vec4(mix(E_WATER_COLOR_NEAR, E_WATER_COLOR_FAR, 0.5), 1.0);
	
	wC.rgb = mix(wC.rgb, cloudReflection.rgb, cloudReflection.a);
	
	return wC;
}


float getColorDifference(vec3 c1, vec3 c2){
	vec3 d = abs(c1 - c2);	//think about using length function
	return (d.r + d.g*0.0 + d.b);//1.0;
}

void main()
{

#ifdef BYPASS_PIXEL_SHADER
	gl_FragColor = vec4(0, 0, 0, 0);
	return;
#else

vec4 fog = vec4(E_FOG_COLOR, 0.0);
float shE = 0.0;
bool water = false;
bool nether = false;
bool underwater = false;

#ifdef NEAR_WATER
	water = true;
#else

	if(FOG_CONTROL.x < 0.01){
		underwater = true;
	}
#endif

#ifdef USE_MOJANG_FOG_COLOR
	fog = FOG_COLOR;
#endif

highp float fact = 0.00065;

#if !defined(TEXEL_AA) || !defined(TEXEL_AA_FEATURE)
	vec4 diffuse = texture2D( TEXTURE_0, uv0 );
	#ifdef FAKE_BUMP_EFFECT
		vec4 dxm = texture2D( TEXTURE_0, vec2(uv0.x-0.1 * fact, uv0.y) );
		vec4 dym = texture2D( TEXTURE_0, vec2(uv0.x, uv0.y-0.2 * fact) );
	#endif

#else
	vec4 diffuse = texture2D_AA(TEXTURE_0, uv0 );

	#ifdef FAKE_BUMP_EFFECT
		vec4 dxm = texture2D_AA( TEXTURE_0, vec2(uv0.x-0.1 * fact, uv0.y) );
		vec4 dym = texture2D_AA( TEXTURE_0, vec2(uv0.x, uv0.y-0.1 * fact) );
	#endif

#endif


#ifdef FAKE_BUMP_EFFECT
	vec4 d5 = mix(dxm, dym, 0.5);
	if(color.g <= color.r){
		diffuse.rgb = mix(diffuse.rgb, vec3(diffuse.rgb * 0.5),max(0.0, min(1.0, getColorDifference(diffuse.rgb, d5.rgb)*3.0)) );
	}
#endif

//fix far water bug
if(diffuse.a < 0.5 && diffuse.a > 0.1 && diffuse.r == 0.0 && color.g*diffuse.g <= 0.01 && color.b*diffuse.b <= 0.01 /*&& fract(fragPos.y+VIEW_POS.y) < 0.7*/){
		water = true;
}

	vec4 inColor = color;

#ifdef SEASONS_FAR
	diffuse.a = 1.0;
	inColor.b = 1.0;
#endif

#ifdef ALPHA_TEST
	#ifdef ALPHA_TO_COVERAGE
		float alphaThreshold = .05;
	#else
		float alphaThreshold = .5;
	#endif
	if(diffuse.a < alphaThreshold)
		discard;
#endif

#ifdef USE_MOJANG_TORCH_LIGHT_AND_SHADOW
#if !defined(ALWAYS_LIT)
	diffuse = diffuse * texture2D( TEXTURE_1, uv1 );
#endif
#endif

#ifndef SEASONS

	diffuse.rgb *= inColor.rgb;
#else
	vec2 uv = inColor.xy;
	diffuse.rgb *= mix(vec3(1.0,1.0,1.0), texture2D( TEXTURE_2, uv).rgb*2.0, inColor.b);
	diffuse.rgb *= inColor.aaa;
	diffuse.a = 1.0;
#endif

#ifdef TRANSPARENT_WATER
	if(water){
		float le = length(fragPos.xz) / (RENDER_DISTANCE*0.5) + TRANSPARENT_WATER_OFFSET;

		diffuse.a = min(1.0, le*0.75 +0.1);

	}
#endif

#ifdef E_WATER
	if(water){
		#ifdef REFLECTION
			diffuse = waterColor(fragPos.xyz, vec3(0.0, 1.5, 0.0));
		#else
			float le = length(fragPos.xz);

			le /= RENDER_DISTANCE*1.2;
			le = min(1.0, le);
			diffuse.rgb = mix(E_WATER_COLOR_NEAR, E_WATER_COLOR_FAR, diffuse.a - TRANSPARENT_WATER_OFFSET);

			
			diffuse.rgb = mix(diffuse.rgb, FOG_COLOR.rgb, min(1.0, le*le*le*3.0));

		#endif
	}
#endif

#ifdef E_SHADOW
	if(uv1.y <= E_SHADOW_WIDTH){	//if rendering in shadow

		shE = 1.0;

		if(uv1.y >= E_SHADOW_WIDTH - FADE_IN_E_SHADOW_WIDTH.x){
			#ifdef E_SHADOW_FADE_IN
				float fadeInE = (uv1.y - (E_SHADOW_WIDTH - FADE_IN_E_SHADOW_WIDTH.x)) * FADE_IN_E_SHADOW_WIDTH.y;	//calculate fade in
				shE = mix(1.0, 0.0, fadeInE);
			#endif
		}
		shE = max(0.0, shE - max(0.0, uv1.x + E_TORCH_LIGHT_OFFSET));
	}
#endif

#ifdef E_TORCH_LIGHT
	#ifdef USE_TORCH_LIGHT_OF_CHRISMAS_SHADERS
		diffuse.rgb = mix(diffuse.rgb, vec3(0.7, 0.3, 0.2), max(0.0, uv1.x-0.6)*(abs(sin(TIME*5.0-cos(TIME*2.0)+sin(TIME)))*0.5+1.5));
	#else
		vec3 experimental = vec3(1.0);

		#ifdef EXPERIMENTAL_LIGHT
			experimental =  diffuse.rgb * (vec3(1.0) - diffuse.rgb)*2.7;
		#endif

		diffuse.rgb += max(vec3(0.0), E_TORCH_LIGHT_COLOR * (uv1.x + E_TORCH_LIGHT_OFFSET)) * experimental;
	#endif
#endif

#ifdef E_SHADOW
	diffuse.rgb = mix(diffuse.rgb, diffuse.rgb * max(0.3, min(0.5, uv1.y)), shE);
#endif

#ifdef SUN_LIGHT
	diffuse.rgb *= max(vec3(0.0), vec3(0.7) - diffuse.rgb)*1.5 + vec3(1.0);
#endif

#ifdef FOG_BASED_NIGHT_LIGHT
	diffuse.rgb *= max(vec3(0.3+max(0.0, uv1.x-0.5)*1.2), min(vec3(0.5), FOG_COLOR.rgb*2.0) * 2.0);
#endif

#ifdef ENERGY_COLOR_MAP
	diffuse = EnergyColorMap(diffuse);
#endif

//Don't use #ifdef FOG here, to fix the cutted fog bug - add it again if it hurts performance to much
#ifdef E_FOG
	float le = length(fragPos.xz);

	if(underwater){
		#ifdef E_UNDERWATER_FOG
			le *= 0.1;
			le = min(1.0, le);
			#ifdef MIX_E_FOG_WITH_MOJANG_FOG
				fog.rgb = mix(E_UNDERWATER_FOG_COLOR, fog.rgb, le);
			#endif

			diffuse.rgb = mix(diffuse.rgb, fog.rgb, le);
		#endif
	}

	if(!underwater){

		le /= RENDER_DISTANCE;
		le = min(1.0, le);

		#ifdef MIX_E_FOG_WITH_MOJANG_FOG
			fog.rgb = mix(E_FOG_COLOR, fog.rgb, le);
		#endif

		diffuse.rgb = mix(diffuse.rgb, fog.rgb, max(0.0, le - 0.2));
		diffuse.a = max(min(1.0,fog.a * le), diffuse.a);
	}
#endif

#ifdef SCREEN_BASED_BLOOM
	diffuse.rgb = mix(diffuse.rgb, diffuse.rgb*0.2, max(0.0, length(screenPos.xy)-0.3));
#endif

//diffuse.rb *= fract(uv0 * TEXTURE_DIMENSIONS.xy*1.0/16.0);

	gl_FragColor = diffuse;

#endif // BYPASS_PIXEL_SHADER
}
