//diffuse
//worldPos, player is always at 0.0
//nightDay from 1.0(night) - 0.0(day)
//rain 0.0(no rain) - 1.0(rain)
//darkness 0.0(no darkness) - 1.0(darkness)
vec4 Fog(vec4 diffuse, vec3 worldPos, float nightDay, float rain, float darkness){

  #ifdef ESPE_FOG_AND_NO_FKING_MOJANG_FOG_BECAUSE_NOBODY_CARES
    float le = length(worldPos);

    float reFac = 0.8;//1.0;
    float rWidth = mix(ESPE_FOG_WIDTH, ESPE_FOG_WIDTH_RAIN, max(0.0, rain - (max(0.0, darkness-le*0.01))*5.0));
    #ifdef NETHER_FOG
      if(darkness > 0.99 && FOG_COLOR.r > (FOG_COLOR.b + FOG_COLOR.g)){
        rWidth = ESPE_FOG_WIDTH_NETHER;
        reFac = 0.5;
      }
    #endif
    float rcWidth = min(1.0, rWidth);
    float addWidth = rWidth - rcWidth;
    float width = 1.0 - rcWidth + 0.001;
    vec3 espeFogColor = mix(ESPE_FOG_COLOR_DAY, ESPE_FOG_COLOR_NIGHT, min(1.0, nightDay * 2.0));
    espeFogColor = mix(espeFogColor, ESPE_FOG_COLOR_RAIN, rain);

    #ifdef UNDER_WATER
      //underwater
      espeFogColor = ESPE_FOG_UNDERWATER_COLOR;
      rWidth = ESPE_FOG_UNDERWATER_WIDTH;
      rcWidth = min(1.0, rWidth);
      addWidth = (rWidth - rcWidth)*0.45;
      width = 1.0 - rcWidth  -0.0001;
    #endif

    #ifdef NETHER_FOG
      if(darkness > 0.99 && FOG_COLOR.r > (FOG_COLOR.b + FOG_COLOR.g)){
        espeFogColor = ESPE_FOG_COLOR_NETHER;
      }
    #endif

    #ifdef UNDER_WATER
      le = max(0.0, ((le/(RENDER_DISTANCE_UNDER_WATER)) - width)) + addWidth;
      le = min(1.0, le);
    #else
      le = max(0.0, ((le/(RENDER_DISTANCE*reFac)) - width)) + addWidth;
      le = min(1.0, le);
    #endif


    if(le > 0.9){
      float lee = (le - 0.9) * 10.0;
      espeFogColor = mix(espeFogColor, FOG_COLOR.rgb, lee);
    }

    diffuse.rgb = mix(diffuse.rgb, espeFogColor, le);
  #endif

  return diffuse;
}
