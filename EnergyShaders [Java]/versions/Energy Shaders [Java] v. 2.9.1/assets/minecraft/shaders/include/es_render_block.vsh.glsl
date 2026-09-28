// es_render_block.vsh

layout(location = 0) in vec3 Position;
layout(location = 1) in vec4 Color;
layout(location = 2) in vec2 UV0;
layout(location = 3) in ivec2 UV2;
#ifdef MULTIDRAW_TERRAIN
    layout(location = 4) in ivec3 ChunkPosition;
    layout(location = 5) in float ChunkVisibility;
#endif

#include <minecraft:fog.glsl>
#include <minecraft:globals.glsl>
#ifdef CHUNK_SECTION_INSTEAD_OF_DYNAMIC_TRANSFORMS
    #include <minecraft:terrainglobals.glsl>
    #ifndef MULTIDRAW_TERRAIN
        #include <minecraft:chunksection.glsl>
    #endif
    #define ModelOffset ((ChunkPosition - CameraBlockPos) + CameraOffset)
#else
    #include <minecraft:dynamictransforms.glsl>
#endif
#include <minecraft:projection.glsl>

layout(location = 0) out vec4 vertexColor;
layout(location = 1) out vec4 overlayColor;
layout(location = 2) out vec2 texCoord0;
layout(location = 3) out vec2 texCoord2;
layout(location = 4) out vec3 inChunkPos;
layout(location = 5) out vec4 inWorldPos;
layout(location = 6) out vec4 inScreenPos;
layout(location = 7) out float projMat3x;
layout(location = 8) out vec4 normal;
layout(location = 9) out vec2 texCoordGlint;

void main() {
    inChunkPos = Position;
    inWorldPos = vec4(Position + ModelOffset, 1.0);
    inScreenPos = ProjMat * ModelViewMat * inWorldPos;
    gl_Position = inScreenPos;

    vertexColor = Color;
    overlayColor = vec4(0.0, 0.0, 0.0, 1.0);
    texCoord0 = UV0;
    texCoord2 = UV2;
    projMat3x = ProjMat[3].x;
    normal = vec4(0.0, -1.0, 0.0, 0.0);
}
