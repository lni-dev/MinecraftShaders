
// uniforms, varings etc
uniform sampler2D Sampler0;
uniform sampler2D Sampler1;
uniform sampler2D Sampler2;

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:globals.glsl>
#ifdef CHUNK_SECTION_INSTEAD_OF_DYNAMIC_TRANSFORMS
    #moj_import <minecraft:chunksection.glsl>
#else
    #moj_import <minecraft:dynamictransforms.glsl>
#endif

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


