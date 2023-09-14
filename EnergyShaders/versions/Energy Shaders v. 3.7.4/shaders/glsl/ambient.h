/*
 * Copyright 2022 LinusDev
 *
 * Contact: einsuperlinus@gmail.com
 */

//diffuse
//screenPosition
//shadow from 0.0(no shadow) - 1.0(full shadow)
//light from 0.0(no light) - 1.0(light)
//nightDay from 1.0(night) - 0.0(day)
//rain 0.0(no rain) - 1.0(rain)
//darkness 0.0(no darkness) - 1.0(darkness)
//N normal vector
vec4 Ambient(vec4 diffuse, vec3 screenPosition, float shadow, float light, float nightDay, bool nether, bool end, float rain, float darkness, vec3 N){

  //Calculations
  #ifdef SHADOW_BLOCK_SIDE

    shadow = clamp(shadow + abs(N.z) - min(-N.y, 0.0), 0.0, 1.0);
  #endif

  vec3 shadowColor = mix(SHADOW_COLOR_DAY, SHADOW_COLOR_NIGHT, nightDay);
  shadowColor = mix(shadowColor, SHADOW_COLOR_CAVE, darkness);

  vec3 lightColor = mix(TORCH_COLOR_DAY, TORCH_COLOR_NIGHT, nightDay);
  lightColor = mix(lightColor, TORCH_COLOR_CAVE, min(1.0, darkness*1.2));

  if(nether){
    lightColor = TORCH_COLOR_NETHER;
    #ifdef REALISTIC_NETHER
      lightColor = REALISTIC_NETHER_TORCH_LIGHT_COLOR;
    #endif
  }else if(end){
    lightColor = TORCH_COLOR_END;
  }

  float lightOffset = mix(TROCH_LIGHT_OFFSET, TORCH_LIGHT_OFFSET_CAVES, darkness);

  vec3 sunColor = mix(SUN_LIGHT_COLOR_DAY, SUN_LIGHT_COLOR_NIGHT, nightDay);

  #ifdef TORCH_LIGHT
   light += lightOffset;
   light = max(0.0, light);
   light *= light;
   light *= TORCH_LIGHT_STRENGTH;
  #endif

  vec3 caveDiffuse = diffuse.rgb;

  diffuse.rgb = saturation(diffuse.rgb, SATURATION);

  if(nether){
    #ifdef REALISTIC_NETHER
      diffuse.rgb = mix(diffuse.rgb * 0.05, diffuse.rgb, clamp((1.0 - (darkness * 0.85)) + light, 0.0, 1.0));

      #ifdef TORCH_LIGHT
      light = clamp(light-0.1, 0.0, 2.0);
      light = light*light;
       diffuse.rgb *= (lightColor * light + VEC3(1.0));
      #endif

      #ifdef TONE_MAPPING
        diffuse.rgb = (burgess(diffuse.rgb));
      #endif

    #else

      diffuse.rgb = diffuse.rgb * 0.7;

      #ifdef TORCH_LIGHT
       diffuse.rgb *= (lightColor * light + VEC3(1.0));
      #endif

      #ifdef TONE_MAPPING
        diffuse.rgb = (burgess(diffuse.rgb));
      #endif
    #endif

  }else if(end){

    diffuse.rgb = mix((diffuse.rgb) * 0.84, diffuse.rgb, 0.7);
    diffuse.rgb = saturation(diffuse.rgb, max(1.0, 1.1-light));


    #ifdef TORCH_LIGHT
      light = clamp(light*0.5-0.1, 0.0, 3.0);
     diffuse.rgb *= (lightColor * light + VEC3(1.0));
    #endif

    #ifdef TONE_MAPPING
      diffuse.rgb = (burgess(diffuse.rgb));
    #endif

  }else{	//Overworld
    //Actual magic happening
    #ifdef CAVE_TONE_MAPPING
      //This is no real tonemap it just makes the texture darker with some special funktion, to not make it look weird
      caveDiffuse = mix(unchartedTonemapTwo(diffuse.rgb) * 0.15 * CAVE_TONE_MAPPING_COLOR_FACT, diffuse.rgb, clamp((1.0 - darkness), CAVE_MAX_DARKNESS, 1.0));

      diffuse.rgb = mix(diffuse.rgb, caveDiffuse, clamp(darkness*darkness*2.0, 0.0, 1.0));
    #endif

    #ifdef MORE_REALISTIC_CAVE
      //makes Caves extremely dark if there is no light source nearby
      diffuse.rgb = mix(diffuse.rgb * 0.1, diffuse.rgb, clamp((1.0 - (darkness * 0.75)) + light, 0.0, 1.0));
    #endif

    #ifdef NIGHT_TONE_MAPPING
      //To get a grey effect, all values (r, g, b) should be almost the same.
      //I will mix them together to get a effect like this

      float r = diffuse.r;
      float g = diffuse.g;
      float b = diffuse.b;

      float c = mix(mix(r, g, 0.5), b, 0.5) * 0.75;

      r = mix(r, c, 0.99);
      g = mix(g, c, 0.99);
      b = mix(b, c, 0.99);

      diffuse.rgb = mix(diffuse.rgb, vec3(r, g, b) * (NIGHT_BRIGHTNESS_FACTOR + 0.06), clamp(nightDay - clamp(darkness + light, 0.0, 1.0), 0.0, 1.0));

    #else
      diffuse.rgb = mix(diffuse.rgb, diffuse.rgb * NIGHT_BRIGHTNESS_FACTOR, nightDay);
    #endif


    #ifdef SUN_LIGHT
      diffuse.rgb = mix(diffuse.rgb * sunColor, diffuse.rgb, shadow);
    #endif

    #ifdef SHADOW
      diffuse.rgb = mix(diffuse.rgb, diffuse.rgb * shadowColor, clamp(shadow - (light), 0.0, 1.0));
    #endif

    #ifdef TORCH_LIGHT
     diffuse.rgb *= (lightColor * light + VEC3(1.0));
    #endif

    #ifdef TONE_MAPPING
      diffuse.rgb = (burgess(diffuse.rgb));
    #endif

  }

  #ifdef VIGNETTE
    vec4 vignetteColor = mix(VIGNETTE_COLOR_FACT_DAY, VIGNETTE_COLOR_FACT_NIGHT, nightDay);
    vignetteColor = mix(vignetteColor, VIGNETTE_COLOR_FACT_CAVE, min(1.0, darkness*1.2));
    vignetteColor *= diffuse;

    float range = length(screenPosition.xy / (screenPosition.z + 0.1)) * 0.85;

    diffuse = mix(diffuse, vignetteColor, clamp((range - 0.5) * 2.0, 0.0, 1.0));
  #endif

  return diffuse;
}
