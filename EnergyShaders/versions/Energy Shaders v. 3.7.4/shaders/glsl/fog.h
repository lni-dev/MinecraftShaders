/*
 * Copyright 2022 LinusDev
 *
 * Contact: einsuperlinus@gmail.com
 */

//diffuse
//worldPos, player is always at 0.0
//nightDay from 1.0(night) - 0.0(day)
//rain 0.0(no rain) - 1.0(rain)
//darkness 0.0(no darkness) - 1.0(darkness)
vec4 Fog(vec4 diffuse, vec3 worldPos, float nightDay, bool nether, bool end, float rain, float darkness, vec3 fog){

  #ifdef ESPE_FOG_AND_NO_FKING_MOJANG_FOG_BECAUSE_NOBODY_CARES
    float le = length(worldPos);

    float reFac = 0.8;//1.0;
    float rWidth = 0.0;
    vec3 espeFogColor = VEC3(0.0);

    if(nether){
      #ifdef NETHER_FOG
        rain = 0.0;
        rWidth = ESPE_FOG_WIDTH_NETHER;
        reFac = 0.8;
        espeFogColor = fog;
      #endif
    }else if(end){
      #ifdef END_FOG
        rain = 0.0;
        rWidth = ESPE_FOG_WIDTH_END;
        reFac = 0.8;
        espeFogColor = ESPE_FOG_COLOR_END;
      #endif
    }else{
      rWidth = mix(ESPE_FOG_WIDTH, ESPE_FOG_WIDTH_RAIN, max(0.0, rain - (max(0.0, darkness-le*0.01))*5.0));
      espeFogColor = mix(ESPE_FOG_COLOR_DAY, ESPE_FOG_COLOR_NIGHT, min(1.0, nightDay * 2.0));
      espeFogColor = mix(espeFogColor, ESPE_FOG_COLOR_RAIN, rain);
    }

    float rcWidth = min(1.0, rWidth);
    float addWidth = rWidth - rcWidth;
    float width = 1.0 - rcWidth + 0.001;


    #ifdef UNDER_WATER
      //underwater
      espeFogColor = ESPE_FOG_UNDERWATER_COLOR;
      rWidth = ESPE_FOG_UNDERWATER_WIDTH;
      rcWidth = min(1.0, rWidth);
      addWidth = (rWidth - rcWidth)*0.45;
      width = 1.0 - rcWidth  -0.0001;

      le = max(0.0, ((le/(RENDER_DISTANCE_UNDER_WATER)) - width)) + addWidth;
      le = min(1.0, le);
    #else
      le = max(0.0, ((le/(RENDER_DISTANCE*reFac)) - width)) + addWidth;
      le = min(1.0, le);
      if(end){
        le = smoothstep(0.0, 1.0, le);
      }
    #endif


    if(le > 0.95 && !nether){
      float lee = (le - 0.95) * 20.0;
      #ifdef MIX_SKY_AND_FOG
        vec3 skyColor = fog;
      #else
        vec3 skyColor = SKY_COLOR(worldPos.y * 0.005) * SKY_COLOR_FACT(fog);
      #endif
      espeFogColor = mix(espeFogColor, skyColor, lee);
    }

    diffuse.rgb = mix(diffuse.rgb, espeFogColor, le);
  #endif

  return diffuse;
}
