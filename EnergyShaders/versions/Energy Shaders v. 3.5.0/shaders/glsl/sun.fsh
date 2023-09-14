// __multiversion__
// This signals the loading code to prepend either #version 100 or #version 300 es as apropriate.

#include "shaders/fragmentVersionCentroid.h"

#if __VERSION__ >= 300

#if defined(TEXEL_AA) && defined(TEXEL_AA_FEATURE)
_centroid in highp vec2 uv;
#else
_centroid in vec2 uv;
#endif

#else

varying vec2 uv;

#endif

#include "shaders/uniformShaderConstants.h"
#include "shaders/util.h"
#include "shaders/uniformPerFrameConstants.h"

uniform sampler2D TEXTURE_0;

varying POS3 pos;

void main()
{

bool moon = false;
bool sun = false;

vec4 correct = texture2D( TEXTURE_0, uv );

if((correct.r-0.1) > correct.g){
	sun = true;
}else if(correct.g > (correct.r-0.1)){
	moon = true;
}

vec4 diffuse = vec4(FOG_COLOR.rgb, 1.0);

diffuse.r *= 2.0;

//#ifdef ALPHA_TEST
	//if(diffuse.a < 0.5)
	//	discard;
//#endif

//WARNING THIS VALUE IS IMPORTANT, DONOT CHANGE IT TO 0.5!!!
float magicValueToFixSomeShitDonNotDeleteThisExtremlyMagicalAndImportValue = 2.0;

float l_big = max(0.0, (1.0 - length(pos.xz)) * max(0.0, 1.0 - length(pos.xz*2.0)));;
float l_small = max(0.0, 1.0 - length(pos.xz)*5.0);

	//diffuse.rgb = vec3(l_small* max(0.0, 1.0-l_small))*magicValueToFixSomeShitDonNotDeleteThisExtremlyMagicalAndImportValue;
	diffuse.rgb *= vec3(l_big);
	diffuse.rgb = min(vec3(1.0), diffuse.rgb);
	diffuse.a = 1.0;
	
	if(moon){
		diffuse.rgb = vec3(l_small*1.5);
		diffuse.rgb += vec3(l_big)*1.15;
	}

	gl_FragColor = CURRENT_COLOR * diffuse;//min(vec4(2.0), (CURRENT_COLOR * max(0.0, 1.5-CURRENT_COLOR.r)) * diffuse + vec4(l_small, l_small, l_small, 1.0));
}
