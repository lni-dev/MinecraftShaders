#version 330
#extension GL_ARB_separate_shader_objects : require

// Enable Vanilla core shaders compatibility
#define ES_JAVA

/* ============================================= *|
     Defines that used to be in the .json-files
|* ============================================= */
#define CHUNK_SECTION_INSTEAD_OF_DYNAMIC_TRANSFORMS

/* ============================================= *|
                     Main Render
|* ============================================= */
#include <es_render_block.vsh.glsl>
