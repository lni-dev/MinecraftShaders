#version 330 core

#define ES_SODIUM

#import <minecraft:include/compatibility.glsl>
#import <minecraft:include/es-settings.glsl>
#import <minecraft:include/.es-settings.default.glsl>
#import <minecraft:include/struct-defs.glsl>
#import <minecraft:include/checks.glsl>
#import <minecraft:include/tonemaps.glsl>
#import <minecraft:include/render.glsl>

in vec4 v_Color; // The interpolated vertex color
in vec2 v_TexCoord; // The interpolated block texture coordinates
in vec2 v_LightCoord;

in float v_MaterialMipBias;
in float v_MaterialAlphaCutoff;

in VEC3 inChunkPos;
in VEC4 inWorldPos;
in VEC4 inScreenPos;

uniform sampler2D u_BlockTex; // The block texture
uniform sampler2D u_LightTex; // The light map texture sampler

uniform vec4 u_FogColor; // The color of the shader fog
uniform vec2 u_EnvironmentFog; // The start and end position for environmental fog
uniform vec2 u_RenderFog; // The start and end position for border fog

out vec4 fragColor; // The output fragment for the color framebuffer

#import <minecraft:include/main.glsl>