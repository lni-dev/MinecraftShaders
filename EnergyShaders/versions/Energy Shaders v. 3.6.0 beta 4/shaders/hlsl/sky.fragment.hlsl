#include "ShaderConstants.fxh"

struct PS_Input
{
    float4 position : SV_Position;
    float3 skyPos : POSI;
    float4 color : COLOR;
};

struct PS_Output
{
    float4 color : SV_Target;
};
















//settings.h:
      #define SHADOW
      #define SHADOW_WIDTH 0.87
      #define SHADOW_COLOR_DAY float3(0.5, 0.5, 0.65)
      #define SHADOW_COLOR_NIGHT float3(0.5, 0.5, 0.5)
      #define SHADOW_COLOR_CAVE float3(0.45, 0.45, 0.65)
      #define SHADOW_FADE_IN
      #define FADE_IN_SHADOW_WIDTH 0.025
      //TODO: not implemented yet
      #define SHADOW_BACKFACE
      #define SHADOW_BACKFACE_COLOR float3(0.5, 0.5, 0.5)
      #define TONE_MAPPING
      #define TORCH_LIGHT
      #define TORCH_LIGHT_STRENGTH 15.0
      #define TROCH_LIGHT_OFFSET -0.35
      #define TORCH_LIGHT_OFFSET_CAVES -0.1
      #define TORCH_COLOR_DAY float3(0.65, 0.3, 0.1)
      #define TORCH_COLOR_NIGHT float3(0.65, 0.3, 0.1)
      #define TORCH_COLOR_CAVE float3(0.5, 0.25, 0.05)
      #define SUN_LIGHT
      #define SUN_LIGHT_COLOR_DAY float3(1.2, 1.3, 1.25)
      #define SUN_LIGHT_COLOR_NIGHT float3(0.7, 0.7, 0.9)

      #define ESPE_FOG_AND_NO_FKING_MOJANG_FOG_BECAUSE_NOBODY_CARES
      #define ESPE_FOG_COLOR_DAY float3(0.2, 0.45, 0.6)
      #define ESPE_FOG_COLOR_NIGHT float3(0.01, 0.05, 0.1)
      #define ESPE_FOG_COLOR_RAIN float3(0.4, 0.45, 0.5)
      #define ESPE_FOG_WIDTH 1.0
      #define ESPE_FOG_WIDTH_RAIN 1.3
      #define NIGHT_TONE_MAPPING

      #define CAMERA_OFFSET float3(0.0, 1.75, 0.0)
      #define SKY_COLOR float4(0.1, 0.35, 0.7, 1.0)
      #define MIX_SKY_AND_FOG
      #define SKY_HEIGHT 270.0
      #define CLOUD_OCTAVES 13.0
      #define CLOUD_ADDITION 0.45
      #define CLOUD_LACUNARITY 1.3
      #define CLOUD_FREQUENCY 0.25

      //#define CLOUDS

//settings.h-end

//noise.h:
      //	Classic Perlin 3D Noise
      //	by Stefan Gustavson
      //
      float mod(float x, float y){return x - y * floor(x/y);}
      float2 mod(float2 x, float y){return x - float2(y, y) * floor(x / float2(y, y));}
      float3 mod(float3 x, float y){return x - float3(y, y, y) * floor(x / float3(y, y, y));}
      float4 mod(float4 x, float y){return x - float4(y, y, y, y) * floor(x / float4(y, y, y, y));}
      float4 permute(float4 x){return mod(((x*34.0)+1.0)*x, 289.0);}
      float4 taylorInvSqrt(float4 r){return 1.79284291400159 - 0.85373472095314 * r;}
      float3 fade(float3 t) {return t*t*t*(t*(t*6.0-15.0)+10.0);}

      float cnoise(float3 P){
        float3 Pi0 = floor(P); // Integer part for indexing
        float3 Pi1 = Pi0 + float3(1.0, 1.0, 1.0); // Integer part + 1
        Pi0 = mod(Pi0, 289.0);
        Pi1 = mod(Pi1, 289.0);
        float3 Pf0 = frac(P); // Fractional part for interpolation
        float3 Pf1 = Pf0 - float3(1.0, 1.0, 1.0); // Fractional part - 1.0
        float4 ix = float4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
        float4 iy = float4(Pi0.y, Pi0.y, Pi1.y,  Pi1.y);
        float4 iz0 = float4(Pi0.z, Pi0.z, Pi0.z, Pi0.z);
        float4 iz1 = float4(Pi1.z, Pi1.z, Pi1.z, Pi1.z);

        float4 ixy = permute(permute(ix) + iy);
        float4 ixy0 = permute(ixy + iz0);
        float4 ixy1 = permute(ixy + iz1);

        float4 gx0 = ixy0 / 7.0;
        float4 gy0 = frac(floor(gx0) / 7.0) - 0.5;
        gx0 = frac(gx0);
        float4 gz0 = float4(0.5, 0.5, 0.5, 0.5) - abs(gx0) - abs(gy0);
        float4 sz0 = step(gz0, float4(0.0, 0.0, 0.0, 0.0));
        gx0 -= sz0 * (step(0.0, gx0) - 0.5);
        gy0 -= sz0 * (step(0.0, gy0) - 0.5);

        float4 gx1 = ixy1 / 7.0;
        float4 gy1 = frac(floor(gx1) / 7.0) - 0.5;
        gx1 = frac(gx1);
        float4 gz1 = float4(0.5, 0.5, 0.5, 0.5) - abs(gx1) - abs(gy1);
        float4 sz1 = step(gz1, float4(0.0, 0.0, 0.0, 0.0));
        gx1 -= sz1 * (step(0.0, gx1) - 0.5);
        gy1 -= sz1 * (step(0.0, gy1) - 0.5);

        float3 g000 = float3(gx0.x,gy0.x,gz0.x);
        float3 g100 = float3(gx0.y,gy0.y,gz0.y);
        float3 g010 = float3(gx0.z,gy0.z,gz0.z);
        float3 g110 = float3(gx0.w,gy0.w,gz0.w);
        float3 g001 = float3(gx1.x,gy1.x,gz1.x);
        float3 g101 = float3(gx1.y,gy1.y,gz1.y);
        float3 g011 = float3(gx1.z,gy1.z,gz1.z);
        float3 g111 = float3(gx1.w,gy1.w,gz1.w);

        float4 norm0 = taylorInvSqrt(float4(dot(g000, g000), dot(g010, g010), dot(g100, g100), dot(g110, g110)));
        g000 *= norm0.x;
        g010 *= norm0.y;
        g100 *= norm0.z;
        g110 *= norm0.w;
        float4 norm1 = taylorInvSqrt(float4(dot(g001, g001), dot(g011, g011), dot(g101, g101), dot(g111, g111)));
        g001 *= norm1.x;
        g011 *= norm1.y;
        g101 *= norm1.z;
        g111 *= norm1.w;

        float n000 = dot(g000, Pf0);
        float n100 = dot(g100, float3(Pf1.x, Pf0.yz));
        float n010 = dot(g010, float3(Pf0.x, Pf1.y, Pf0.z));
        float n110 = dot(g110, float3(Pf1.xy, Pf0.z));
        float n001 = dot(g001, float3(Pf0.xy, Pf1.z));
        float n101 = dot(g101, float3(Pf1.x, Pf0.y, Pf1.z));
        float n011 = dot(g011, float3(Pf0.x, Pf1.yz));
        float n111 = dot(g111, Pf1);

        float3 fade_xyz = fade(Pf0);
        float4 n_z = lerp(float4(n000, n100, n010, n110), float4(n001, n101, n011, n111), fade_xyz.z);
        float2 n_yz = lerp(n_z.xy, n_z.zw, fade_xyz.y);
        float n_xyz = lerp(n_yz.x, n_yz.y, fade_xyz.x);
        return 2.2 * n_xyz;
      }
//noise.h-end

//sky.h:

      min16float unrealPos(min16float x, min16float z, float fact){
        min16float factor = length(float2(x, z));

        //return pow(5.6-factor, 20.0) / (pow(10.0, 12.0)*0.98);
        min16float angle = atan2(factor, fact);
        return cos(angle)*25.0;
      }

      float default3DFbm(float3 P, float frequency, float lacunarity, float octaves, float addition)
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
      }

      float4 calcClouds(min16float3 pos, float3 viewVec){
        float cloudA = 0.0;
        float3 cloudRGB = float3(1.0, 1.0, 1.0);
        float3 cpos = float3(pos.x, 0.0, pos.z);
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
        return float4(cloudRGB.r, cloudRGB.r, cloudRGB.r, cloudA);
      }

      float4 calcSky(min16float3 pos){
        min16float dis = length(pos.xz);
        float disForSky = clamp(dis*1.3, 0.0, 1.0);//1.3

        float4 diffuse = SKY_COLOR;
        diffuse.rgb *= float3(FOG_COLOR.b+0.1, FOG_COLOR.b+0.1, FOG_COLOR.b+0.3);
        diffuse.rgb += float3(0.1, 0.0, 0.0) * pow(FOG_COLOR.r, 2.0);

        pos *= 18.0;

        float4 clouds = float4(1.0, 1.0, 1.0, 1.0);//calcClouds(pos, float3(pos.x, SKY_HEIGHT, pos.z) - (CAMERA_OFFSET));
        #ifdef CLOUDS
          float a = default3DFbm(pos, CLOUD_FREQUENCY, CLOUD_LACUNARITY, CLOUD_OCTAVES, CLOUD_ADDITION) * 3.0 - default3DFbm(pos + float3(4325.0, 4534.0, 54237.0), CLOUD_FREQUENCY, CLOUD_LACUNARITY*10.0, CLOUD_OCTAVES, CLOUD_ADDITION) * 0.25;
          a /= 3.0;
          a -= 0.1;
          a *= 1.5;
        #else
          float a = 0.0;
        #endif

        diffuse.rgb = lerp(diffuse.rgb, clouds.rgb, clamp(a, 0.0, 1.0));


        //Mix it with the Fog, so there is no "cut" between the fog and the sky!
        #ifdef MIX_SKY_AND_FOG
          diffuse.rgb = lerp(diffuse.rgb, FOG_COLOR.rgb,	disForSky);
          diffuse.a = min(1.0, diffuse.a + disForSky);
        #endif


        return diffuse;
      }

      float3 worldPosToCloudPos(float3 n, float sky_height){
				//Expand factor
				float Expandfactor = sky_height / n.y;
				//It is now it the heigh of the clouds, and it would be the right refletion, but the sky position doesn't equals the worldPos, so it is still not real :/
				float3 UnrealCloudPos = n * Expandfactor;
				return (UnrealCloudPos / (RENDER_DISTANCE*60.0));
			}
//sky.h-end






















ROOT_SIGNATURE
void main(in PS_Input PSInput, out PS_Output PSOutput)
{
    PSOutput.color = calcSky(PSInput.skyPos);
}
