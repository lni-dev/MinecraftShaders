



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


//diffuse
//screenPosition
//shadow from 0.0(no shadow) - 1.0(full shadow)
//light from 0.0(no light) - 1.0(light)
//nightDay from 1.0(night) - 0.0(day)
//rain 0.0(no rain) - 1.0(rain)
//darkness 0.0(no darkness) - 1.0(darkness)
//N normal vector
vec4 Ambient(vec4 diffuse, vec3 screenPosition, float shadow, float light, float nightDay, float rain, float darkness, vec3 N){

	vec3 shadowColor = mix(SHADOW_COLOR_NIGHT, SHADOW_COLOR_DAY, nightDay);
	shadowColor = mix(shadowColor, SHADOW_COLOR_CAVE, darkness);

	vec3 lightColor = mix(TORCH_COLOR_DAY, TORCH_COLOR_NIGHT, nightDay);
	lightColor = mix(lightColor, TORCH_COLOR_SHADOW, shadow);
	lightColor = mix(lightColor, TORCH_COLOR_CAVE, min(1.0, darkness*1.2));

	float lightOffset = mix(TROCH_LIGHT_OFFSET, TORCH_LIGHT_OFFSET_CAVES, darkness);

	vec3 sunColor = mix(SUN_LIGHT_COLOR_DAY, SUN_LIGHT_COLOR_NIGHT, nightDay);

	#ifdef TORCH_LIGHT
	 light += lightOffset;
	 light = max(0.0, light);
	 light *= light;
	 light *= TORCH_LIGHT_STRENGTH;
	#endif

	#ifdef TONE_MAPPING
		vec3 nRGB = diffuse.rgb;
		float r;
		float g;
		float b;
		#ifdef OVER_SATURATED
			r = diffuse.r;
			g = diffuse.g;
			b = diffuse.b;


			diffuse.r += max(-0.1, r - (g+b));
			diffuse.g += max(-0.1, g - (r+b));
			diffuse.b += max(-0.1, b - (g+r));

			diffuse.rgb = clamp(diffuse.rgb, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));

			diffuse.rgb = unchartedTonemapTwo(diffuse.rgb);
			diffuse.rgb = acesFilm(acesFilm(diffuse.rgb));

			#ifdef NIGHT_TONE_MAPPING
				//To get a grey effect, all values (r, g, b) should be almost the same.
				//I will mix them together to get a effect like this

				r = diffuse.r;
				g = diffuse.g;
				b = diffuse.b;

				float c = mix(mix(r, g, 0.5), b, 0.5) * 0.75;

				r = mix(r, c, 0.99);
				g = mix(g, c, 0.99);
				b = mix(b, c, 0.99);

				diffuse.rgb = mix(diffuse.rgb, vec3(r, g, b) * 0.55, nightDay);

			#endif


		#else
			//Not OVER_SATURATED
			r = diffuse.r;
			g = diffuse.g;
			b = diffuse.b;




			diffuse.rgb = clamp(diffuse.rgb, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));

			diffuse.rgb = unchartedTonemapTwo(diffuse.rgb);
			diffuse.rgb = acesFilm(diffuse.rgb*1.1);



			#ifdef NIGHT_TONE_MAPPING
				//To get a grey effect, all values (r, g, b) should be almost the same.
				//I will mix them together to get a effect like this

				r = diffuse.r;
				g = diffuse.g;
				b = diffuse.b;

				float c = mix(mix(r, g, 0.5), b, 0.5) * 0.75;

				r = mix(r, c, 0.99);
				g = mix(g, c, 0.99);
				b = mix(b, c, 0.99);

				diffuse.rgb = mix(diffuse.rgb, vec3(r, g, b) * 0.75, nightDay);

			#endif
		#endif

		#ifdef CAVE_TONE_MAPPING
			vec3 caveDif = nRGB;

			caveDif = unchartedTonemapTwo(caveDif);

			caveDif = mix(caveDif * 0.15, nRGB, clamp((1.0 - darkness) + light, CAVE_MAX_DARKNESS, 1.0));

			diffuse.rgb = mix(diffuse.rgb, caveDif, clamp(darkness*darkness*2.0, 0.0, 1.0));

		#else
			diffuse.rgb = mix(diffuse.rgb, nRGB, clamp(darkness*darkness*2.0, 0.0, 1.0));
		#endif
	#endif

	#ifdef MORE_REALISTIC_CAVE
		diffuse.rgb = mix(diffuse.rgb * 0.1, diffuse.rgb, clamp((1.0 - (darkness * 0.75)) + light, 0.0, 1.0));
	#endif

	#ifdef SUN_LIGHT

		diffuse.rgb = mix(diffuse.rgb * sunColor, diffuse.rgb, shadow);

	#endif

	#ifdef SHADOW
		diffuse.rgb = mix(diffuse.rgb, diffuse.rgb * shadowColor, clamp(shadow - (light / TORCH_LIGHT_STRENGTH)*0.1, 0.0, 1.0));
	#endif

	#ifdef TORCH_LIGHT
		diffuse.rgb *= (lightColor * light + vec3(1.0));
	#endif

	#ifdef VIGNETTE
		vec4 vignetteColor = mix(VIGNETTE_COLOR_FACT_DAY, VIGNETTE_COLOR_FACT_NIGHT, nightDay);
		vignetteColor = mix(vignetteColor, VIGNETTE_COLOR_FACT_CAVE, min(1.0, darkness*1.2));
		vignetteColor *= diffuse;

		float range = length(screenPosition.xy / (screenPosition.z + 0.1)) * 0.85;

		diffuse = mix(diffuse, vignetteColor, clamp((range - 0.5) * 2.0, 0.0, 1.0));
	#endif

	return diffuse;
}
