#version 150

// Enable Vanilla core shaders compatibility
#define ES_JAVA

/* ============================================= *\
     Defines that used to be in the .json-files
\* ============================================= */
#define CHUNK_SECTION_INSTEAD_OF_DYNAMIC_TRANSFORMS
#define ModelOffset ((ChunkPosition - CameraBlockPos) + CameraOffset)

#moj_import <es_render_block.vsh>
