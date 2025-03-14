/**
 * Copyright (c) 2022-2024 LinusDev
 * Author: Linusdev
 * Contact: linus@linusdev.de
 */

/**
 * @param uv1 coordinates in the minecraft lighting texture
 * @param normal normal vector
 */
float calcShadow(in VEC2 uv1, in bool hasNormal, in VEC3 normal, in bool nether, in bool end, in bool gui) {
  if(gui) {
    //The gui items need some shading:
    VEC3 l1 = normalize(VEC3(-1., -2., 1.));
    return 1.0-min(max(0.0, dot(normal.xyz, l1)) + 0.2, 1.0);
  }
  float shadow = 0.0;
  #ifdef SHADOW
    if(uv1.y <= SHADOW_WIDTH){	//if rendering in shadow
      shadow = 1.0;
      if(uv1.y >= SHADOW_WIDTH - FADE_IN_SHADOW_WIDTH){
        #ifdef SHADOW_FADE_IN
          float fadeInE = (uv1.y - (SHADOW_WIDTH - FADE_IN_SHADOW_WIDTH)) * (1.0 / FADE_IN_SHADOW_WIDTH);	//calculate fade in
          shadow = mix(1.0, 0.0, fadeInE);
        #endif
      }
    }
  #endif

  #ifdef SHADOW_BLOCK_SIDE
    if(!nether && !end && hasNormal) {
      shadow = clamp(shadow + abs(normal.z) - min(normal.y, 0.0), 0.0, 1.0);
    }
  #endif

  return shadow;
}

/**
 * @param lightTextureUv coordinates in the minecraft lighting texture
 * @param normal normal vector
 */
float calcLight(in VEC2 lightTextureUv, in VEC3 normal, bool gui) {
  #ifdef TORCH_LIGHT
    if(gui) return 0.0;
    float a = lightTextureUv.x;
    float b = 1-a;
    float h = sin(a*PI*.5);
    float p = pow(h, 2.7);
    float f = ((exp(b+.2))/E-(1.3/E))*a*b;
    float light = p+(f*-1.);

    return light;
  #else 
    return 0.0;
  #endif
}

/**
 * @param lightTexture minecraft lighting texture
 * @return between 0.0 and 1.0. 0.0 means day. 1.0 means night. values inbetween mean sunrise or sunset.
 */
float calcTime(in sampler2D lightTexture, in bool gui) {
  if(gui) return 0.0; // day
  VEC4 c_0_1 = texture2D(lightTexture, CONVERT_LIGHT_UV(VEC2(0., 1.)));

  float ret = max(pow(clamp((c_0_1.b - c_0_1.r) * 5.6,  0.0, 2.5), 1.0) - 0.1, 0.0) * 1.2;

  return clamp(ret, 0.0, 1.0);
}

/**
 * @param lightTextureUv coordinates in the minecraft lighting texture
 */
float calcCave(in VEC2 lightTextureUv) {
  return pow(1.0 - lightTextureUv.y, 2.0);
}

/**
 * @param lightTexture minecraft lighting texture
 * @param nether output nether bool
 * @param end output end bool
 */
void calcDimension(in sampler2D lightTexture, inout bool nether, inout bool end) {
  VEC3 c_0_1 = texture2D(lightTexture, CONVERT_LIGHT_UV(VEC2(0., 1.))).rgb;
  VEC3 c_0_0 = texture2D(lightTexture, CONVERT_LIGHT_UV(VEC2(0., 0.))).rgb;

  end = c_0_0.r == c_0_1.r && c_0_0.g == c_0_1.g;
  nether = !end && c_0_0.r > 0.3; 
}  
