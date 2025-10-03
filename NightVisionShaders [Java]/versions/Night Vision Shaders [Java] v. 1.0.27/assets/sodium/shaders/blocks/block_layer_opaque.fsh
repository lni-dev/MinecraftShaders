#version 330 core

#define ES_SODIUM

#import <minecraft:include/compatibility.glsl>
#import <minecraft:include/es-settings.glsl>
#import <minecraft:include/.es-settings.default.glsl>
#import <minecraft:include/struct-defs.glsl>
#import <minecraft:include/checks.glsl>
#import <minecraft:include/tonemaps.glsl>
#import <minecraft:include/render.glsl>


in vec4 v_ColorModulator; // The interpolated vertex color
in vec2 v_TexCoord; // The interpolated block texture coordinates
in vec2 v_LightCoord;

in float v_MaterialMipBias;
in float v_MaterialAlphaCutoff;

in VEC3 inChunkPos;
in VEC4 inWorldPos;
in VEC4 inScreenPos;

uniform sampler2D u_BlockTex; // The block atlas texture
uniform sampler2D u_LightTex; // The light map texture

uniform vec4 u_FogColor; // The color of the shader fog
uniform float u_FogStart; // The starting position of the shader fog
uniform float u_FogEnd; // The ending position of the shader fog
uniform int u_FogShape;

out vec4 out_FragColor; // The output fragment for the color framebuffer

#import <minecraft:include/main.glsl>