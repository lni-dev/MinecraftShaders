#version 330
#extension GL_ARB_separate_shader_objects : require

/* ============================================= *|
     Defines that used to be in the .json-files
|* ============================================= */
#undef ES_HAS_NORMAL
#undef ES_MIX_OVERLAY_COLOR

/* ============================================= *|
                     Main Render
|* ============================================= */
#include <es_render_entity.vsh.glsl>