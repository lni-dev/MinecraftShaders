#include "ShaderConstants.fxh"
#include "util.fxh"

struct PS_Input
{
	float4 position : SV_Position;

#ifndef BYPASS_PIXEL_SHADER
	lpfloat4 color : COLOR;
	float3 wPos : POSI;
	float3 cPos : POSITION;
	float3 screenPos : SPOS;
	snorm float2 uv0 : TEXCOORD_0_FB_MSAA;
	snorm float2 uv1 : TEXCOORD_1_FB_MSAA;
#endif

#ifdef FOG
	float4 fogColor : FOG_COLOR;
#endif
};

struct PS_Output
{
	float4 color : SV_Target;
};










//since I can`t include files I have to put the code right here :/
//Settings.h:
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
			#define TROCH_LIGHT_OFFSET -0.23
			#define TORCH_LIGHT_OFFSET_CAVES -0.1
			#define TORCH_COLOR_DAY float3(0.15, 0.05, 0.01)
			#define TORCH_COLOR_NIGHT float3(1.2, 0.5, 0.1)
			#define TORCH_COLOR_CAVE float3(0.5, 0.25, 0.05)
			#define TORCH_COLOR_SHADOW float3(0.4, 0.35, 0.05)
			#define SUN_LIGHT
			#define SUN_LIGHT_COLOR_DAY float3(1.2, 1.3, 1.25)
			#define SUN_LIGHT_COLOR_NIGHT float3(0.7, 0.7, 0.9)

			#define ESPE_FOG_AND_NO_FKING_MOJANG_FOG_BECAUSE_NOBODY_CARES
			#define ESPE_FOG_COLOR_DAY float3(0.2, 0.45, 0.6)
			#define ESPE_FOG_COLOR_NIGHT float3(0.01, 0.05, 0.1)
			#define ESPE_FOG_COLOR_RAIN float3(0.4, 0.45, 0.5)
			#define ESPE_FOG_WIDTH 0.75
			#define ESPE_FOG_WIDTH_RAIN 1.4
			#define NIGHT_TONE_MAPPING

			#define ESPE_FOG_UNDERWATER_WIDTH 1.7
			#define RENDER_DISTANCE_UNDER_WATER 64.0
			#define ESPE_FOG_UNDERWATER_COLOR float3(0.1, 0.4, 0.6)

			#define NETHER_FOG
			#define ESPE_FOG_COLOR_NETHER float3(0.42, 0.1, 0.0)
			#define ESPE_FOG_WIDTH_NETHER 1.05

			#define CAMERA_OFFSET float3(0.0, 0., 0.0)
			#define SKY_COLOR float4(0.1, 0.35, 0.7, 1.0)
      #define MIX_SKY_AND_FOG

			//CLOUD stuff
      #define SKY_HEIGHT 270.0
      #define CLOUD_OCTAVES 50.0
      #define CLOUD_ADDITION 0.15
      #define CLOUD_LACUNARITY 1.6
      #define CLOUD_FREQUENCY 1.0

			//#define OVER_SATURATED
			#define CAVE_TONE_MAPPING
			#define CAVE_TONE_MAPPING_COLOR_FACT float3(0.35, 0.35, 1.75)
			#define CAVE_MAX_DARKNESS 0.3
			//#define MORE_REALISTIC_CAVE

			#define VIGNETTE
			#define VIGNETTE_COLOR_FACT_DAY float4(0.56, 0.56, 0.56, 1.0)
			#define VIGNETTE_COLOR_FACT_NIGHT float4(0.46, 0.46, 0.46, 1.0)
			#define VIGNETTE_COLOR_FACT_CAVE float4(0.26, 0.26, 0.39, 1.0)

			#define WATER_COLOR_IN_SHADOW_PER_CENT float4(0.55, 0.55, 0.65, 0.75)
			#define WATER_COLOR_IN_CAVES float4(0.05, 0.07, 0.25, 0.75)
			#define WATER_COLOR_AT_NIGHT_PER_CENT float4(.25, .25, .35, 0.65)
//Settings.h-end







//Tonemaps:
			//credits on https://github.com/armory3d/armory/blob/master/Shaders/std/tonemap.glsl
			float3 unchartedTonemap(float3 x){
				float3 A = float3(0.15, 0.15, 0.15);
				float3 B = float3(0.50, 0.50, 0.50);
				float3 C = float3(0.10, 0.10, 0.10);
				float3 D = float3(0.20, 0.20, 0.20);
				float3 E = float3(0.02, 0.02, 0.02);
				float3 F = float3(0.30, 0.30, 0.30);
				return ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F;
			}

			float3 unchartedTonemapTwo(float3 c){
				float W = 11.2;
				float3 exposureBias = float3(2.0, 2.0, 2.0);
				float3 curr = unchartedTonemap(exposureBias * c);
				float3 whiteScale = float3(1.0, 1.0, 1.0) / unchartedTonemap(float3(W, W, W));
				return curr * whiteScale;
			}

			// Based on Filmic Tonemapping Operators http://filmicgames.com/archives/75
			float3 tonemapFilmic(float3 ccolor) {
				float3 x = max(float3(0.0, 0.0, 0.0), ccolor - 0.004);
				return (x * (6.2 * x + 0.5)) / (x * (6.2 * x + 1.7) + 0.06);
			}

			// https://knarkowicz.wordpress.com/2016/01/06/aces-filmic-tone-mapping-curve/
			float3 acesFilm(float3 x) {
			    const float a = 2.51;
			    const float b = 0.03;
			    const float c = 2.43;
			    const float d = 0.59;
			    const float e = 0.14;
			    return clamp((x * (a * x + b)) / (x * (c * x + d ) + e), float3(0.0, 0.0, 0.0), float3(1.0, 1.0, 1.0));
			}

			float3 tonemapReinhard(float3 ccolor) {
				return ccolor / (ccolor + float3(1.0, 1.0, 1.0));
			}
//Tonemaps-end


//Normal.h

	min16float3 calculateSurfaceNormal(min16float3 chunkedPos){
		//use opengl es build in function to fix precision issue.
		//also use chunkedPos here because it is much more exact
		min16float3 normal = normalize(cross(ddx(chunkedPos), ddy(chunkedPos)));
		return normal;
	}

//Normal.h end



//Ambient.h:
			//diffuse
			//screenPosition
			//shadow from 0.0(no shadow) - 1.0(full shadow)
			//light from 0.0(no light) - 1.0(light)
			//nightDay from 1.0(night) - 0.0(day)
			//rain 0.0(no rain) - 1.0(rain)
			//darkness 0.0(no darkness) - 1.0(darkness)
			//N normal vector
			float4 Ambient(float4 diffuse, float3 screenPosition, float shadow, float light, float nightDay, float rain, float darkness, float3 N){

				float3 shadowColor = lerp(SHADOW_COLOR_NIGHT, SHADOW_COLOR_DAY, nightDay);
				shadowColor = lerp(shadowColor, SHADOW_COLOR_CAVE, darkness);

				float3 lightColor = lerp(TORCH_COLOR_DAY, TORCH_COLOR_NIGHT, nightDay);
				lightColor = lerp(lightColor, TORCH_COLOR_SHADOW, min(1.0, shadow * 2.0));
				lightColor = lerp(lightColor, TORCH_COLOR_CAVE, min(1.0, darkness*1.2));


				float lightOffset = lerp(TROCH_LIGHT_OFFSET, TORCH_LIGHT_OFFSET_CAVES, darkness);

				float3 sunColor = lerp(SUN_LIGHT_COLOR_DAY, SUN_LIGHT_COLOR_NIGHT, nightDay);

				#ifdef TORCH_LIGHT
				 light += lightOffset;
				 light = max(0.0, light);
				 light *= light;
				 light *= TORCH_LIGHT_STRENGTH;
				#endif

				#ifdef TONE_MAPPING
					float3 nRGB = diffuse.rgb;
					float r;
					float g;
					float b;
					#ifdef OVER_SATURATED
						#if USE_ALPHA_TEST
							r = diffuse.r;
							g = diffuse.g;
							b = diffuse.b;


							diffuse.r += max(-0.1, r - (g+b));
							diffuse.g += max(-0.1, g - (r+b));
							diffuse.b += max(-0.1, b - (g+r));
						#else
							r = diffuse.r;
							g = diffuse.g;
							b = diffuse.b;


							diffuse.r += max(-0.1, r - (g+b));
							diffuse.g += max(-0.1, g - (r+b));
							diffuse.b += max(-0.1, b - (g+r));

							diffuse.rgb = clamp(diffuse.rgb, float3(0.0, 0.0, 0.0), float3(1.0, 1.0, 1.0));

							diffuse.rgb = unchartedTonemapTwo(diffuse.rgb);
							diffuse.rgb = acesFilm(acesFilm(diffuse.rgb));
						#endif

						#ifdef NIGHT_TONE_MAPPING
							//To get a grey effect, all values (r, g, b) should be almost the same.
							//I will mix them together to get a effect like this

							r = diffuse.r;
							g = diffuse.g;
							b = diffuse.b;

							float c = lerp(lerp(r, g, 0.5), b, 0.5) * 0.75;

							r = lerp(r, c, 0.99);
							g = lerp(g, c, 0.99);
							b = lerp(b, c, 0.99);

							diffuse.rgb = lerp(diffuse.rgb, float3(r, g, b) * 0.55, nightDay);

						#endif


					#else
						//Not OVER_SATURATED
						r = diffuse.r;
						g = diffuse.g;
						b = diffuse.b;




						diffuse.rgb = clamp(diffuse.rgb, float3(0.0, 0.0, 0.0), float3(1.0, 1.0, 1.0));

						diffuse.rgb = unchartedTonemapTwo(diffuse.rgb);
						diffuse.rgb = acesFilm(diffuse.rgb*1.1);



						#ifdef NIGHT_TONE_MAPPING
							//To get a grey effect, all values (r, g, b) should be almost the same.
							//I will mix them together to get a effect like this

							r = diffuse.r;
							g = diffuse.g;
							b = diffuse.b;

							float c = lerp(lerp(r, g, 0.5), b, 0.5) * 0.75;

							r = lerp(r, c, 0.99);
							g = lerp(g, c, 0.99);
							b = lerp(b, c, 0.99);

							diffuse.rgb = lerp(diffuse.rgb, float3(r, g, b) * 0.75, nightDay);

						#endif
					#endif

					#ifdef CAVE_TONE_MAPPING
						float3 caveDif = nRGB;

						caveDif = unchartedTonemapTwo(caveDif);

						caveDif = lerp(caveDif * 0.15 * CAVE_TONE_MAPPING_COLOR_FACT, nRGB, clamp((1.0 - darkness) + light, CAVE_MAX_DARKNESS, 1.0));

						diffuse.rgb = lerp(diffuse.rgb, caveDif, clamp(darkness*darkness*2.0, 0.0, 1.0));

					#else
						diffuse.rgb = lerp(diffuse.rgb, nRGB, clamp(darkness*darkness*2.0, 0.0, 1.0));
					#endif
				#endif

				#ifdef MORE_REALISTIC_CAVE
					diffuse.rgb = lerp(diffuse.rgb * 0.1, diffuse.rgb, clamp((1.0 - (darkness * 0.75)) + light, 0.0, 1.0));
				#endif

				#ifdef SUN_LIGHT

					diffuse.rgb = lerp(diffuse.rgb * sunColor, diffuse.rgb, shadow);

				#endif

				#ifdef SHADOW
					diffuse.rgb = lerp(diffuse.rgb, diffuse.rgb * shadowColor, clamp(shadow - (light / TORCH_LIGHT_STRENGTH)*0.1, 0.0, 1.0));
				#endif

				#ifdef TORCH_LIGHT
				 diffuse.rgb *= (lightColor * light + float3(1.0, 1.0, 1.0));
				#endif

				#ifdef VIGNETTE
					float4 vignetteColor = lerp(VIGNETTE_COLOR_FACT_DAY, VIGNETTE_COLOR_FACT_NIGHT, nightDay);
					vignetteColor = lerp(vignetteColor, VIGNETTE_COLOR_FACT_CAVE, min(1.0, darkness*1.2));
					vignetteColor *= diffuse;

					float range = length(screenPosition.xy / (screenPosition.z + 0.1)) * 0.85;

					diffuse = lerp(diffuse, vignetteColor, clamp((range - 0.5) * 2.0, 0.0, 1.0));
				#endif

				return diffuse;
			}
//Ambient.h-end




//Fog.h
			//diffuse
			//worldPos, player is always at 0.0
			//nightDay from 1.0(night) - 0.0(day)
			//rain 0.0(no rain) - 1.0(rain)
			//darkness 0.0(no darkness) - 1.0(darkness)
			float4 Fog(float4 diffuse, float3 worldPos, float nightDay, float rain, float darkness){

				#ifdef ESPE_FOG_AND_NO_FKING_MOJANG_FOG_BECAUSE_NOBODY_CARES
					float le = length(worldPos);

					float reFac = 0.8;//1.0;
					float rWidth = lerp(ESPE_FOG_WIDTH, ESPE_FOG_WIDTH_RAIN, max(0.0, rain - (max(0.0, darkness-le*0.01))*5.0));
					#ifdef NETHER_FOG
						if(darkness > 0.99 && FOG_COLOR.r > (FOG_COLOR.b + FOG_COLOR.g)){
							rWidth = ESPE_FOG_WIDTH_NETHER;
							reFac = 0.5;
						}
					#endif
					float rcWidth = min(1.0, rWidth);
					float addWidth = rWidth - rcWidth;
					float width = 1.0 - rcWidth + 0.001;
					float3 espeFogColor = lerp(ESPE_FOG_COLOR_DAY, ESPE_FOG_COLOR_NIGHT, min(1.0, nightDay * 2.0));
					espeFogColor = lerp(espeFogColor, ESPE_FOG_COLOR_RAIN, rain);

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
						espeFogColor = lerp(espeFogColor, FOG_COLOR.rgb, lee);
					}

					diffuse.rgb = lerp(diffuse.rgb, espeFogColor, le);
				#endif

				return diffuse;
			}
//Fog.h-end









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

			float waterTest(float3 P, float frequency, float lacunarity, float octaves, float addition)
      {
				P.y = 1.0;
        float t = 0.0;
        float amplitude = 1.0;
        float amplitudeSum = 0.0;
        for(float k = 0.0; k < octaves; ++k)
        {
          t += min(cnoise(P * frequency)+addition, 1.0) * amplitude;
          amplitudeSum += amplitude;
          amplitude *= 0.5;
          frequency *= lacunarity;
        }
        return t/amplitudeSum;
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
        float a = default3DFbm(pos, CLOUD_FREQUENCY, CLOUD_LACUNARITY, CLOUD_OCTAVES, CLOUD_ADDITION) * 3.0 - default3DFbm(pos + float3(4325.0, 4534.0, 54237.0), CLOUD_FREQUENCY, CLOUD_LACUNARITY*10.0, CLOUD_OCTAVES, CLOUD_ADDITION) * 0.25;
        a /= 3.0;
        a -= 0.1;
        a *= 1.5;

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
				return (UnrealCloudPos / (RENDER_DISTANCE))*0.1;
			}
//sky.h-end



//Water.h:
			float3 getReflection(float3 pos, float3 reflectionVector){
				float3 cloudPos = worldPosToCloudPos(reflectionVector, SKY_HEIGHT);

				float4 sky = calcSky(cloudPos);


				return sky.rgb;
			}

			float4 water(float3 waterColor, float3 pos, float3 camPos, float shadow, float light, float nightDay, float rain, float darkness, float3 N){
				float4 outC = float4(0.0, 0.0, 0.0, 0.0);
				outC.rgb = waterColor;

				/*pos += VIEW_POS.xyz;
				camPos += VIEW_POS.xyz;

				float h0 = waterTest(pos, 1.0 , 0.5 , 10.0, -0.1);

				float3 toCam = normalize(camPos - (pos + float3(0.0, h0, 0.0)));

				for(float dis = 0.0f; dis < 2.0; dis += 0.05)
        {
					float3 np = pos + toCam*dis;
					float h = waterTest(np, 1.0 , 0.5 , 10.0, -0.1);
					if((h+0.1) < np.y && (h-0.1) > np.y){
						pos = np;
						break;
					}
				}




				//Waves (Testing state)
				float h1 = waterTest(pos, 1.0 , 0.5 , 10.0, -0.1);
				float3 A_ = float3(pos.x, pos.y + h1, pos.z);
				float h2 = waterTest(pos + float3(0.01, 0.0, 0.01), 1.0 , 0.5 , 10.0, -0.1);
				float3 B_ = float3(pos.x, pos.y + h2, pos.z) + float3(0.01, 0.0, 0.01);
				float h3 = waterTest(pos + float3(0.01, 0.0, -0.01), 1.0 , 0.5 , 10.0, -0.1);
				float3 C_ = float3(pos.x, pos.y + h3, pos.z) + float3(0.01, 0.0, -0.01);

				float3 RN = normalize(cross(B_ - A_, C_ - A_));
				N = RN;*/


				//Calculating Transparency based on the view angle on the surface
				//The more near the view-vector is to the normal-vector
				//the more transparent is the water
				//
				//camera: O							<-That`s a face!
				//				|	\
				//				|	 \
				//________|___\_________________
				//			more less			transparent

				//Calculate water transparents (think about normalize so we dont need to divide by le)
				float transparency = 1.0;
				float3 viewVec = pos - camPos;
				float3 otherVec = N;
				float le = (length(viewVec) * length(otherVec));
				if(le != 0.0){ transparency = dot(viewVec, otherVec) / le; }

				transparency = (1.0 - abs(transparency)) + 0.3;

				outC.a = min(1.0, transparency);


				//Calculating the Reflection-vector based on the surface-normal-vector
				//Just using a build in function here
				//
				//camera: O					reflection-vector
				//				 \			/
				//					\	  /
				//				   \/
				// The angles on left and right must always be the same
				float3 reflectVector = -normalize(reflect(normalize(camPos - pos), N));


				//float3 reflection = getReflection(pos, reflectVector);


				//Now check if the reflection-vector`s y-coordinate is under 0.0
				//If this is the case we should not reflect anything because it would
				//be under the world (called End in minecraft)
				if(reflectVector.y < 0.0){
					//TODO: think about mixing
				}else{
					//outC.rgb = lerp(outC.rgb, reflection, min(1.0, transparency - 0.2));
				}

				//shadow
				outC = lerp(outC, outC * WATER_COLOR_IN_SHADOW_PER_CENT, shadow);

				//in Caves
				outC.rgb = lerp(outC.rgb, WATER_COLOR_IN_CAVES.rgb, darkness);
				outC.a = lerp(outC.a, outC.a * WATER_COLOR_IN_CAVES.a, darkness);

				//night
				outC = lerp(outC, outC * WATER_COLOR_AT_NIGHT_PER_CENT, max(0.0, (nightDay) - darkness));
				return outC;
			}
//Water.h-end











//functions:
			float getRain(){
			  return min(1.0f, max(0.0f, 1.0f-pow(FOG_CONTROL.y, 5.0f)) * 2.0f);
			}
//functions-end


















ROOT_SIGNATURE
void main(in PS_Input PSInput, out PS_Output PSOutput)
{
#ifdef BYPASS_PIXEL_SHADER
    PSOutput.color = float4(0.0f, 0.0f, 0.0f, 0.0f);
    return;
#else

//Day-Night-Dedection
float4 sky_color = TEXTURE_1.Sample(TextureSampler1, float2(0.0, 1.0));
float4 mTime = float4(sky_color.r, abs(sky_color.r - 0.5), getRain(), min(1.0, (1.0 - sky_color.r)*1.5));	//DAY-NIGHT, SUNSET, RAIN, NIGHT-DAY
float mLight = (max(0.0, mTime.x + PSInput.uv1.x));
float mCave = min(1.0, max(0.0, SHADOW_WIDTH - PSInput.uv1.y) * (1.0 / SHADOW_WIDTH) * 1.5);
mCave = max(0.0, mCave - 0.2) * 1.25;
mCave *= 2.0;
mCave = min(1.0, mCave);
float3 N = calculateSurfaceNormal(PSInput.cPos.xyz);



#if USE_TEXEL_AA
	float4 diffuse = texture2D_AA(TEXTURE_0, TextureSampler0, PSInput.uv0 );
#else
	float4 diffuse = TEXTURE_0.Sample(TextureSampler0, PSInput.uv0);
#endif

#ifdef SEASONS_FAR
	diffuse.a = 1.0f;
#endif

#if USE_ALPHA_TEST
	#ifdef ALPHA_TO_COVERAGE
		#define ALPHA_THRESHOLD 0.05
	#else
		#define ALPHA_THRESHOLD 0.5
	#endif
	if(diffuse.a < ALPHA_THRESHOLD)
		discard;
#endif

#if defined(BLEND)
	diffuse.a *= PSInput.color.a;
#endif

#if !defined(ALWAYS_LIT)
	//mojang torch light
	//diffuse = diffuse * TEXTURE_1.Sample(TextureSampler1, PSInput.uv1);
#endif

#ifndef SEASONS
	#if !USE_ALPHA_TEST && !defined(BLEND)
		diffuse.a = PSInput.color.a;
	#endif

	diffuse.rgb *= PSInput.color.rgb;
#else
	float2 uv = PSInput.color.xy;
	//mojang shadow
	//diffuse.rgb *= lerp(1.0f, TEXTURE_2.Sample(TextureSampler2, uv).rgb*2.0f, PSInput.color.b);
	diffuse.rgb *= PSInput.color.aaa;
	diffuse.a = 1.0f;
#endif






float shadow = 0.0;
#ifdef SHADOW
	if(PSInput.uv1.y <= SHADOW_WIDTH){	//if rendering in shadow

		shadow = 1.0;
		if(PSInput.uv1.y >= SHADOW_WIDTH - FADE_IN_SHADOW_WIDTH){
			#ifdef SHADOW_FADE_IN
				float fadeInE = (PSInput.uv1.y - (SHADOW_WIDTH - FADE_IN_SHADOW_WIDTH)) * (1.0 / FADE_IN_SHADOW_WIDTH);	//calculate fade in
				shadow = lerp(1.0, 0.0, fadeInE);
			#endif
		}
		//shadow = max(0.0, shadow - max(0.0, light.x + E_TORCH_LIGHT_OFFSET));
	}
#endif

diffuse = Ambient(diffuse, PSInput.screenPos /*screenPosition*/, shadow, PSInput.uv1.x/*light*/, mTime.w/*nightDay*/, mTime.z/*rain*/, mCave/*darkness*/, N /*Normal*/);

#ifdef BLEND
	float4 b = TEXTURE_0.Sample(TextureSampler0, PSInput.uv0);
	if(b.r <= 0.01 && b.g <= 0.01 && b.b <= 0.01 && b.a > 0.5 && PSInput.color.a < 0.95){
		//Water stuff
		float3 waterColor = PSInput.color.rgb;
		diffuse = water(waterColor, PSInput.wPos, CAMERA_OFFSET, shadow, PSInput.uv1.x/*light*/, mTime.w/*nightDay*/, mTime.z/*rain*/, mCave/*darkness*/, N /*Normal*/);
	}

#else
	float4 b = TEXTURE_0.Sample(TextureSampler0, PSInput.uv0);
	if(b.r <= 0.01 && b.g <= 0.01 && b.b <= 0.01 && length(PSInput.wPos) > FAR_CHUNKS_DISTANCE * 0.9){
		//Water stuff
		float3 waterColor = PSInput.color.rgb;
		diffuse = water(waterColor, PSInput.wPos, CAMERA_OFFSET, shadow, PSInput.uv1.x/*light*/, mTime.w/*nightDay*/, mTime.z/*rain*/, mCave/*darkness*/, N /*Normal*/);
	}
#endif

diffuse = Fog(diffuse, PSInput.wPos, mTime.w/*nightDay*/, mTime.z/*rain*/, mCave/*darkness*/);




	PSOutput.color = diffuse;

#ifdef VR_MODE
	// On Rift, the transition from 0 brightness to the lowest 8 bit value is abrupt, so clamp to
	// the lowest 8 bit value.
	PSOutput.color = max(PSOutput.color, 1 / 255.0f);
#endif

#endif // BYPASS_PIXEL_SHADER
}
