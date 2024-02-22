/**
 * Copyright (c) 2022-2023 LinusDev
 * Author: Linusdev
 * Contact: linus@linusdev.de
 */

#ifndef AMBIENT_H
#define AMBIENT_H

struct WorldInfo {
  VEC4 colorRaw; // texture(TEXTURE_0, texCoord0) * vertexColor * ColorModulator
  VEC3 normal; // normal vector
  VEC3 screenPos; // pixel position
  VEC3 playerCenteredPos; //position, centered at the players position

  VEC4 fogColor; // color of the background in mc (not the sky)
  float fogStart;
  float fogEnd; // render distance (not really but usefull)
  int fogShape; // 0 = sphere, 1 = cylinder

  float shadow; // (0.0: no shadow - 1.0: max shadow)
  float light; // (0.0: no light - 1.0: max light)
  float time; // (0.0: day - 1.0: night)
  float cave; // (0.0: not in a cave - 1.0: deep in a cave)
  bool nether;
  bool end;
  bool gui;
  bool hasNormal;
};

void ESRenderGui(inout VEC4 color, in WorldInfo info) {
  //The gui items need some shading:
  VEC3 l1 = normalize(VEC3(-1., -2., 1.));
  color.rgb *= min(max(0.0, dot(info.normal.xyz, l1)) + 0.4, 1.0);
}

void ESRenderFogOverworld(inout VEC4 color, in WorldInfo info) {
  #ifdef ES_ENABLE_FOG
    float start = mix(ES_FOG_START, ES_CAVE_FOG_START, info.cave);
    #ifdef MIX_ES_FOG_AND_MC_FOG
      float startMix = mix(ES_FOG_START_MIX_WITH_MOJANG_FOG, ES_CAVE_FOG_START_MIX_WITH_MOJANG_FOG, info.cave);
    #endif
    float end = mix(ES_FOG_END, ES_CAVE_FOG_END, info.cave);

    float uniformDistance = min(length(info.playerCenteredPos.xyz) / max(info.fogEnd, ES_FOG_MIN_DISTANCE), end);

    #ifdef MIX_ES_FOG_AND_MC_FOG
      float fogIntensity = smoothstep(start, startMix, uniformDistance);
      float mixESFogAndMCFog = smoothstep(startMix, end, uniformDistance);
    #else
      float fogIntensity = smoothstep(start, end, uniformDistance);
    #endif

    VEC3 esFogColor = mix(ES_FOG_COLOR_DAY(info.fogColor.rgb, color.rgb), ES_FOG_COLOR_NIGHT(info.fogColor.rgb, color.rgb), info.time);
    esFogColor = mix(esFogColor, ES_CAVE_FOG_COLOR(info.fogColor.rgb, color.rgb), info.cave);
    #ifdef MIX_ES_FOG_AND_MC_FOG
      esFogColor = mix(esFogColor, info.fogColor.rgb, mixESFogAndMCFog);
    #endif

    color.rgb = mix(color.rgb, esFogColor, fogIntensity);
  #endif
}

void ESRenderOverworld(inout VEC4 color, in WorldInfo info) {

  #ifdef SHADOW
    VEC3 shadowColor = mix(SHADOW_COLOR_DAY, SHADOW_COLOR_NIGHT, info.time);
    shadowColor = mix(shadowColor, SHADOW_COLOR_CAVE, info.cave);

    color.rgb = mix(color.rgb, color.rgb * shadowColor, clamp(info.shadow - (info.light), 0.0, 1.0));
  #endif

  #ifdef TORCH_LIGHT
    VEC3 lightColor = mix(TORCH_COLOR_DAY, TORCH_COLOR_NIGHT, info.time);
    lightColor = mix(lightColor, TORCH_COLOR_CAVE, info.cave);

    color.rgb *= (lightColor * info.light + VEC3(1.0));
  #endif

  #ifdef AMBIENT_LIGHT
    VEC3 ambientLightColor = mix(AMBIENT_LIGHT_DAY, AMBIENT_LIGHT_NIGHT, info.time);

    color.rgb *= mix(ambientLightColor, VEC3(1.0), info.cave);

    #ifdef NIGHT_GREY_SCALE
      //To get a grey effect, all values (r, g, b) should be almost the same.
      //I will mix them together to get a effect like this
      float r = color.r; float g = color.g; float b = color.b;

      float c = mix(mix(r, g, 0.5), b, 0.5) * 0.75;

      r = mix(r, c, 0.99);
      g = mix(g, c, 0.99);
      b = mix(b, c, 0.99);

      color.rgb = mix(color.rgb, vec3(r, g, b), max(info.time - min(info.cave + info.light, 1.0) - (1.0 - NIGHT_GREY_SCALE_PERCENTAGE), 0.0));
    #endif  
  #endif

  #ifdef SATURATION
    color.rgb = saturation(color.rgb, SATURATION);
  #endif

  #ifdef TONE_MAPPING
    color.rgb = burgess(color.rgb);
  #endif

  ESRenderFogOverworld(color, info);

  #ifdef VIGNETTE
    VEC3 vignetteColor = mix(VIGNETTE_COLOR_DAY, VIGNETTE_COLOR_NIGHT, info.time);
    vignetteColor = mix(vignetteColor, VIGNETTE_COLOR_CAVE, info.cave);
    float range = length(info.screenPos.xy / (info.screenPos.z + 0.1)) * 0.85;

    color.rgb = mix(color.rgb, color.rgb * vignetteColor, clamp((range - 0.5) * 2.0, 0.0, 1.0));
  #endif
}




void ESRenderFogNether(inout VEC4 color, in WorldInfo info) {
  #ifdef ES_NETHER_ENABLE_FOG
    float start = ES_NETHER_FOG_START;
    #ifdef MIX_ES_FOG_AND_MC_FOG
      float startMix = ES_NETHER_FOG_START_MIX_WITH_MOJANG_FOG;
    #endif
    float end = ES_NETHER_FOG_END;

    float uniformDistance = min(length(info.playerCenteredPos.xyz) / max(info.fogEnd, ES_FOG_MIN_DISTANCE), end);

    #ifdef MIX_ES_FOG_AND_MC_FOG
      float fogIntensity = smoothstep(start, startMix, uniformDistance);
      float mixESFogAndMCFog = smoothstep(startMix, end, uniformDistance);
    #else
      float fogIntensity = smoothstep(start, end, uniformDistance);
    #endif

    VEC3 esFogColor = ES_NETHER_FOG_COLOR(info.fogColor.rgb, color.rgb);
    #ifdef MIX_ES_FOG_AND_MC_FOG
      esFogColor = mix(esFogColor, info.fogColor.rgb, mixESFogAndMCFog);
    #endif

    color.rgb = mix(color.rgb, esFogColor, fogIntensity);
  #endif
}

void ESRenderNether(inout VEC4 color, in WorldInfo info) {

  #ifdef SHADOW
    VEC3 shadowColor = SHADOW_COLOR_NETHER;

    //Note that the Nether is always in full shadow (it has no sun)
    color.rgb = mix(color.rgb, color.rgb * shadowColor, clamp(1.0 - (info.light), 0.0, 1.0));
  #endif

  #ifdef TORCH_LIGHT
    VEC3 lightColor = TORCH_COLOR_NETHER;

    color.rgb *= (lightColor * info.light + VEC3(1.0));
  #endif

  #ifdef AMBIENT_LIGHT
    VEC3 ambientLightColor = AMBIENT_LIGHT_NETHER;

    color.rgb *= ambientLightColor;
  #endif

  #ifdef SATURATION
    color.rgb = saturation(color.rgb, SATURATION);
  #endif

  #ifdef TONE_MAPPING
    color.rgb = burgess(color.rgb);
  #endif

  if(info.gui) {
    //Don't draw fog or vignette in gui
    return;
  }

  ESRenderFogNether(color, info);

  #ifdef VIGNETTE
    VEC3 vignetteColor = VIGNETTE_COLOR_NETHER;
    float range = length(info.screenPos.xy / (info.screenPos.z + 0.1)) * 0.85;

    color.rgb = mix(color.rgb, color.rgb * vignetteColor, clamp((range - 0.5) * 2.0, 0.0, 1.0));
  #endif
}




void ESRenderFogEnd(inout VEC4 color, in WorldInfo info) {
  #ifdef ES_END_ENABLE_FOG
    float start = ES_END_FOG_START;
    #ifdef MIX_ES_FOG_AND_MC_FOG
      float startMix = ES_END_FOG_START_MIX_WITH_MOJANG_FOG;
    #endif
    float end = ES_END_FOG_END;

    float uniformDistance = min(length(info.playerCenteredPos.xyz) / max(info.fogEnd, ES_FOG_MIN_DISTANCE), end);

    #ifdef MIX_ES_FOG_AND_MC_FOG
      float fogIntensity = smoothstep(start, startMix, uniformDistance);
      float mixESFogAndMCFog = smoothstep(startMix, end, uniformDistance);
    #else
      float fogIntensity = smoothstep(start, end, uniformDistance);
    #endif

    VEC3 esFogColor = ES_END_FOG_COLOR(info.fogColor.rgb, color.grb);
    #ifdef MIX_ES_FOG_AND_MC_FOG
      esFogColor = mix(esFogColor, info.fogColor.rgb, mixESFogAndMCFog);
    #endif

    color.rgb = mix(color.rgb, esFogColor, fogIntensity);
  #endif
}

void ESRenderEnd(inout VEC4 color, in WorldInfo info) {

  #ifdef SHADOW
    VEC3 shadowColor = SHADOW_COLOR_END;

    //Note that the End is always in full shadow (it has no sun)
    color.rgb = mix(color.rgb, color.rgb * shadowColor, clamp(1.0 - (info.light), 0.0, 1.0));
  #endif

  #ifdef TORCH_LIGHT
    VEC3 lightColor = TORCH_COLOR_END;

    color.rgb *= (lightColor * info.light + VEC3(1.0));
  #endif

  #ifdef AMBIENT_LIGHT
    VEC3 ambientLightColor = AMBIENT_LIGHT_END;

    color.rgb *= ambientLightColor;
  #endif

  #ifdef SATURATION
    color.rgb = saturation(color.rgb, SATURATION);
  #endif

  #ifdef TONE_MAPPING
    color.rgb = burgess(color.rgb);
  #endif

  if(info.gui) {
    //Don't draw fog or vignette in gui
    return;
  }

  ESRenderFogEnd(color, info);

  #ifdef VIGNETTE
    VEC3 vignetteColor = VIGNETTE_COLOR_END;
    float range = length(info.screenPos.xy / (info.screenPos.z + 0.1)) * 0.85;

    color.rgb = mix(color.rgb, color.rgb * vignetteColor, clamp((range - 0.5) * 2.0, 0.0, 1.0));
  #endif
}



#endif