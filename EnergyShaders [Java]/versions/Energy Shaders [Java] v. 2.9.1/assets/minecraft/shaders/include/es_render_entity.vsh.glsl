#include <minecraft:fog.glsl>
#include <minecraft:dynamictransforms.glsl>
#include <minecraft:projection.glsl>


layout(location = 0) in vec3 Position;
layout(location = 1) in vec4 Color;
layout(location = 2) in vec2 UV0;

#ifdef ES_MIX_OVERLAY_COLOR
    layout(location = 3) in ivec2 UV1; // not available in particle.vsh
#endif

layout(location = 4) in ivec2 UV2;
#ifdef ES_HAS_NORMAL
    layout(location = 5) in vec3 Normal;
#endif
#ifdef GLINT_SPECIAL
    layout(location = 6) in vec2 UV3;
#endif

#if !defined(NO_OVERLAY) && !defined(OIT_ALPHA_ONLY) && defined(ES_MIX_OVERLAY_COLOR)
    uniform sampler2D Sampler1; // not available in particle.vsh
#endif

#if !defined(EMISSIVE) && !defined(OIT_ALPHA_ONLY)
    uniform sampler2D Sampler2;
#endif

layout(location = 0) out vec4 vertexColor;
layout(location = 1) out vec4 overlayColor;


layout(location = 2) out vec2 texCoord0;
layout(location = 3) out vec2 texCoord2;
layout(location = 9) out vec2 texCoordGlint;

layout(location = 4) out vec3 inChunkPos;
layout(location = 5) out vec4 inWorldPos;
layout(location = 6) out vec4 inScreenPos;
layout(location = 7) out float projMat3x;

layout(location = 8) out vec4 normal;

void main() {
    inChunkPos = Position;
    inWorldPos = vec4(Position, 1.0);
    inScreenPos = ProjMat * ModelViewMat * vec4(Position, 1.0);

    gl_Position = inScreenPos;

    vertexColor = Color;
    texCoord0 = UV0;
    texCoord2 = UV2;
    projMat3x = ProjMat[3].x;

    #ifdef ES_HAS_NORMAL
        normal = vec4(Normal, 0.0);
    #else
        normal = vec4(0.0, -1.0, 0.0, 0.0);
    #endif

    #if !defined(NO_OVERLAY) && !defined(OIT_ALPHA_ONLY) && defined(ES_MIX_OVERLAY_COLOR)
        overlayColor = texelFetch(Sampler1, UV1, 0);
    #else
        overlayColor = vec4(0. ,0. ,0. , 1.);
    #endif

    #ifdef APPLY_TEXTURE_MATRIX
        texCoord0 = (TextureMat * vec4(UV0, 0.0, 1.0)).xy;
    #endif

    #ifdef GLINT
        #ifdef GLINT_SPECIAL
            texCoordGlint = (TextureMat * vec4(UV3, 0.0, 1.0)).xy;
        #else
            texCoordGlint = (TextureMat * vec4(UV0, 0.0, 1.0)).xy;
        #endif
    #else
        texCoordGlint = vec2(0.0);
    #endif
}
