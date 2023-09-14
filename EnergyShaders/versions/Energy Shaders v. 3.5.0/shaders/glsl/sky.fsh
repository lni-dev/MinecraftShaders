// __multiversion__
// This signals the loading code to prepend either #version 100 or #version 300 es as apropriate.

// To use centroid sampling we need to have version 300 es shaders, which requires changing:
// attribute to in
// varying to out when in vertex shaders or in when in fragment shaders
// defining an out vec4 FragColor and replacing uses of gl_FragColor with FragColor
// texture2D to texture
#if __VERSION__ >= 300

// version 300 code

#define varying in
#define texture2D texture
out vec4 FragColor;
#define gl_FragColor FragColor

#else

// version 100 code

#endif


varying vec4 color;
varying POS3 pos;

#include "shaders/settings.h"
#include "shaders/cloud.h"

uniform sampler2D TEXTURE_3;

//No need for any uniforms or defines, because cloud.h does this! Amazing!

void main()
{
	gl_FragColor = calcSky(pos, TEXTURE_3);
}
