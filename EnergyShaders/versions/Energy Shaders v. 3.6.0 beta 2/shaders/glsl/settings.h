
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
#define TROCH_LIGHT_OFFSET -0.35
#define TORCH_LIGHT_OFFSET_CAVES -0.1

//[--]

//the color factors for the light
//[-]
#define TORCH_COLOR_DAY vec3(0.65, 0.3, 0.1)
//[-]
#define TORCH_COLOR_NIGHT vec3(0.65, 0.3, 0.1)
//[-]
#define TORCH_COLOR_CAVE vec3(0.5, 0.25, 0.05)
//[-]


//[--]

//Sun (and moon) light
#define SUN_LIGHT

//[-]
#define SUN_LIGHT_COLOR_DAY vec3(1.2, 1.2, 1.2)
//[-]
#define SUN_LIGHT_COLOR_NIGHT vec3(0.7, 0.7, 0.9)
//[-]


//[--]

//Empty

//[--]
//[--]
//[--]



//[--]
