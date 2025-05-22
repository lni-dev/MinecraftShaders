
// uniforms, varings etc
uniform sampler2D Sampler0;
uniform sampler2D Sampler1;
uniform sampler2D Sampler2;

uniform vec4 ColorModulator;
uniform float FogStart = 1.0;
uniform float FogEnd = 1.0;
uniform vec4 FogColor = vec4(0.0);
uniform int FogShape = 0;

in vec4 vertexColor;
in vec4 overlayColor;
in vec2 texCoord0;
in vec2 texCoord2;
in vec4 normal;

in VEC3 inChunkPos;
in VEC4 inWorldPos;
in VEC4 inScreenPos;
in float projMat3x;

out VEC4 fragColor;

#moj_import <main.glsl>


