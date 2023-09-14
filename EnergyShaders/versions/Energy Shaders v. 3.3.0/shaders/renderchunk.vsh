// __multiversion__
// This signals the loading code to prepend either #version 100 or #version 300 es as apropriate.

// To use centroid sampling we need to have version 300 es shaders, which requires changing:
// attribute to in
// varying to out when in vertex shaders or in when in fragment shaders
// defining an out vec4 FragColor and replacing uses of gl_FragColor with FragColor
// texture2D to texture
#if __VERSION__ >= 300
	#define attribute in
	#define varying out

	#ifdef MSAA_FRAMEBUFFER_ENABLED
		#define _centroid centroid
	#else
		#define _centroid
	#endif

	#ifndef BYPASS_PIXEL_SHADER
		_centroid out vec2 uv0;
		_centroid out vec2 uv1;
	#endif
#else
	#ifndef BYPASS_PIXEL_SHADER
		varying vec2 uv0;
		varying vec2 uv1;
	#endif
#endif

#ifndef BYPASS_PIXEL_SHADER
	varying vec4 color;
 //The position for the fragment shader, for water clac, etc
 varying POS3 fragPos;
	varying POS3 screenPos;
#endif

#ifdef AS_ENTITY_RENDERER
	uniform MAT4 WORLDVIEWPROJ;
#else
	uniform MAT4 WORLDVIEW;
	uniform MAT4 PROJ;
#endif
uniform vec4 FOG_COLOR;
uniform vec2 FOG_CONTROL;
uniform float RENDER_DISTANCE;
uniform vec2 VIEWPORT_DIMENSION;
uniform vec4 CURRENT_COLOR;		//current color r contains the offset to apply to the fog for the "fade in"
uniform POS4 CHUNK_ORIGIN_AND_SCALE;
uniform POS3 VIEW_POS;
uniform float FAR_CHUNKS_DISTANCE;

attribute POS4 POSITION;
attribute vec4 COLOR;
attribute vec2 TEXCOORD_0;
attribute vec2 TEXCOORD_1;

const float rA = 1.0;
const float rB = 1.0;
const vec3 UNIT_Y = vec3(0,1,0);
const float DIST_DESATURATION = 56.0 / 255.0; //WARNING this value is also hardcoded in the water color, don'tchange

void main()
{
POS4 pos = vec4(0.0);

    POS4 worldPos;
#ifdef AS_ENTITY_RENDERER
		pos = WORLDVIEWPROJ * POSITION;
		worldPos = pos;
#else
    worldPos.xyz = (POSITION.xyz * CHUNK_ORIGIN_AND_SCALE.w) + CHUNK_ORIGIN_AND_SCALE.xyz;
    worldPos.w = 1.0;
#endif

#ifndef BYPASS_PIXEL_SHADER
    uv0 = TEXCOORD_0;
    uv1 = TEXCOORD_1;
	color = COLOR;
#endif


//calculate the FOG in fragment, looks better

//No need for the this creepy minecraft water calculation, do this later in fragment, looks much better

#ifndef BYPASS_PIXEL_SHADER
#ifndef AS_ENTITY_RENDERER
//Do this at last, maybe some waves are calculated before, so this offest is also in the fragment - just in case -
	pos = WORLDVIEW * worldPos;
	pos = PROJ * pos;

	fragPos = worldPos.xyz;

	screenPos.xy = pos.xy / (pos.z + 1.0);
	screenPos.z = pos.z;
#endif
#endif

gl_Position = pos;

}
