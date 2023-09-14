// __multiversion__
// This signals the loading code to prepend either #version 100 or #version 300 es as apropriate.

#include "shaders/vertexVersionCentroidUV.h"

#include "shaders/uniformWorldConstants.h"

attribute POS4 POSITION;
attribute vec2 TEXCOORD_0;


varying POS3 pos;

void main()
{
	pos = POSITION.xyz;
	pos.z *= 3.0;
	pos.x *= 3.0;
    gl_Position = WORLDVIEWPROJ * vec4(pos, POSITION.w);

    uv = TEXCOORD_0;
}