/*
 * Copyright 2022 LinusDev
 *
 * Contact: einsuperlinus@gmail.com
 */

#define SHADOW
#define SHADOW_WIDTH 0.87
#define SHADOW_COLOR_DAY vec3(0.5, 0.5, 0.65)
#define SHADOW_COLOR_NIGHT vec3(0.5, 0.5, 0.5)
#define SHADOW_COLOR_CAVE vec3(0.45, 0.45, 0.65)
#define SHADOW_FADE_IN
#define FADE_IN_SHADOW_WIDTH 0.025
#define SHADOW_BLOCK_SIDE

#define TONE_MAPPING

//A saturation of 1.0 has no impact
//A saturation of 0.0 is greyScale
//A saturation of 2.0 would double the saturation
//too high values may cause bugs
#define SATURATION 1.2
#define TORCH_LIGHT
#define TORCH_LIGHT_STRENGTH 15.0
#define TROCH_LIGHT_OFFSET -0.23
#define TORCH_LIGHT_OFFSET_CAVES -0.1
#define TORCH_COLOR_DAY vec3(0.15, 0.05, 0.01)
#define TORCH_COLOR_NIGHT vec3(0.664, 0.3, 0.1)
#define TORCH_COLOR_CAVE vec3(0.734, 0.235, 0.05)
#define TORCH_COLOR_NETHER vec3(0.434, 0.31, 0.17)
#define TORCH_COLOR_END vec3(0.32, 0.095, 0.2)
#define SUN_LIGHT
#define SUN_LIGHT_COLOR_DAY vec3(1.2, 1.3, 1.25)
#define SUN_LIGHT_COLOR_NIGHT vec3(0.7, 0.7, 0.9)

#define ESPE_FOG_AND_NO_FKING_MOJANG_FOG_BECAUSE_NOBODY_CARES
#define ESPE_FOG_COLOR_DAY vec3(0.1, 0.28, 0.59)
#define ESPE_FOG_COLOR_NIGHT vec3(0.01, 0.05, 0.1)
#define ESPE_FOG_COLOR_RAIN vec3(0.3, 0.35, 0.3)
#define ESPE_FOG_WIDTH 0.85
#define ESPE_FOG_WIDTH_RAIN 1.4

#define NIGHT_BRIGHTNESS_FACTOR 0.69

//will make the night appear colorless
//#define NIGHT_TONE_MAPPING


#define ESPE_FOG_UNDERWATER_WIDTH 1.7
#define RENDER_DISTANCE_UNDER_WATER 64.0
#define ESPE_FOG_UNDERWATER_COLOR vec3(0.1, 0.4, 0.6)

#define NETHER_FOG
#define ESPE_FOG_COLOR_NETHER vec3(0.42, 0.1, 0.0)
#define ESPE_FOG_WIDTH_NETHER 1.05
#define END_FOG
#define ESPE_FOG_WIDTH_END 1.07
#define ESPE_FOG_COLOR_END vec3(0.073, 0.015, 0.085)

#define CAMERA_OFFSET vec3(0.0, 0.0, 0.0)
//(vec3(0.17, 0.6 - 0.07*Y, 0.83 + 0.2*Y))
#define SKY_COLOR(Y) (mix(vec3(0.6, 0.75, 0.8), vec3(0.1, 0.4, 0.9), (Y+1.0)*.5))
#define SKY_COLOR_FACT(FOG) (pow(clamp(FOG+vec3(0.3), vec3(0.4), vec3(1.0)), vec3(2.)))
//#define MIX_SKY_AND_FOG

//CLOUD stuff
#define CLOUD
#define CLOUD_Z_MOVE_SCALE 0.1
#define CLOUD_X_MOVE_SCALE 0.1
#define CLOUD_RAIN_COLOR vec3(0.25, 0.3, 0.3)

#define CAVE_TONE_MAPPING
#define CAVE_TONE_MAPPING_COLOR_FACT vec3(0.35, 0.35, 1.75)
#define CAVE_MAX_DARKNESS 0.3
//#define MORE_REALISTIC_CAVE

#define VIGNETTE
#define VIGNETTE_COLOR_FACT_DAY vec4(0.56, 0.56, 0.56, 1.0)
#define VIGNETTE_COLOR_FACT_NIGHT vec4(0.46, 0.46, 0.46, 1.0)
#define VIGNETTE_COLOR_FACT_CAVE vec4(0.26, 0.26, 0.39, 1.0)

#define WATER_COLOR_IN_SHADOW_PER_CENT vec4(0.55, 0.55, 0.65, 0.75)
#define WATER_COLOR_IN_CAVES vec4(0.05, 0.07, 0.25, 0.75)
#define WATER_COLOR_AT_NIGHT_PER_CENT vec4(0.25, 0.25, 0.35, 0.65)
#define MIN_WATER_TRANSPARENCY 0.28

//#define REALISTIC_NETHER
#define REALISTIC_NETHER_TORCH_LIGHT_COLOR vec3(0.734, 0.235, 0.05)
