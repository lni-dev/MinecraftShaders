/*
 * Copyright 2022 LinusDev
 *
 * Contact: einsuperlinus@gmail.com
 */
#ifndef COMPATIBILITY_H
  #define COMPATIBILITY_H
#endif

//#define vec2 vec2
//#define vec3 vec3
#define hvec3 highp vec3
//#define vec4 vec4
//#define mix mix

#define VEC2 vec2
#define VEC3 vec3
#define VEC4 vec4

//Minecraft Java:
#define ES_JAVA
//#define ES_BEDROCK_GLSL
//#define ES_BEDROCK_HLSL
#ifdef ES_JAVA
  #define texture2D texture
  #define TEXTURE_0 Sampler0
  #define TEXTURE_1 Sampler2
  #define uv0 texCoord0
  #define uv1 (texCoord2/256.0)
  #define CONVERT_LIGHT_UV(UV) (clamp(UV, vec2(0.5 / 16.0), vec2(15.5 / 16.0)))

  #define FOG_COLOR FogColor
#endif

#ifdef ES_BEDROCK_GLSL
  #define texture2D texture2D
  #define CONVERT_LIGHT_UV(UV) (UV)
#endif
