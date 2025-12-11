/**
 * Copyright (c) 2022-2025 LinusDev
 * Author: Linusdev
 * Contact: linus@linusdev.de
 */


#ifndef COMPATIBILITY_H
  #define COMPATIBILITY_H

  //#define ES_JAVA
  //#define ES_SODIUM
  //#define ES_BEDROCK_GLSL
  //#define ES_BEDROCK_HLSL

  //Minecraft Java
  #ifdef ES_JAVA
    #define GLSL

    #define texture2D texture

    #define ES_TEXTURE_ATLAS Sampler0
    #define ES_UV_TEXTURE_ATLAS texCoord0

    #define ES_LIGHT_TEXTURE Sampler2
    #define ES_UV_LIGHT_TEXTURE (texCoord2/256.0)
    
    #define CONVERT_LIGHT_UV(UV) (clamp(UV, vec2(0.5 / 16.0), vec2(15.5 / 16.0)))

    #define ES_VERTEX_COLOR vertexColor
    #define ES_COLOR_MODULATOR ColorModulator
    #ifdef SPECIAL_TEXTURE_SAMPLING
        #define ES_COLOR_RAW ((UseRgss == 1 ? sampleRGSS(ES_TEXTURE_ATLAS, ES_UV_TEXTURE_ATLAS, 1.0f / TextureSize) : sampleNearest(ES_TEXTURE_ATLAS, ES_UV_TEXTURE_ATLAS, 1.0f / TextureSize)) * ES_VERTEX_COLOR * ES_COLOR_MODULATOR)
    #else
        #define ES_COLOR_RAW (texture(ES_TEXTURE_ATLAS, ES_UV_TEXTURE_ATLAS) * ES_VERTEX_COLOR * ES_COLOR_MODULATOR)
    #endif

    // ES_ALPHA_CUTOFF_VALUE and ES_DO_ALPHA_CUTOFF are defined at the top of each shader

    #define ES_COLOR_OUT fragColor

    // ES_HAS_NORMAL is defined in shaders json
    #define ES_NORMAL normal

    #define ES_IN_FOG_START FogRenderDistanceStart
    #define ES_IN_FOG_END FogRenderDistanceEnd
    #define ES_IN_ENV_FOG_START FogEnvironmentalStart
    #define ES_IN_ENV_FOG_END FogEnvironmentalEnd
    #define ES_IN_FOG_COLOR FogColor

    #define ES_IS_GUI projMat3x == -1
  #endif

  //Minecraft Java with Sodium
  #ifdef ES_SODIUM
    #define GLSL

    #define texture2D texture

    #define ES_TEXTURE_ATLAS u_BlockTex
    #define ES_UV_TEXTURE_ATLAS v_TexCoord

    #define ES_LIGHT_TEXTURE u_LightTex
    #define ES_UV_LIGHT_TEXTURE (v_LightCoord)

    #define CONVERT_LIGHT_UV(UV) (clamp(UV, vec2(0.5 / 16.0), vec2(15.5 / 16.0)))

    #define ES_VERTEX_COLOR VEC4(1.0)
    #define ES_COLOR_MODULATOR v_Color
    #define ES_COLOR_RAW (texture(ES_TEXTURE_ATLAS, ES_UV_TEXTURE_ATLAS, _material_use_mips(v_Material) ? 0.0 : float(-MAX_TEXTURE_LOD_BIAS)) * ES_COLOR_MODULATOR)
    #define ES_ALPHA_CUTOFF_VALUE _material_alpha_cutoff(v_Material)
    #ifdef USE_FRAGMENT_DISCARD
      #define ES_DO_ALPHA_CUTOFF
    #endif
    #define ES_COLOR_OUT fragColor

    #define ES_HAS_NORMAL true
    #define ES_NORMAL VEC4(normalize(cross(dFdx(inChunkPos.xyz), dFdy(inChunkPos.xyz))), 0.0)

    #define ES_IN_FOG_START u_RenderFog.x
    #define ES_IN_FOG_END u_RenderFog.y
    #define ES_IN_ENV_FOG_START u_EnvironmentFog.x
    #define ES_IN_ENV_FOG_END u_EnvironmentFog.y
    #define ES_IN_FOG_COLOR u_FogColor

    #define ES_IS_GUI false
  #endif

  //Minecraft Bedrock GLSL
  #ifdef ES_BEDROCK_GLSL
    #define GLSL

    #define texture2D texture2D

    #define ES_TEXTURE_ATLAS TEXTURE_0
    #define ES_UV_TEXTURE_ATLAS uv0

    #define ES_LIGHT_TEXTURE TEXTURE_1
    #define ES_UV_LIGHT_TEXTURE uv1

    #define CONVERT_LIGHT_UV(UV) (UV)
  #endif

  //Minecraft Bedrock HLSL
  #ifdef ES_BEDROCK_HLSL
    #define HLSL
  #endif

  #ifdef GLSL
    #define VEC2 vec2
    #define VEC3 vec3
    #define VEC4 vec4

    //#define mix mix
  #endif

  #ifdef HLSL
    #define VEC2 float2
    #define VEC3 float3
    #define VEC4 float4

    #define mix lerp
  #endif


#endif



