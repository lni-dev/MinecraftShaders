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

#else


#endif

uniform MAT4 WORLDVIEWPROJ;
uniform vec4 FOG_COLOR;
uniform vec4 CURRENT_COLOR;

attribute mediump vec4 POSITION;
attribute vec4 COLOR;

varying vec4 color;
varying POS3 pos;

const float fogNear = 0.3;

void main()
{
    pos = POSITION.xyz;
    gl_Position = WORLDVIEWPROJ * POSITION;

    color = mix( CURRENT_COLOR, FOG_COLOR, COLOR.r );
}