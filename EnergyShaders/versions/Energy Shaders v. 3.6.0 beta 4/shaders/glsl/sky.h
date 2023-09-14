highp float unrealPos(highp float x, highp float z, float fact){
  highp float factor = length(vec2(x, z));

  //return pow(5.6-factor, 20.0) / (pow(10.0, 12.0)*0.98);
  highp float angle = atan2(factor, fact);
  return cos(angle)*25.0;
}

/*float default3DFbm(vec3 P, float frequency, float lacunarity, float octaves, float addition)
{
  float t = 0.0f;
  float amplitude = 1.0;
  float amplitudeSum = 0.0;
  for(float k = 0.0f; k < octaves; ++k)
  {
    t += min(cnoise(P * frequency)+addition, 1.0) * amplitude;
    amplitudeSum += amplitude;
    amplitude *= 0.5;
    frequency *= lacunarity;
  }
  return t/amplitudeSum;
}*/

/*vec4 calcClouds(highp vec3 pos, vec3 viewVec){
  float cloudA = 0.0;
  vec3 cloudRGB = vec3(1.0, 1.0, 1.0);
  vec3 cpos = vec3(pos.x, 0.0, pos.z);
  viewVec = normalize(viewVec);

  float layerCount = 100.0f;
  for(float i=0; i < layerCount; i += 1.0f) {
    float a = cnoise(-cpos)* 0.5;
    cloudA += a;
    if(cloudRGB.r > 0.4){
      cloudRGB -= a*0.1;
    }

    cpos += viewVec * 0.1f;
  }
  return vec4(cloudRGB.r, cloudRGB.r, cloudRGB.r, cloudA);
}*/

vec4 calcSky(highp vec3 pos){
  highp float dis = length(pos.xz);
  float disForSky = clamp(dis*1.3, 0.0, 1.0);//1.3

  vec4 diffuse = SKY_COLOR;
  diffuse.rgb *= vec3(FOG_COLOR.b+0.1, FOG_COLOR.b+0.1, FOG_COLOR.b+0.3);
  diffuse.rgb += vec3(0.1, 0.0, 0.0) * pow(FOG_COLOR.r, 2.0);

  pos *= 18.0;

  vec4 clouds = vec4(1.0, 1.0, 1.0, 1.0);//calcClouds(pos, float3(pos.x, SKY_HEIGHT, pos.z) - (CAMERA_OFFSET));
  //float a = default3DFbm(pos, CLOUD_FREQUENCY, CLOUD_LACUNARITY, CLOUD_OCTAVES, CLOUD_ADDITION) * 3.0 - default3DFbm(pos + vec3(4325.0, 4534.0, 54237.0), CLOUD_FREQUENCY, CLOUD_LACUNARITY*10.0, CLOUD_OCTAVES, CLOUD_ADDITION) * 0.25;
  //a /= 3.0;
  //a -= 0.1;
  //a *= 1.5;

  //diffuse.rgb = mix(diffuse.rgb, clouds.rgb, clamp(a, 0.0, 1.0));


  //Mix it with the Fog, so there is no "cut" between the fog and the sky!
  #ifdef MIX_SKY_AND_FOG
    diffuse.rgb = mix(diffuse.rgb, FOG_COLOR.rgb,	disForSky);
    diffuse.a = min(1.0, diffuse.a + disForSky);
  #endif


  return diffuse;
}

/*vec3 worldPosToCloudPos(vec3 n, float sky_height){
  //Expand factor
  float Expandfactor = sky_height / n.y;
  //It is now it the heigh of the clouds, and it would be the right refletion, but the sky position doesn't equals the worldPos, so it is still not real :/
  vec3 UnrealCloudPos = n * Expandfactor;
  return (UnrealCloudPos / (RENDER_DISTANCE*60.0));
}*/
