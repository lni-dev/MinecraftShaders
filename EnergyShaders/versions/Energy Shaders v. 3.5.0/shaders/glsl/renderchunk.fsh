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
varying highp vec3 cp;

uniform sampler2D TEXTURE_0;
uniform sampler2D TEXTURE_1;
uniform sampler2D TEXTURE_2;
uniform sampler2D TEXTURE_3;



#include "shaders/settings.h"
#include "shaders/util.h"
#include "shaders/cloud.h"
#include "shaders/ambient.h"
#include "shaders/water.h"
#include "shaders/normal.h"

void main()
{

#ifdef BYPASS_PIXEL_SHADER
	gl_FragColor = vec4(0, 0, 0, 0);
	return;
#else

vec3 N = calculateSurfaceNormal(cp);

bool water = false;

//float t = colorT(uv0,(fragPos.xyz+VIEW_POS.xyz), vec4(0.0), N).a;

//vec3 vV = normalize(fragPos.xyz - vec3(0.0, 1.75, 0.0));
//vV *= t;

vec4 diffuse = texture2D( TEXTURE_0, uv0);

#ifdef NEAR_WATER
	water = true;
#endif

//fix far water bug
if(diffuse.a < 0.5 && diffuse.a > 0.1 && diffuse.r == 0.0 && color.g*diffuse.g <= 0.01 && color.b*diffuse.b <= 0.01 /*&& fract(fragPos.y+VIEW_POS.y) < 0.7*/){
		water = true;
}

diffuse = doColor(fragPos.xyz, vec3(0.0), screenPos, uv0, uv1, diffuse, water, N);

//diffuse.rgb *= N;

if(water){
	diffuse = doWater(fragPos.xyz, vec3(0.0), diffuse, N);

}else{
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
}


gl_FragColor = diffuse;

#endif // BYPASS_PIXEL_SHADER
}
