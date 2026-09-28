#version 330
#extension GL_ARB_separate_shader_objects : require

/* ============================================= *|
     Defines that used to be in the .json-files
|* ============================================= */
#undef ES_HAS_NORMAL
#undef CHUNK_SECTION_INSTEAD_OF_DYNAMIC_TRANSFORMS
#undef SPECIAL_TEXTURE_SAMPLING

/* ============================================= *|
                     Main Render
|* ============================================= */
#include <es_render_block.vsh.glsl>
