/**
 * Copyright (c) 2022-2023 LinusDev
 * Author: Linusdev
 * Contact: linus@linusdev.de
 */


#ifndef COMPATIBILITY_H
  #define COMPATIBILITY_H

  #define ES_JAVA
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
   
    #define FOG_COLOR FogColor
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



