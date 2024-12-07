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
