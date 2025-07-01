#version 150

// Enable Vanilla core shaders compatibility
#define ES_JAVA
#moj_import <compatibility.glsl>

/* ============================================= *\
     Defines that used to be in the .json-files
\* ============================================= */
#define ES_HAS_NORMAL true

#ifdef ALPHA_CUTOUT
    #define ES_DO_ALPHA_CUTOFF
#endif

#define ES_ALPHA_CUTOFF_VALUE ALPHA_CUTOUT

// TEST_AFFECTED can be used to test which vertices are affected by this shader.
// If enabled all blocks affected by this shader will appear red.
#undef TEST_AFFECTED

/* ============================================= *\
                     Main Render
\* ============================================= */
#moj_import <es_frag_vanilla.fsh>


