/**
* Copyright (c) 2022-2025 LinusDev
* Author: Linusdev
* Contact: linus@linusdev.de
*/

//# Debug
#undef DEBUG_SHOW_ES_LIGHT_TEXTURE
#undef DEBUG_SHOW_TIME
#undef DEBUG_LIGHT
#undef DEBUG_SHOW_NORMAL

/**
 * No Cave: Black
 * Cave: White
 */
#undef DEBUG_CAVE
/**
 * Night: White
 * Day: Black
 */
#undef DEBUG_TIME
/**
 * GUI: purple
 * Overworld: green
 * Nether: red
 * End: blue
 */
#undef DEBUG_DIMENSION

/**
 * Shadow: White
 * No Shadow: Black
 */
#undef DEBUG_SHADOW

//# Math
#define PI 3.14159265359
#define E 2.71828

//# Shadow

#ifndef DISABLE_SHADOW
    #define SHADOW
#endif
                                                                                                                            #ifndef SHADOW_WIDTH
#define SHADOW_WIDTH (14.67/16.)
                                                                                                                            #endif

#ifndef DISABLE_SHADOW_FADE_IN
    #define SHADOW_FADE_IN
#endif
                                                                                                                            #ifndef FADE_IN_SHADOW_WIDTH
#define FADE_IN_SHADOW_WIDTH (.17/16.)
                                                                                                                            #endif

#define SHADOW_BLOCK_SIDE

                                                                                                                            #ifndef SHADOW_COLOR_DAY
#define SHADOW_COLOR_DAY VEC3(0.5, 0.5, 0.65)
                                                                                                                            #endif

                                                                                                                            #ifndef SHADOW_COLOR_NIGHT
#define SHADOW_COLOR_NIGHT VEC3(0.7)
                                                                                                                            #endif

                                                                                                                            #ifndef SHADOW_COLOR_CAVE
#define SHADOW_COLOR_CAVE VEC3(0.25, 0.25, 0.47)
                                                                                                                            #endif

/**
 * Note that the Nether is always in shadow
 */
                                                                                                                            #ifndef SHADOW_COLOR_NETHER
#define SHADOW_COLOR_NETHER VEC3(0.5)
                                                                                                                            #endif
 /**
  * Note that the End is always in shadow
  */
                                                                                                                            #ifndef SHADOW_COLOR_END
#define SHADOW_COLOR_END VEC3(1.0)
                                                                                                                            #endif

//# Tone Mapping
#ifndef DISABLE_TONE_MAPPING
    #define TONE_MAPPING
#endif

//# Staturation

/**
 * A saturation of 1.0 has no impact.
 * A saturation of 0.0 is greyScale.
 * A saturation of 2.0 would double the saturation-
 */
                                                                                                                            #ifndef SATURATION
#define SATURATION 1.2
                                                                                                                            #endif


//# Light
#ifndef DISABLE_TORCH_LIGHT
    #define TORCH_LIGHT
#endif
                                                                                                                            #ifndef TORCH_COLOR_DAY
#define TORCH_COLOR_DAY VEC3(0.7, 0.2, 0.04)
                                                                                                                            #endif
                                                                                                                            #ifndef TORCH_COLOR_NIGHT
#define TORCH_COLOR_NIGHT VEC3(1.034, 0.37, 0.16)
                                                                                                                            #endif
                                                                                                                            #ifndef TORCH_COLOR_CAVE
#define TORCH_COLOR_CAVE VEC3(1.334, 0.135, 0.05)
                                                                                                                            #endif

                                                                                                                            #ifndef TORCH_COLOR_NETHER
#define TORCH_COLOR_NETHER VEC3(1.134, 0.31, 0.17)
                                                                                                                            #endif
                                                                                                                            #ifndef TORCH_COLOR_END
#define TORCH_COLOR_END VEC3(0.52, 0.195, 0.39)
                                                                                                                            #endif

//# Ambient Light
#ifndef DISABLE_AMBIENT_LIGHT
    #define AMBIENT_LIGHT
#endif
                                                                                                                            #ifndef AMBIENT_LIGHT_DAY
#define AMBIENT_LIGHT_DAY VEC3(1., 1., 1.)
                                                                                                                            #endif
                                                                                                                            #ifndef AMBIENT_LIGHT_NIGHT
#define AMBIENT_LIGHT_NIGHT VEC3(0.6)
                                                                                                                            #endif

                                                                                                                            #ifndef AMBIENT_LIGHT_NETHER
#define AMBIENT_LIGHT_NETHER VEC3(1.)
                                                                                                                            #endif
                                                                                                                            #ifndef AMBIENT_LIGHT_END
#define AMBIENT_LIGHT_END VEC3(0.65, 0.85, 1.0)
                                                                                                                            #endif
#ifndef DISABLE_NIGHT_GREY_SCALE
    #define NIGHT_GREY_SCALE
#endif
                                                                                                                            #ifndef NIGHT_GREY_SCALE_PERCENTAGE
#define NIGHT_GREY_SCALE_PERCENTAGE 0.62
                                                                                                                            #endif

//# Vignette
#ifndef DISABLE_VIGNETTE
    #define VIGNETTE
#endif
                                                                                                                            #ifndef VIGNETTE_COLOR_DAY
#define VIGNETTE_COLOR_DAY VEC3(0.56, 0.56, 0.56)
                                                                                                                            #endif
                                                                                                                            #ifndef VIGNETTE_COLOR_NIGHT
#define VIGNETTE_COLOR_NIGHT VEC3(0.46, 0.46, 0.46)
                                                                                                                            #endif
                                                                                                                            #ifndef VIGNETTE_COLOR_CAVE
#define VIGNETTE_COLOR_CAVE VEC3(0.26, 0.26, 0.39)
                                                                                                                            #endif

                                                                                                                            #ifndef VIGNETTE_COLOR_NETHER
#define VIGNETTE_COLOR_NETHER VEC3(0.26, 0.26, 0.39)
                                                                                                                            #endif
                                                                                                                            #ifndef VIGNETTE_COLOR_END
#define VIGNETTE_COLOR_END VEC3(0.56, 0.56, 0.56)
                                                                                                                            #endif


//# Fog
#ifndef DISABLE_ES_ENABLE_FOG
    #define ES_ENABLE_FOG
#endif
#ifndef DISABLE_MIX_ES_FOG_AND_MC_FOG
    #define MIX_ES_FOG_AND_MC_FOG
#endif

                                                                                                                            #ifndef ES_FOG_MIN_DISTANCE
#define ES_FOG_MIN_DISTANCE 0.0
                                                                                                                            #endif

                                                                                                                            #ifndef ES_FOG_END
#define ES_FOG_END 1.05
                                                                                                                            #endif
                                                                                                                            #ifndef ES_FOG_START
#define ES_FOG_START 0.5
                                                                                                                            #endif
                                                                                                                            #ifndef ES_FOG_START_MIX_WITH_MOJANG_FOG
#define ES_FOG_START_MIX_WITH_MOJANG_FOG 0.90
                                                                                                                            #endif
                                                                                                                            #ifndef ES_FOG_COLOR_DAY
#define ES_FOG_COLOR_DAY(MC_FOG_COLOR, CURR_RENDER_COLOR) VEC3(0.3, 0.38, 0.69)
                                                                                                                            #endif
                                                                                                                            #ifndef ES_FOG_COLOR_NIGHT
#define ES_FOG_COLOR_NIGHT(MC_FOG_COLOR, CURR_RENDER_COLOR) VEC3(0.01, 0.02, 0.07)
                                                                                                                            #endif

                                                                                                                            #ifndef ES_CAVE_FOG_END
#define ES_CAVE_FOG_END ES_FOG_END
                                                                                                                            #endif
                                                                                                                            #ifndef ES_CAVE_FOG_START
#define ES_CAVE_FOG_START ES_FOG_START
                                                                                                                            #endif
                                                                                                                            #ifndef ES_CAVE_FOG_START_MIX_WITH_MOJANG_FOG
#define ES_CAVE_FOG_START_MIX_WITH_MOJANG_FOG ES_FOG_START_MIX_WITH_MOJANG_FOG
                                                                                                                            #endif
                                                                                                                            #ifndef ES_CAVE_FOG_COLOR
#define ES_CAVE_FOG_COLOR(MC_FOG_COLOR, CURR_RENDER_COLOR) VEC3(0.01, 0.05, 0.1)
                                                                                                                            #endif

#ifndef DISABLE_ES_NETHER_ENABLE_FOG
    #define ES_NETHER_ENABLE_FOG
#endif
                                                                                                                            #ifndef ES_NETHER_FOG_END
#define ES_NETHER_FOG_END 1.6
                                                                                                                            #endif
                                                                                                                            #ifndef ES_NETHER_FOG_START
#define ES_NETHER_FOG_START 0.3
                                                                                                                            #endif
                                                                                                                            #ifndef ES_NETHER_FOG_START_MIX_WITH_MOJANG_FOG
#define ES_NETHER_FOG_START_MIX_WITH_MOJANG_FOG 1.2
                                                                                                                            #endif
                                                                                                                            #ifndef ES_NETHER_FOG_COLOR
#define ES_NETHER_FOG_COLOR(MC_FOG_COLOR, CURR_RENDER_COLOR) (VEC3(1.2, 0.6, 0.6) * MC_FOG_COLOR)
                                                                                                                            #endif

#ifndef DISABLE_ES_END_ENABLE_FOG
    #define ES_END_ENABLE_FOG
#endif
                                                                                                                            #ifndef ES_END_FOG_END
#define ES_END_FOG_END ES_FOG_END
                                                                                                                            #endif
                                                                                                                            #ifndef ES_END_FOG_START
#define ES_END_FOG_START 0.1
                                                                                                                            #endif
                                                                                                                            #ifndef ES_END_FOG_START_MIX_WITH_MOJANG_FOG
#define ES_END_FOG_START_MIX_WITH_MOJANG_FOG ES_FOG_START_MIX_WITH_MOJANG_FOG
                                                                                                                            #endif
                                                                                                                            #ifndef ES_END_FOG_COLOR
#define ES_END_FOG_COLOR(MC_FOG_COLOR, CURR_RENDER_COLOR) VEC3(0.05, 0.02, 0.1)
                                                                                                                            #endif

