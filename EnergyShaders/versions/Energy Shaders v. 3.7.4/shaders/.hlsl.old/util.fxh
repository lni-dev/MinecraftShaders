
#if !defined(TEXEL_AA) || !defined(TEXEL_AA_FEATURE) || (VERSION < 0xa000 /*D3D_FEATURE_LEVEL_10_0*/)
#define USE_TEXEL_AA 0
#else
#define USE_TEXEL_AA 1
#endif

#ifdef ALPHA_TEST
#define USE_ALPHA_TEST 1
#else
#define USE_ALPHA_TEST 0
#endif

#if USE_TEXEL_AA

static const float TEXEL_AA_LOD_CONSERVATIVE_ALPHA = -1.0f;
static const float TEXEL_AA_LOD_RELAXED_ALPHA = 2.0f;

float4 texture2D_AA(in Texture2D source, in sampler bilinearSampler, in float2 originalUV) {

	const float2 dUV_dX = ddx(originalUV) * TEXTURE_DIMENSIONS.xy;
	const float2 dUV_dY = ddy(originalUV) * TEXTURE_DIMENSIONS.xy;

	const float2 delU = float2(dUV_dX.x, dUV_dY.x);
	const float2 delV = float2(dUV_dX.y, dUV_dY.y);
	const float2 adjustmentScalar = max(1.0f / float2(length(delU), length(delV)), 1.0f);

	const float2 fractionalTexel = frac(originalUV * TEXTURE_DIMENSIONS.xy);
	const float2 adjustedFractionalTexel = clamp(fractionalTexel * adjustmentScalar, 0.0f, 0.5f) + clamp(fractionalTexel * adjustmentScalar - (adjustmentScalar - 0.5f), 0.0f, 0.5f);

	const float lod = log2(sqrt(max(dot(dUV_dX, dUV_dX), dot(dUV_dY, dUV_dY))) * 2.0f);
	const float samplingMode = smoothstep(TEXEL_AA_LOD_RELAXED_ALPHA, TEXEL_AA_LOD_CONSERVATIVE_ALPHA, lod);

	const float2 adjustedUV = (adjustedFractionalTexel + floor(originalUV * TEXTURE_DIMENSIONS.xy)) / TEXTURE_DIMENSIONS.xy;
	const float4 blendedSample = source.Sample(bilinearSampler, lerp(originalUV, adjustedUV, samplingMode));

	#if USE_ALPHA_TEST
		return float4(blendedSample.rgb, lerp(blendedSample.a, smoothstep(1.0f/2.0f, 1.0f, blendedSample.a), samplingMode));
	#else
		return blendedSample;
	#endif
}

#endif // USE_TEXEL_AA

float MakeDepthLinear(float z, float n, float f, bool scaleZ)
{
	//Remaps z from [0, 1] to [-1, 1].
	if (scaleZ) {
		z = 2.f * z - 1.f;
	}
	return (2.f * n) / (f + n - z * (f - n));
}

//compatibility.h

#define vec2 float2 //vec2
#define vec3 float3 //vec3
#define hvec3 float3 //highp vec3
#define hvec2 float2 //highp vec2
#define vec4 float4 //vec4
#define mix lerp //mix

#define VEC2(x) float2(##x##, ##x##) //vec2
#define VEC3(x) float3(##x##, ##x##, ##x##) //vec3
#define VEC4(x) float4(##x##, ##x##, ##x##, ##x##) //vec4



//compatibility.h end

//Settings.h:
			#define SHADOW
			#define SHADOW_WIDTH 0.87
			#define SHADOW_COLOR_DAY vec3(0.5, 0.5, 0.65)
			#define SHADOW_COLOR_NIGHT vec3(0.5, 0.5, 0.5)
			#define SHADOW_COLOR_CAVE vec3(0.45, 0.45, 0.65)
			#define SHADOW_FADE_IN
			#define FADE_IN_SHADOW_WIDTH 0.025
			#define SHADOW_BLOCK_SIDE

			#define TONE_MAPPING

			//A saturation of 1.0 has no impact
			//A saturation of 0.0 is greyScale
			//A saturation of 2.0 would double the saturation
			//too hight values may cause bugs
			#define SATURATION 1.2
			#define TORCH_LIGHT
			#define TORCH_LIGHT_STRENGTH 15.0
			#define TROCH_LIGHT_OFFSET -0.23
			#define TORCH_LIGHT_OFFSET_CAVES -0.1
			#define TORCH_COLOR_DAY vec3(0.15, 0.05, 0.01)
			#define TORCH_COLOR_NIGHT vec3(0.664, 0.3, 0.1)
			#define TORCH_COLOR_CAVE vec3(0.734, 0.235, 0.05)
			#define TORCH_COLOR_NETHER vec3(0.434, 0.31, 0.17)
			#define TORCH_COLOR_END vec3(0.32, 0.095, 0.2)
			#define SUN_LIGHT
			#define SUN_LIGHT_COLOR_DAY vec3(1.2, 1.3, 1.25)
			#define SUN_LIGHT_COLOR_NIGHT vec3(0.7, 0.7, 0.9)

			#define ESPE_FOG_AND_NO_FKING_MOJANG_FOG_BECAUSE_NOBODY_CARES
			#define ESPE_FOG_COLOR_DAY vec3(0.2, 0.45, 0.63)
			#define ESPE_FOG_COLOR_NIGHT vec3(0.01, 0.05, 0.1)
			#define ESPE_FOG_COLOR_RAIN vec3(0.4, 0.45, 0.5)
			#define ESPE_FOG_WIDTH 0.8
			#define ESPE_FOG_WIDTH_RAIN 1.4

			#define NIGHT_BRIGHTNESS_FACTOR 0.69

			//will make the night appear colorless
			//#define NIGHT_TONE_MAPPING


			#define ESPE_FOG_UNDERWATER_WIDTH 1.7
			#define RENDER_DISTANCE_UNDER_WATER 64.0
			#define RENDER_DISTANCE_NETHER 8.0*16.0
			#define ESPE_FOG_UNDERWATER_COLOR vec3(0.1, 0.4, 0.6)

			#define NETHER_FOG
			#define ESPE_FOG_WIDTH_NETHER 1.05
			#define END_FOG
			#define ESPE_FOG_WIDTH_END 1.07
			#define ESPE_FOG_COLOR_END vec3(0.073, 0.015, 0.085)

			#define CAMERA_OFFSET vec3(0.0, 0.0, 0.0)
			#define SKY_COLOR vec4(0.1, 0.35, 0.7, 1.0)
      #define MIX_SKY_AND_FOG

			//CLOUD stuff
      #define SKY_HEIGHT 270.0
      #define CLOUD_OCTAVES 50.0
      #define CLOUD_ADDITION 0.15
      #define CLOUD_LACUNARITY 1.6
      #define CLOUD_FREQUENCY 1.0

			#define CAVE_TONE_MAPPING
			#define CAVE_TONE_MAPPING_COLOR_FACT vec3(0.35, 0.35, 1.75)
			#define CAVE_MAX_DARKNESS 0.3
			//#define MORE_REALISTIC_CAVE

			#define VIGNETTE
			#define VIGNETTE_COLOR_FACT_DAY vec4(0.56, 0.56, 0.56, 1.0)
			#define VIGNETTE_COLOR_FACT_NIGHT vec4(0.46, 0.46, 0.46, 1.0)
			#define VIGNETTE_COLOR_FACT_CAVE vec4(0.26, 0.26, 0.39, 1.0)

			#define WATER_COLOR_IN_SHADOW_PER_CENT vec4(0.55, 0.55, 0.65, 0.75)
			#define WATER_COLOR_IN_CAVES vec4(0.05, 0.07, 0.25, 0.75)
			#define WATER_COLOR_AT_NIGHT_PER_CENT vec4(0.25, 0.25, 0.35, 0.65)
			#define MIN_WATER_TRANSPARENCY 0.28

			//#define REALISTIC_NETHER
			#define REALISTIC_NETHER_TORCH_LIGHT_COLOR vec3(0.734, 0.235, 0.05)

			//#define DEBUG_SHOW_TEXTURE_1
//Settings.h-end


//functions:
			float getRain(){
			  return min(1.0, max(0.0, 1.0-pow(FOG_CONTROL.y, 5.0)) * 2.0);
			}

			//overworld 0-1
			//nether 2.0
			//end 3.0
			float dimension(in Texture2D source, in sampler bilinearSampler, float nightDay){
				vec3 topLeftLight = source.Sample(bilinearSampler, vec2(0.0, 0.0));
				vec3 bottomLeftLight = source.Sample(bilinearSampler, vec2(0.0, 1.0));

				#ifdef UNDER_WATER
					//End's and Nether's TopLeftCorner and BottomLeftCorner are equal, but the Nether has more Red
					//Water cannot be placed in the Nether
					if(topLeftLight.r == bottomLeftLight.r){
						return 3.0;
					}
					return nightDay;
				#else

					if(topLeftLight.r == bottomLeftLight.r && topLeftLight.g == bottomLeftLight.g){

						return 3.0; //End
					}

					if(pow(topLeftLight.r, 1.0) > 0.3){
						return 2.0; //Nether
					}


					return nightDay;
				#endif



			}
//functions-end

//Tonemaps and more:

			/**
			* Adjusts the saturation of a color.
			*
			* @name czm_saturation
			* @glslFunction
			*
			* @param {vec3} rgb The color.
			* @param {float} adjustment The amount to adjust the saturation of the color.
			*
			* @returns {float} The color with the saturation adjusted.
			*
			* @example
			* vec3 greyScale = czm_saturation(color, 0.0);
			* vec3 doubleSaturation = czm_saturation(color, 2.0);
			* source: https://github.com/AnalyticalGraphicsInc
			*/
			vec3 saturation(vec3 rgb, float adjustment){
				// Algorithm from Chapter 16 of OpenGL Shading Language
				const vec3 W = vec3(0.2125, 0.7154, 0.0721);
				vec3 intensity = VEC3(dot(rgb, W));
				return clamp(mix(intensity, rgb, adjustment), VEC3(0.0), VEC3(1.0));
			}

			vec3 burgess(vec3 col){
				col = col - 0.004;
				vec3 a = VEC3(8.7);
				vec3 b = VEC3(0.05);
				vec3 c = VEC3(6.1);
				vec3 d = VEC3(4.0);
				vec3 e = VEC3(0.4);
				vec3 f = VEC3(0.0);

				return (col * (a * col + b)) / (col * (c * col + d) + e) + f;
			}

			vec3 gamaCorection(vec3 col){
				return pow(col, VEC3(1.0 / 2.2));
			}

			//credits on https://github.com/armory3d/armory/blob/master/Shaders/std/tonemap.glsl
			vec3 unchartedTonemap(vec3 x){
				vec3 A = vec3(0.15, 0.15, 0.15);
				vec3 B = vec3(0.50, 0.50, 0.50);
				vec3 C = vec3(0.10, 0.10, 0.10);
				vec3 D = vec3(0.20, 0.20, 0.20);
				vec3 E = vec3(0.02, 0.02, 0.02);
				vec3 F = vec3(0.30, 0.30, 0.30);
				return ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F;
			}

			vec3 unchartedTonemapTwo(vec3 c){
				float W = 11.2;
				vec3 exposureBias = vec3(2.0, 2.0, 2.0);
				vec3 curr = unchartedTonemap(exposureBias * c);
				vec3 whiteScale = vec3(1.0, 1.0, 1.0) / unchartedTonemap(vec3(W, W, W));
				return curr * whiteScale;
			}

			// Based on Filmic Tonemapping Operators http://filmicgames.com/archives/75
			vec3 tonemapFilmic(vec3 ccolor) {
				vec3 x = max(vec3(0.0, 0.0, 0.0), ccolor - 0.004);
				return (x * (6.2 * x + 0.5)) / (x * (6.2 * x + 1.7) + 0.06);
			}

			// https://knarkowicz.wordpress.com/2016/01/06/aces-filmic-tone-mapping-curve/
			vec3 acesFilm(vec3 x) {
			    const float a = 2.51;
			    const float b = 0.03;
			    const float c = 2.43;
			    const float d = 0.59;
			    const float e = 0.14;
			    return clamp((x * (a * x + b)) / (x * (c * x + d ) + e), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
			}

			vec3 tonemapReinhard(vec3 ccolor) {
				return ccolor / (ccolor + vec3(1.0, 1.0, 1.0));
			}
//Tonemaps-end


//Normal.h

	hvec3 calculateSurfaceNormal(hvec3 chunkedPos){
		//use opengl es build in function to fix precision issue.
		hvec3 normal = -normalize(cross(ddx(chunkedPos), ddy(chunkedPos)));
		return normal;
	}

//Normal.h end



//Ambient.h:
			//diffuse
			//screenPosition
			//shadow from 0.0(no shadow) - 1.0(full shadow)
			//light from 0.0(no light) - 1.0(light)
			//nightDay from 1.0(night) - 0.0(day) and dimension: 2-Nether, 3-End
			//rain 0.0(no rain) - 1.0(rain)
			//darkness 0.0(no darkness) - 1.0(darkness)
			//N normal vector
			vec4 Ambient(in Texture2D source, in sampler bilinearSampler,
				vec4 diffuse, vec3 screenPosition, float shadow, float light, float nightDay, bool nether, bool end, float rain, float darkness, vec3 N){

				//Calculations
				#ifdef SHADOW_BLOCK_SIDE

					shadow = clamp(shadow + abs(N.z) - min(N.y, 0.0), 0.0, 1.0);
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
						//TODO: add the factor to the settings
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
//Ambient.h-end




//Fog.h
			//diffuse
			//worldPos, player is always at 0.0
			//nightDay from 1.0(night) - 0.0(day)
			//rain 0.0(no rain) - 1.0(rain)
			//darkness 0.0(no darkness) - 1.0(darkness)
			vec4 Fog(vec4 diffuse, vec3 worldPos, float nightDay, bool nether, bool end, float rain, float darkness){

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
							espeFogColor = FOG_COLOR.rgb;
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
						if(nether){
							le = max(0.0, ((le/(RENDER_DISTANCE_NETHER*reFac)) - width)) + addWidth;
							le = min(1.0, le);
						}else{
							le = max(0.0, ((le/(RENDER_DISTANCE*reFac)) - width)) + addWidth;
							le = min(1.0, le);
						}

						if(end){
							le = smoothstep(0.0, 1.0, le);
						}
					#endif


					if(le > 0.9 && !nether){
						float lee = (le - 0.9) * 10.0;
						espeFogColor = mix(espeFogColor, FOG_COLOR.rgb, lee);
					}

					diffuse.rgb = mix(diffuse.rgb, espeFogColor, le);
				#endif

				return diffuse;
			}
//Fog.h-end

//water.h
			vec4 water(vec3 waterColor, vec3 pos, vec3 camPos, float shadow, float light, float nightDay, float rain, float darkness, vec3 N){
				vec4 outC = vec4(0.0, 0.0, 0.0, 0.0);
				outC.rgb = waterColor;

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
				vec3 viewVec = pos - camPos;
				vec3 otherVec = N;
				float le = (length(viewVec) * length(otherVec));
				if(le != 0.0){ transparency = dot(viewVec, otherVec) / le; }

				transparency = (1.0 - abs(transparency)) + 0.3;

				outC.a = clamp(transparency-0.3, MIN_WATER_TRANSPARENCY, 1.0);


				//Calculating the Reflection-vector based on the surface-normal-vector
				//Just using a build in function here
				//
				//camera: O					reflection-vector
				//				 \			/
				//					\	  /
				//				   \/
				// The angles on left and right must always be the same
				vec3 reflectVector = -normalize(reflect(normalize(camPos - pos), N));


				//vec3 reflection = getReflection(pos, reflectVector);


				//Now check if the reflection-vector`s y-coordinate is under 0.0
				//If this is the case we should not reflect anything because it would
				//be under the world (called End in minecraft)
				if(reflectVector.y < 0.0){
					//TODO: think about mixing
				}else{
					//outC.rgb = mix(outC.rgb, reflection, min(1.0, transparency - 0.2));
				}

				//shadow
				outC = mix(outC, outC * WATER_COLOR_IN_SHADOW_PER_CENT, shadow);

				//in Caves
				outC.rgb = mix(outC.rgb, WATER_COLOR_IN_CAVES.rgb, darkness);
				outC.a = mix(outC.a, outC.a * WATER_COLOR_IN_CAVES.a, darkness);

				//night
				outC = mix(outC, outC * WATER_COLOR_AT_NIGHT_PER_CENT, max(0.0, (nightDay) - darkness));
				return outC;
			}
//Water.h-end
