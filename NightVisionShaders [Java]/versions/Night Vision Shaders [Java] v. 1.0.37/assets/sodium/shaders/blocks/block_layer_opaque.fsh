#version 460 core

#define ES_SODIUM

#include <sodium:globals.glsl>
#include <sodium:chunk_material.glsl>
#include <minecraft:oit.glsl>
#include <minecraft:texture_sampling.glsl>

#include <minecraft:compatibility.glsl>
#include <minecraft:es-settings.glsl>
#include <minecraft:.es-settings.default.glsl>
#include <minecraft:struct-defs.glsl>
#include <minecraft:checks.glsl>
#include <minecraft:tonemaps.glsl>
#include <minecraft:render.glsl>

layout(location = 0) in vec4 v_Color; // The interpolated vertex color
layout(location = 1) in vec2 v_TexCoord; // The interpolated block texture coordinates
layout(location = 2) in vec2 v_LightCoord;
layout(location = 6) in float fadeFactor;

layout(location = 3) in VEC3 inChunkPos;
layout(location = 4) in VEC4 inWorldPos;
layout(location = 5) in VEC4 inScreenPos;

uniform sampler2D u_BlockTex;

#ifndef OIT_ALPHA_ONLY
    uniform sampler2D u_LightTex;
    layout(location = 0) out vec4 fragColor; // The output fragment for the color framebuffer
    #include <minecraft:main.glsl>
#else
    void main() {
        vec4 color = u_UseRGSS ? sampleRGSS(u_BlockTex, v_TexCoord, u_TexelSize) : sampleNearest(u_BlockTex, v_TexCoord, u_TexelSize);
        color *= v_Color;
        #ifdef ALPHA_CUTOUT
            if (color.a < ALPHA_CUTOUT) {
                discard;
            }
        #endif
        executeAlphaOnlyPhase(gl_FragCoord.z, color.a);
    }
#endif

// Another line so the #line directive added by Sodium does not fuck us through all holes.