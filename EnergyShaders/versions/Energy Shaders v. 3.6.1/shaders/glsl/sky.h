



vec4 calcSky(highp vec3 pos, vec3 fogC){
  highp float dis = length(pos.xz);
  highp float disForSky = clamp(dis*1.3, 0.0, 1.0);//1.3

  vec4 diffuse = SKY_COLOR;
  diffuse.rgb *= vec3(fogC.b + 0.1, fogC.b + 0.1, fogC.b + 0.3);
  diffuse.rgb += vec3(0.1, 0.0, 0.0) * pow(fogC.r, 2.0);


  //Mix it with the Fog, so there is no "cut" between the fog and the sky!
  #ifdef MIX_SKY_AND_FOG
    diffuse.rgb = mix(diffuse.rgb, fogC.rgb,	disForSky);
    diffuse.a = min(1.0, diffuse.a + disForSky);
  #endif


  return diffuse;
}
