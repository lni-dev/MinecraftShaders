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
//too hight values may cause bugs
#define SATURATION 1.2
#define TORCH_LIGHT
#define TORCH_LIGHT_STRENGTH 15.0
#define TROCH_LIGHT_OFFSET -0.23
#define TORCH_LIGHT_OFFSET_CAVES -0.1
#define TORCH_COLOR_DAY vec3(0.15, 0.05, 0.01)
#define TORCH_COLOR_NIGHT vec3(0.664, 0.3, 0.1)
#define TORCH_COLOR_CAVE vec3(0.734, 0.235, 0.05)
#define SUN_LIGHT
#define SUN_LIGHT_COLOR_DAY vec3(1.2, 1.3, 1.25)
#define SUN_LIGHT_COLOR_NIGHT vec3(0.7, 0.7, 0.9)

#define ESPE_FOG_AND_NO_FKING_MOJANG_FOG_BECAUSE_NOBODY_CARES
#define ESPE_FOG_COLOR_DAY vec3(0.2, 0.45, 0.63)
#define ESPE_FOG_COLOR_NIGHT vec3(0.01, 0.05, 0.1)
#define ESPE_FOG_COLOR_RAIN vec3(0.4, 0.45, 0.5)
#define ESPE_FOG_WIDTH 0.8
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

#define CAMERA_OFFSET vec3(0.0, 0.0, 0.0)
#define SKY_COLOR vec4(0.1, 0.35, 0.7, 1.0)
#define MIX_SKY_AND_FOG

//CLOUD stuff
#define SKY_HEIGHT 270.0
#define CLOUD_OCTAVES 50.0
#define CLOUD_ADDITION 0.15
#define CLOUD_LACUNARITY 1.6
#define CLOUD_FREQUENCY 1.0

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
