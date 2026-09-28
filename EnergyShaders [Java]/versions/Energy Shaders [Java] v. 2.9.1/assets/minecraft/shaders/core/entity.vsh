#version 330
#extension GL_ARB_separate_shader_objects : require

/* ============================================= *|
     Defines that used to be in the .json-files
|* ============================================= */
#define ES_HAS_NORMAL
#if !defined(NO_OVERLAY) && !defined(OIT_ALPHA_ONLY)
    #define ES_MIX_OVERLAY_COLOR
#endif

/* ============================================= *|
                     Main Render
|* ============================================= */
#include <es_render_entity.vsh.glsl>
