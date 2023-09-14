#ifndef _UNIFORM_RENDER_CHUNK_CONSTANTS_H
#define _UNIFORM_RENDER_CHUNK_CONSTANTS_H

#include "shaders/uniformMacro.h"

#ifdef MCPE_PLATFORM_NX
uniform RenderChunkConstants {
#endif
// BEGIN_UNIFORM_BLOCK(RenderChunkConstants) - unfortunately this macro does not work on old Amazon platforms so using above 3 lines instead
UNIFORM POS4 CHUNK_ORIGIN_AND_SCALE;
END_UNIFORM_BLOCK

#endif
