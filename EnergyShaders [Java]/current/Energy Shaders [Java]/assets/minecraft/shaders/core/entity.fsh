#version 330
#extension GL_ARB_separate_shader_objects : require

// Enable Vanilla core shaders compatibility
#define ES_JAVA
#include <compatibility.glsl>

/* ============================================= *|
     Defines that used to be in the .json-files
|* ============================================= */
#if !defined(NO_OVERLAY) && !defined(OIT_ALPHA_ONLY)
    #define ES_MIX_OVERLAY_COLOR
#endif

#define ES_HAS_NORMAL

#ifdef ALPHA_CUTOUT
    #define ES_DO_ALPHA_CUTOFF
    #define ES_ALPHA_CUTOFF_VALUE ALPHA_CUTOUT
#endif

// TEST_AFFECTED can be used to test which vertices are affected by this shader.
// If enabled all blocks affected by this shader will appear red.
#undef TEST_AFFECTED

/* ============================================= *|
                     Main Render
|* ============================================= */
#include <es_frag_vanilla.fsh.glsl>
