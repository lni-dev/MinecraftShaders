// uniforms, varings etc
uniform sampler2D Sampler0;

#include <minecraft:fog.glsl>
#include <minecraft:globals.glsl>
#include <minecraft:texture_sampling.glsl>
#include <minecraft:oit.glsl>
#ifdef CHUNK_SECTION_INSTEAD_OF_DYNAMIC_TRANSFORMS
    #include <minecraft:terrainglobals.glsl>
    #ifndef MULTIDRAW_TERRAIN
        #include <minecraft:chunksection.glsl>
    #endif
#else
    #include <minecraft:dynamictransforms.glsl>
#endif

layout(location = 0) in vec4 vertexColor;
layout(location = 1) in vec4 overlayColor;
layout(location = 2) in vec2 texCoord0;
layout(location = 3) in vec2 texCoord2;
layout(location = 4) in VEC3 inChunkPos;
layout(location = 5) in VEC4 inWorldPos;
layout(location = 6) in VEC4 inScreenPos;
layout(location = 7) in float projMat3x;
layout(location = 8) in vec4 normal;
layout(location = 9) in vec2 texCoordGlint;

#ifdef OIT_ALPHA_ONLY
    void main() {
        vec4 color = ES_COLOR_RAW;

        #ifdef OIT_ADDITIVE
            color.a = min(0.99, color.a);
        #endif
        #ifdef ALPHA_CUTOUT
            if (color.a < ALPHA_CUTOUT) {
                discard;
            }
        #endif
        executeAlphaOnlyPhase(gl_FragCoord.z, color.a);
    }
#else
    #ifndef ES_NO_LIGHT_TEXTURE
        uniform sampler2D Sampler2;
    #endif
    #ifdef DISSOLVE
        uniform sampler2D DissolveMaskSampler;
    #endif
    #ifdef GLINT
        uniform sampler2D GlintSampler;
    #endif
    layout(location = 0) out VEC4 fragColor;
    #include <main.glsl>
#endif



