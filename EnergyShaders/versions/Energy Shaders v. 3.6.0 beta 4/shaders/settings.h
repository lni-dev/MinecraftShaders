
//[--]

#define SHADOW

//this defines the width of the shadows
//if you would set it to 1.0, everywhere would be shadow
#define SHADOW_WIDTH 0.87

//[--]

//Shadow Color factors for day, night and in caves
//[-]
#define SHADOW_COLOR_DAY vec3(0.5, 0.5, 0.65)
//[-]
#define SHADOW_COLOR_NIGHT vec3(0.5, 0.5, 0.5)
//[-]
#define SHADOW_COLOR_CAVE vec3(0.45, 0.45, 0.65)
//[-]

//[--]

//this defines if the shadow should be smooth
#define SHADOW_FADE_IN

//the width of it
#define FADE_IN_SHADOW_WIDTH 0.025

//[--]

//TODO: not implemented yet
#define SHADOW_BACKFACE
#define SHADOW_BACKFACE_COLOR vec3(0.5, 0.5, 0.5)

//[--]
//[--]
//[--]

//if tone mapping should be used
#define TONE_MAPPING

//[--]
//[--]
//[--]

//if light sources (like torches, glowstone or lave) should emit light
#define TORCH_LIGHT

//strength of the light
#define TORCH_LIGHT_STRENGTH 15.0

//change how far light is emited, the number should always be under zero
#define TROCH_LIGHT_OFFSET -0.23
#define TORCH_LIGHT_OFFSET_CAVES -0.1

//[--]

//the color factors for the light
//[-]
#define TORCH_COLOR_DAY vec3(0.15, 0.05, 0.01)
//[-]
#define TORCH_COLOR_NIGHT vec3(0.65, 0.3, 0.1)
//[-]
#define TORCH_COLOR_CAVE vec3(0.5, 0.25, 0.05)
//[-]
#define TORCH_COLOR_SHADOW vec3(0.4, 0.35, 0.05)


//[--]

//Sun (and moon) light
#define SUN_LIGHT

//[-]
#define SUN_LIGHT_COLOR_DAY vec3(1.2, 1.2, 1.2)
//[-]
#define SUN_LIGHT_COLOR_NIGHT vec3(0.7, 0.7, 0.9)
//[-]


//[--]

#define ESPE_FOG_AND_NO_FKING_MOJANG_FOG_BECAUSE_NOBODY_CARES
#define ESPE_FOG_COLOR_DAY vec3(0.2, 0.45, 0.6)
#define ESPE_FOG_COLOR_NIGHT vec3(0.01, 0.05, 0.1)
#define ESPE_FOG_COLOR_RAIN vec3(0.4, 0.45, 0.5)
#define ESPE_FOG_WIDTH 0.75
#define ESPE_FOG_WIDTH_RAIN 1.4
#define NIGHT_TONE_MAPPING

#define ESPE_FOG_UNDERWATER_WIDTH 1.5
#define ESPE_FOG_UNDERWATER_COLOR vec3(0.1, 0.4, 0.6)

#define CAMERA_OFFSET vec3(0.0, 1.75, 0.0)
#define SKY_COLOR vec4(0.1, 0.35, 0.7, 1.0)
#define MIX_SKY_AND_FOG
#define SKY_HEIGHT 270.0
#define CLOUD_OCTAVES 50.0
#define CLOUD_ADDITION 0.15
#define CLOUD_LACUNARITY 1.6
#define CLOUD_FREQUENCY 1.0

//#define OVER_SATURATED
#define CAVE_TONE_MAPPING
#define CAVE_MAX_DARKNESS 0.35
//#define MORE_REALISTIC_CAVE

//[--]
//[--]
//[--]



//[--]
