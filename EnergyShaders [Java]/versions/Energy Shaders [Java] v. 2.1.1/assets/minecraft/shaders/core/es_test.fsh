#version 150

#define ES_JAVA

#moj_import <compatibility.glsl>
#moj_import <settings.glsl>

uniform sampler2D Sampler0;
uniform sampler2D Sampler1;
uniform sampler2D Sampler2;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform int FogShape;
uniform mat3 IViewRotMat;
uniform int ES_RenderInfo;

in vec4 vertexColor;
in vec4 overlayColor;
in vec2 texCoord0;
in vec2 texCoord2;
in vec4 normal;

in VEC3 inChunkPos;
in VEC4 inWorldPos;
in VEC4 inScreenPos;

out VEC4 fragColor;


void main() {

    ES_COLOR_OUT = VEC4(1.0);
}
