/**
* Adjusts the saturation of a color.
*
* @name czm_saturation
* @glslFunction
*
* @param {vec3} rgb The color.
* @param {float} adjustment The amount to adjust the saturation of the color.
*
* @returns {float} The color with the saturation adjusted.
*
* @example
* vec3 greyScale = czm_saturation(color, 0.0);
* vec3 doubleSaturation = czm_saturation(color, 2.0);
* source: https://github.com/AnalyticalGraphicsInc
*/
vec3 saturation(vec3 rgb, float adjustment){
  // Algorithm from Chapter 16 of OpenGL Shading Language
  const vec3 W = vec3(0.2125, 0.7154, 0.0721);
  vec3 intensity = VEC3(dot(rgb, W));
  return clamp(mix(intensity, rgb, adjustment), VEC3(0.0), VEC3(1.0));
}

vec3 burgess(vec3 col){
  col = col - 0.004;
  vec3 a = VEC3(8.7);
  vec3 b = VEC3(0.05);
  vec3 c = VEC3(6.1);
  vec3 d = VEC3(4.0);
  vec3 e = VEC3(0.4);
  vec3 f = VEC3(0.0);

  return (col * (a * col + b)) / (col * (c * col + d) + e) + f;
}

vec3 gamaCorection(vec3 col){
  return pow(col, VEC3(1.0 / 2.2));
}

//credits on https://github.com/armory3d/armory/blob/master/Shaders/std/tonemap.glsl
vec3 unchartedTonemap(vec3 x){
  vec3 A = vec3(0.15, 0.15, 0.15);
  vec3 B = vec3(0.50, 0.50, 0.50);
  vec3 C = vec3(0.10, 0.10, 0.10);
  vec3 D = vec3(0.20, 0.20, 0.20);
  vec3 E = vec3(0.02, 0.02, 0.02);
  vec3 F = vec3(0.30, 0.30, 0.30);
  return ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F;
}

vec3 unchartedTonemapTwo(vec3 c){
  float W = 11.2;
  vec3 exposureBias = vec3(2.0, 2.0, 2.0);
  vec3 curr = unchartedTonemap(exposureBias * c);
  vec3 whiteScale = vec3(1.0, 1.0, 1.0) / unchartedTonemap(vec3(W, W, W));
  return curr * whiteScale;
}

// Based on Filmic Tonemapping Operators http://filmicgames.com/archives/75
vec3 tonemapFilmic(vec3 ccolor) {
  vec3 x = max(vec3(0.0, 0.0, 0.0), ccolor - 0.004);
  return (x * (6.2 * x + 0.5)) / (x * (6.2 * x + 1.7) + 0.06);
}

// https://knarkowicz.wordpress.com/2016/01/06/aces-filmic-tone-mapping-curve/
vec3 acesFilm(vec3 x) {
    const float a = 2.51;
    const float b = 0.03;
    const float c = 2.43;
    const float d = 0.59;
    const float e = 0.14;
    return clamp((x * (a * x + b)) / (x * (c * x + d ) + e), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
}

vec3 tonemapReinhard(vec3 ccolor) {
  return ccolor / (ccolor + vec3(1.0, 1.0, 1.0));
}
