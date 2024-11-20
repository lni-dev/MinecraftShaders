/**
 * Copyright (c) 2022-2023 LinusDev
 * Author: Linusdev
 * Contact: linus@linusdev.de
 */

#ifndef SETTINGS_H
  #define SETTINGS_H

  //# Debug
  #undef DEBUG_SHOW_ES_LIGHT_TEXTURE
  #undef DEBUG_SHOW_TIME
  #undef DEBUG_LIGHT
  #undef DEBUG_SHOW_NORMAL
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

  //# Shadow

  #define SHADOW
  #define SHADOW_WIDTH (14.67/16.)

  #define SHADOW_FADE_IN
  #define FADE_IN_SHADOW_WIDTH (.17/16.)

  #define SHADOW_BLOCK_SIDE

  #define SHADOW_COLOR_DAY VEC3(0.5, 0.5, 0.65)
  #define SHADOW_COLOR_NIGHT VEC3(0.7)
  #define SHADOW_COLOR_CAVE VEC3(0.25, 0.25, 0.47)
  /**
   * Note that the Nether is always in shadow
   */
  #define SHADOW_COLOR_NETHER VEC3(0.5)
   /**
    * Note that the End is always in shadow
    */
  #define SHADOW_COLOR_END VEC3(1.0)

  //# Tone Mapping

  #define TONE_MAPPING

  //# Staturation

  /**
   * A saturation of 1.0 has no impact.
   * A saturation of 0.0 is greyScale.
   * A saturation of 2.0 would double the saturation-
   */
  #define SATURATION 1.2


  //# Light
  #define TORCH_LIGHT

  #define TORCH_COLOR_DAY VEC3(0.6, 0.2, 0.04)
  #define TORCH_COLOR_NIGHT VEC3(0.964, 0.37, 0.16)
  #define TORCH_COLOR_CAVE VEC3(0.934, 0.235, 0.05)

  #define TORCH_COLOR_NETHER VEC3(1.134, 0.31, 0.17)
  #define TORCH_COLOR_END VEC3(0.52, 0.195, 0.39)

  //# Ambient Light
  #define AMBIENT_LIGHT
  #define AMBIENT_LIGHT_DAY VEC3(1., 1., 1.)
  #define AMBIENT_LIGHT_NIGHT VEC3(0.6)

  #define AMBIENT_LIGHT_NETHER VEC3(1.)
  #define AMBIENT_LIGHT_END VEC3(0.65, 0.85, 1.0)

  #define NIGHT_GREY_SCALE
  #define NIGHT_GREY_SCALE_PERCENTAGE 0.62

  //# Vignette
  #define VIGNETTE

  #define VIGNETTE_COLOR_DAY VEC3(0.56, 0.56, 0.56)
  #define VIGNETTE_COLOR_NIGHT VEC3(0.46, 0.46, 0.46)
  #define VIGNETTE_COLOR_CAVE VEC3(0.26, 0.26, 0.39)

  #define VIGNETTE_COLOR_NETHER VEC3(0.26, 0.26, 0.39)
  #define VIGNETTE_COLOR_END VEC3(0.56, 0.56, 0.56)


  //# Fog
  #define ES_ENABLE_FOG
  #define MIX_ES_FOG_AND_MC_FOG

  #define ES_FOG_MIN_DISTANCE 0.0

  #define ES_FOG_END 1.05
  #define ES_FOG_START 0.5
  #define ES_FOG_START_MIX_WITH_MOJANG_FOG 0.90
  #define ES_FOG_COLOR_DAY(MC_FOG_COLOR, CURR_RENDER_COLOR) VEC3(0.3, 0.38, 0.69)
  #define ES_FOG_COLOR_NIGHT(MC_FOG_COLOR, CURR_RENDER_COLOR) VEC3(0.01, 0.02, 0.07)

  #define ES_CAVE_FOG_END ES_FOG_END
  #define ES_CAVE_FOG_START ES_FOG_START
  #define ES_CAVE_FOG_START_MIX_WITH_MOJANG_FOG ES_FOG_START_MIX_WITH_MOJANG_FOG
  #define ES_CAVE_FOG_COLOR(MC_FOG_COLOR, CURR_RENDER_COLOR) VEC3(0.01, 0.05, 0.1)

  #define ES_NETHER_ENABLE_FOG
  #define ES_NETHER_FOG_END 1.6
  #define ES_NETHER_FOG_START 0.3
  #define ES_NETHER_FOG_START_MIX_WITH_MOJANG_FOG 1.2
  #define ES_NETHER_FOG_COLOR(MC_FOG_COLOR, CURR_RENDER_COLOR) (VEC3(1.2, 0.6, 0.6) * MC_FOG_COLOR)

  #define ES_END_ENABLE_FOG
  #define ES_END_FOG_END ES_FOG_END
  #define ES_END_FOG_START 0.1
  #define ES_END_FOG_START_MIX_WITH_MOJANG_FOG ES_FOG_START_MIX_WITH_MOJANG_FOG
  #define ES_END_FOG_COLOR(MC_FOG_COLOR, CURR_RENDER_COLOR) VEC3(0.05, 0.02, 0.1)

#endif