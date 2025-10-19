/**
 * Copyright (c) 2022-2025 LinusDev
 * Author: Linusdev
 * Contact: linus@linusdev.de
 */

#ifndef SETTINGS_H
  #define SETTINGS_H

    // Define your custom settings in this file.
    // If you need help please visit my discord (https://discord.gg/shVe3cR)!
    // Remove the // to enable a change
    // - changes starting with "#define" change a value. The value is on the right and can be changed.
    // - changes starting with "#define DISABLE_" disable a feature.
    // Allowed changes are below:


/* Shadow */
//  #define DISABLE_SHADOW
//  #define SHADOW_WIDTH (14.67/16.)
//  #define DISABLE_SHADOW_FADE_IN
//  #define FADE_IN_SHADOW_WIDTH (.17/16.)
//  #define DISABLE_SHADOW_BLOCK_SIDE

/* Shadow colors */
//  #define SHADOW_COLOR_DAY VEC3(0.5, 0.5, 0.65)
//  #define SHADOW_COLOR_NIGHT VEC3(0.7, 0.7, 0.7)
//  #define SHADOW_COLOR_CAVE VEC3(0.25, 0.25, 0.47)


/*
 * Note that the Nether is always in shadow
 */
//  #define SHADOW_COLOR_NETHER VEC3(0.5, 0.5, 0.5)
/*
 * Note that the End is always in shadow
 */
//  #define SHADOW_COLOR_END VEC3(1.0, 1.0, 1.0)

/* Misc */
/*
 * A saturation of 1.0 has no impact.
 * A saturation of 0.0 is greyScale.
 * A saturation of 2.0 would double the saturation-
 */
//  #define SATURATION 1.2
//  #define DISABLE_TONE_MAPPING


/* Light and Light Color */
//  #define DISABLE_TORCH_LIGHT
//  #define TORCH_COLOR_DAY VEC3(0.7, 0.2, 0.04)
//  #define TORCH_COLOR_NIGHT VEC3(1.034, 0.37, 0.16)
//  #define TORCH_COLOR_CAVE VEC3(1.334, 0.135, 0.05)
//  #define TORCH_COLOR_NETHER VEC3(1.134, 0.31, 0.17)
//  #define TORCH_COLOR_END VEC3(0.52, 0.195, 0.39)


/* Ambient Light: Light which is always present everywhere */
//  #define DISABLE_AMBIENT_LIGHT
//  #define AMBIENT_LIGHT_DAY VEC3(1., 1., 1.)
//  #define AMBIENT_LIGHT_NIGHT VEC3(0.6, 0.6, 0.6)
//  #define AMBIENT_LIGHT_NETHER VEC3(1., 1., 1.)
//  #define AMBIENT_LIGHT_END VEC3(0.65, 0.85, 1.0)

/* Night grey scale: Makes the night grey scale */
//  #define DISABLE_NIGHT_GREY_SCALE
/* Lower values  will increase greyscale. Range: 0.0 to 1.0 */
//  #define NIGHT_GREY_SCALE_PERCENTAGE 0.62


/* Vignette: Makes the edge of the screen a bit darker*/
//  #define DISABLE_VIGNETTE
//  #define VIGNETTE_COLOR_DAY VEC3(0.56, 0.56, 0.56)
//  #define VIGNETTE_COLOR_NIGHT VEC3(0.46, 0.46, 0.46)
//  #define VIGNETTE_COLOR_CAVE VEC3(0.26, 0.26, 0.39)
//  #define VIGNETTE_COLOR_NETHER VEC3(0.26, 0.26, 0.39)
//  #define VIGNETTE_COLOR_END VEC3(0.56, 0.56, 0.56)



/* Fog */

/* Disable Fog completely */
//  #define DISABLE_ES_ENABLE_FOG

/* Disable the Mixing of the fog with the background color. This will create an odd sharp cut off*/
//  #define DISABLE_MIX_ES_FOG_AND_MC_FOG

/* Overworld fog related values. */

/* The smallest distance where fog can start */
//  #define ES_FOG_MIN_DISTANCE 0.0
/* Where the fog will end */
//  #define ES_FOG_END 1.05
/* Where the fog will start by default */
//  #define ES_FOG_START 0.5
/* When to start mixing with the background color */
//  #define ES_FOG_START_MIX_WITH_MOJANG_FOG 0.90

/* Fog color for day and night */
//  #define ES_FOG_COLOR_DAY(MC_FOG_COLOR, CURR_RENDER_COLOR) VEC3(0.3, 0.38, 0.69)
//  #define ES_FOG_COLOR_NIGHT(MC_FOG_COLOR, CURR_RENDER_COLOR) VEC3(0.01, 0.02, 0.07)

/* Cave fog related values. */
//  #define ES_CAVE_FOG_END ES_FOG_END
//  #define ES_CAVE_FOG_START ES_FOG_START
//  #define ES_CAVE_FOG_START_MIX_WITH_MOJANG_FOG ES_FOG_START_MIX_WITH_MOJANG_FOG
//  #define ES_CAVE_FOG_COLOR(MC_FOG_COLOR, CURR_RENDER_COLOR) VEC3(0.01, 0.05, 0.1)

/* Nether fog related values. */
//  #define DISABLE_ES_NETHER_ENABLE_FOG
//  #define ES_NETHER_FOG_END 1.6
//  #define ES_NETHER_FOG_START 0.3
//  #define ES_NETHER_FOG_START_MIX_WITH_MOJANG_FOG 1.2
//  #define ES_NETHER_FOG_COLOR(MC_FOG_COLOR, CURR_RENDER_COLOR) (VEC3(1.2, 0.6, 0.6) * MC_FOG_COLOR)

/* End fog related values. */
//  #define DISABLE_ES_END_ENABLE_FOG
//  #define ES_END_FOG_END ES_FOG_END
//  #define ES_END_FOG_START 0.1
//  #define ES_END_FOG_START_MIX_WITH_MOJANG_FOG ES_FOG_START_MIX_WITH_MOJANG_FOG
//  #define ES_END_FOG_COLOR(MC_FOG_COLOR, CURR_RENDER_COLOR) VEC3(0.05, 0.02, 0.1)


#endif