#version 330
#extension GL_ARB_separate_shader_objects : require

// Enable Vanilla core shaders compatibility
#define ES_JAVA

/* ============================================= *|
     Defines that used to be in the .json-files
|* ============================================= */
#define SPECIAL_TEXTURE_SAMPLING
#define CHUNK_SECTION_INSTEAD_OF_DYNAMIC_TRANSFORMS
#define ColorModulator vec4(1.0)

#ifdef ALPHA_CUTOUT
    #define ES_DO_ALPHA_CUTOFF
#endif

#define ES_ALPHA_CUTOFF_VALUE ALPHA_CUTOUT

// TEST_AFFECTED can be used to test which vertices are affected by this shader.
// If enabled all blocks affected by this shader will appear red.
#undef TEST_AFFECTED

#include <compatibility.glsl>

/* ============================================= *|
                     Main Render
|* ============================================= */
#include <es_frag_vanilla.fsh.glsl>


