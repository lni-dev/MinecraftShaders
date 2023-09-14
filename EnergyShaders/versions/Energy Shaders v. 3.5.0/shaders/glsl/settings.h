//this are the Settings for everything provided by these shaders!

//This is the Color of the Sky
#define SKY_COLOR vec4(0.1, 0.35, 0.7, 0.5)


//Active this to enable Clouds
#define CLOUD
//This is how fast the Clouds should move in the z Direction. this only works if CLOUD is Active
#define CLOUD_Z_MOVE_SCALE 0.05
//This is how fast the Clouds should move in the x Direction.this only works if CLOUD is Active
#define CLOUD_X_MOVE_SCALE 0.001

//#define ULTRA_CLOUDS


//Active this to enable Leave waves
#define LEAVE_WAVES
//This is how fast the Leaves do move
#define LEAVE_WAVES_SPEED 1.25
//This is a height multiplicator, and it is not the real height
#define LEAVE_WAVES_HEIGH 0.04


#define CAMERA_OFFSET vec3(0.0, 1.75, 0.0)


#define ROUND_SKY_FACTOR 4.0
#define ROUND_SKY_FACTOR_TOO 15.0


#define CLOUD_RAIN_COLOR vec3(0.25, 0.3, 0.3)


#define MIX_SKY_AND_FOG


#define E_SKY_COLOR vec3(0.1, 0.35, 0.7)
#define SKY_HEIGH 270.0


#define E_FOG
#define USE_MOJANG_FOG_COLOR
#define E_FOG_COLOR vec3(0.3, 0.4, 0.7)
#define MIX_E_FOG_WITH_MOJANG_FOG
#define E_UNDERWATER_FOG
#define E_UNDERWATER_FOG_COLOR vec3(0.2, 0.4, 0.8)


#define E_SHADOW
#define E_SHADOW_WIDTH 0.87
#define E_SHADOW_FADE_IN
//second number is calculated out 1.0 / first number
#define FADE_IN_E_SHADOW_WIDTH vec2(0.025, 40.0)

//#define USE_MOJANG_TORCH_LIGHT_AND_SHADOW

#define E_TORCH_LIGHT
#define E_TORCH_LIGHT_COLOR vec3(0.9, 0.15, 0.05)
#define E_TORCH_LIGHT_OFFSET -0.4
//#define USE_TORCH_LIGHT_OF_CHRISMAS_SHADERS
//#define EXPERIMENTAL_LIGHT


#define ENERGY_COLOR_MAP
#define SUN_LIGHT
#define FOG_BASED_NIGHT_LIGHT
#define SCREEN_BASED_BLOOM


#define TRANSPARENT_WATER
#define TRANSPARENT_WATER_OFFSET 0.65
#define E_WATER
#define E_WATER_COLOR_NEAR vec3(0.1, 0.3, 0.5)
#define E_WATER_COLOR_FAR vec3(0.3, 0.5, 0.6)


//A fake bump generated with a noise texture, can look amazing!
#define BUMP_WITH_NOISE


#define REFLECTION
//Only If REFLECTION is defined!
#define WATER_COLOR vec3(0.1, 0.25, 0.5)


//A generated 3D effect - looks weird sometimes!
//#define FAKE_BUMP_EFFECT
#define FACT 0.0065


#include "shaders/uniformPerFrameConstants.h"
