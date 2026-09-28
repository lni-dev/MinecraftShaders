#version 330
#extension GL_ARB_separate_shader_objects : require

// Enable Vanilla core shaders compatibility
#define ES_JAVA
#include <compatibility.glsl>

/* ============================================= *|
     Defines that used to be in the .json-files
|* ============================================= */
#define ES_DO_ALPHA_CUTOFF
#define ES_ALPHA_CUTOFF_VALUE 0.1
#undef ES_HAS_NORMAL
#undef ES_MIX_OVERLAY_COLOR

// TEST_AFFECTED can be used to test which vertices are affected by this shader.
// If enabled all blocks affected by this shader will appear red.
#undef TEST_AFFECTED

/* ============================================= *|
                     Main Render
|* ============================================= */
#include <es_frag_vanilla.fsh.glsl>
