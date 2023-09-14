

/*
* Created by Linus_Dev (Twitter: https://twitter.com/Linus_Dev)
*
* Do only edit and share this if you have permission by the Owner Linus_Dev
* Don`t upload any of the content and don`t provide anything of it on any website
* Do only share the orginal Download link and don`t create your own one.
* Do not copy or partly copy the code
*
* Of course you can edit it for private use.
*
* last edited on 27.12.2017
*/

vec3 addLight(POS3 pos, float light, float height, vec3 colorC){
  //vec3 m = max(vec3(0.75), min(vec3(1.0), (vec3(1.0) - colorC.rgb) + vec3(0.75)));
	return colorC * (max(1.0, height - 1.0)*2.0* max(0.0, light-0.5) + 1.0);
}

vec3 getRelativeBrightness(vec3 diffuse){
	float r = max(0.0, diffuse.r - (diffuse.g + diffuse.b));
	float g = max(0.0, diffuse.g - (diffuse.r + diffuse.b));
	float b = max(0.0, diffuse.b - (diffuse.r + diffuse.g));
	return pow(vec3(r, g, b)*5.0, vec3(2.0))*5.0;
}

float getColorDifference(vec3 c1, vec3 c2){
	vec3 d = abs(c1 - c2);	//think about using length function
	return (d.r + d.g*0.0 + d.b);//1.0;
}

vec3 toneMap(vec3 diffuse){
	vec3 invert = vec3(1.0) - diffuse;
	diffuse = mix(diffuse, diffuse*1.2, invert);
	return diffuse;
}

vec4 EnergyColorMap(vec4 c){
	float R,G,B;

	R = c.r;
	G = c.g;
	B = c.b;

	R = mix(R,R * 1.5, max(0.0, R - (G + B)));
	G = mix(G,G * 1.5, max(0.0, G - (R + B)));
	B = mix(B,B * 1.5, max(0.0, B - (G + R)));

	return vec4(R, G, B, c.a);
}

vec3 EnergyColorMap(vec3 c){
	float R,G,B;

	R = c.r;
	G = c.g;
	B = c.b;

	R = mix(R,R * 1.5, max(0.0, R - (G + B)));
	G = mix(G,G * 1.5, max(0.0, G - (R + B)));
	B = mix(B,B * 1.5, max(0.0, B - (G + R)));

	return vec3(R, G, B);
}

float colorTA(POS3 pos){
	pos.x += pos.y*0.5;
	pos.z += pos.y*0.5;

	vec2 u1 = pos.xz*0.5 - floor(pos.xz*0.5);
	vec2 u2 = pos.xz*5.0 - floor(pos.xz*5.0);
	vec2 u3 = pos.xz*0.2 - floor(pos.xz*0.2);

	vec4 n1 = texture2D( TEXTURE_3, u1);
	vec4 n2 = texture2D( TEXTURE_3, u2);
	vec4 n3 = texture2D( TEXTURE_3, u3);
	n1 += n2 - n3;

	float a = 0.6 + (n1.r-n1.g+n1.b)*0.8;

	return a;
}

vec4 colorT(vec2 mUv, POS3 pos, vec4 diffuse, vec3 N){

	vec3 AN = abs(N);

	if(AN.z > AN.x+AN.y){
		pos.z = pos.y;
	}else if(AN.x > AN.z+AN.y){
		pos.x = pos.y;
	}

	vec2 u1 = pos.xz*0.5 - floor(pos.xz*0.5);
	vec2 u2 = pos.xz*5.0 - floor(pos.xz*5.0);
	vec2 u3 = pos.xz*0.2 - floor(pos.xz*0.2);

	vec4 n1 = texture2D( TEXTURE_3, u1);
	vec4 n2 = texture2D( TEXTURE_3, u2);
	vec4 n3 = texture2D( TEXTURE_3, u3);
	vec4 cur = diffuse;

	n1 += n2 - n3;


	cur.rgb *= 0.6 + (n1.r-n1.g+n1.b)*0.8;
	cur.a = 0.6 + (n1.r-n1.g+n1.b)*0.8;

	return cur;
}



vec4 doColor(POS3 pos, POS3 CamPos, POS3 screenPos, vec2 uv, vec2 light, vec4 diffuse, bool water, vec3 N){
	diffuse.rgb *= color.rgb;	//to get the Real block Color

	//Values

	/*
	* Shadow value:
	*
	* range: 0.0 - 1.0
	* type : smooth
	*
	* 0.0 means there is no shadow
	* 1.0 means there is shadow
	*/
	float shadow = 0.0;

	/*
	* Fog value:
	*	range: vec4(0.0 - 1.0)
	*	type : smooth
	*
	*
	* fog.rgb : fog Color
	** in the red, green, blue format
	** (rgb)
	*
	* fog.a   : fog Strength
	** 0.0 means no fog
	** 1.0 means fog
	*
	* It is optional set to an optional
	* Color defined above or set to the
	* Minecraft standard fog Color.
	* the fog Strength is calculated
	* later
	*
	*/
	vec4 fog = vec4(E_FOG_COLOR, 0.0);
	#ifdef USE_MOJANG_FOG_COLOR
		fog = FOG_COLOR;
	#endif

	/*
	* Underwater:
	*
	* type : Boolean
	*
	* false: not underwater
	* true : underwater
	*
	* based on FOG_CONTROL.x. If
	* FOG_CONTROL.x is smaller than
	* 0.01 the player is underwater
	*/
	bool underwater = false;
	if(FOG_CONTROL.x < 0.01){
		underwater = true;
	}





	if(!water){	//This doesn`t do water rendering

		/*
		* Bump effects:
		*
		* mostly generated and not related
		* to the actual texture.
		*
		* apply now.
		*/
		#ifdef FAKE_BUMP_EFFECT
			if(color.g <= color.r){	//No grass
				vec4 dxm = texture2D( TEXTURE_0, vec2(uv.x-0.1 * FACT, uv.y) ) * color;
				vec4 dym = texture2D( TEXTURE_0, vec2(uv.x, uv.y-0.2 * FACT) ) * color;

				vec4 d5 = mix(dxm, dym, 0.5);
				diffuse.rgb = mix(diffuse.rgb, vec3(diffuse.rgb * 0.5),max(0.0, min(1.0, getColorDifference(diffuse.rgb, d5.rgb)*3.0)) );	//fake bump effect
			}
		#endif

		#if defined(BUMP_WITH_NOISE) && !defined(ALPHA_TEST)
			float le = length(pos);
			if(le <= 20.0){	//It is really laggy, so don`t do it over the hole world
				vec3 ndif = diffuse.rgb*1.1;
        ndif = EnergyColorMap(ndif);
				float mValue = max(0.0, le-18.0)*0.5;
        diffuse.rgb *= 0.8;

   vec4 bump = colorT(uv,(pos+VIEW_POS.xyz), diffuse, N);
				diffuse.rgb = bump.rgb;
				diffuse.rgb = addLight(pos, light.x, bump.a, diffuse.rgb);
				diffuse.rgb = mix(diffuse.rgb, ndif, mValue);
			}else{
				diffuse.rgb *= 1.1;
			}
		#endif

		/*
		*Shadows:
		*
		* they are just based on the uv1.y
		* given by minecraft and only work
		* directly under Blocks.
		*
		* applied later.
		*/
		#ifdef E_SHADOW
			if(light.y <= E_SHADOW_WIDTH){	//if rendering in shadow

				shadow = 1.0;

				if(light.y >= E_SHADOW_WIDTH - FADE_IN_E_SHADOW_WIDTH.x){
					#ifdef E_SHADOW_FADE_IN
						float fadeInE = (light.y - (E_SHADOW_WIDTH - FADE_IN_E_SHADOW_WIDTH.x)) * FADE_IN_E_SHADOW_WIDTH.y;	//calculate fade in
						shadow = mix(1.0, 0.0, fadeInE);
					#endif
				}
				shadow = max(0.0, shadow - max(0.0, light.x + E_TORCH_LIGHT_OFFSET));
			}
		#endif

		/*
		* Torch light:
		*
		* It calculates the light given by
		* any light source using the uv1.x
		* value given by minecraft. Since
		* there is no light-Direction or
		* position of the light-Source
		* given it is impossible to
		* calculate real light and light
		* reflection.
		*
		*	apply now.
		*/
		#ifdef E_TORCH_LIGHT
			#ifdef USE_TORCH_LIGHT_OF_CHRISMAS_SHADERS
				diffuse.rgb = mix(diffuse.rgb, vec3(0.7, 0.3, 0.2), max(0.0, light.x-0.6)*(abs(sin(TIME*5.0-cos(TIME*2.0)+sin(TIME)))*0.5+1.5));
			#else
				vec3 experimental = vec3(1.0);

				#ifdef EXPERIMENTAL_LIGHT
					experimental =  diffuse.rgb * (vec3(1.0) - diffuse.rgb)*2.7;
				#endif

				diffuse.rgb += max(vec3(0.0), E_TORCH_LIGHT_COLOR * (light.x + E_TORCH_LIGHT_OFFSET)) * experimental;
			#endif
		#endif

		/*
		* Sun light
		*
		* Not finished yet.
		*/
		#ifdef SUN_LIGHT
			/*float isl_f= 1.0-(diffuse.r+diffuse.g+diffuse.b)/3.0;
			vec4 isl_v =vec4(1.0+isl_f,0.9+isl_f,0.8+isl_f,1.0);

			isl_v.rgb *= 1.0-shadow*1.1;
			isl_v.rgb = max(vec3(1.0),isl_v.rgb);

			diffuse.rgb *= isl_v.rgb;*/
			diffuse.rgb *= 0.9;
		#endif

		/*
		*	Night Color:
		*
		*	this makes the night dark,
		* currently based on the fog given
		* by minecraft and this sometimes
		* looks a bit ugly. I should think
		* about another solution here.
		*
		*	apply now.
		*/
		#ifdef FOG_BASED_NIGHT_LIGHT
			diffuse.rgb *= max(vec3(0.3+max(0.0, light.x-0.5)*1.2), min(vec3(0.5), FOG_COLOR.rgb*2.0) * 2.0);
		#endif

		/*
		*	Color Map:
		*
		*	this just takes the given color
		* saturates it a bit more, so it
		* looks more natural.
		*
		* applied now.
		*/
		#ifdef ENERGY_COLOR_MAP
			diffuse = EnergyColorMap(diffuse);
		#endif

		//Shadows
		#ifdef E_SHADOW
      #ifndef ALPHA_TEST
        shadow += max(0.0, (1.0 - max(0.0, pow(min(1.0, color.a + 0.3 + (1.0 - light.y)), 7.0)))*2.0 - light.x * 2.0);
        shadow = min(1.0, shadow);
      #endif
			diffuse.rgb = mix(diffuse.rgb, (diffuse.rgb) * max(0.3, min(0.5, light.y)), shadow);
		#endif

		/*
		*	Bloom:
		*
		* this is actually no real Bloom.
		* It is just based on the Screen,
		* this means it makes it a bit
		* darker at the side of the
		* screen.
		*
		* apply now.
		*/
		#ifdef SCREEN_BASED_BLOOM
			diffuse.rgb = mix(diffuse.rgb, diffuse.rgb*0.2, max(0.0, length(screenPos.xy)-0.3));
		#endif

		/*
		*	Fog:
		*
		*	I don't use "#ifdef FOG" because
		* my fog gets sometimes too near to
		* the player, so a cutted line
		* would appear. FOG is only
		* defined in the far chunks and I
		* don't recommend to use it.
		* My Fog is based on the distance
		* from the player divided by the
		* RENDER_DISTANCE so it is
		* relativly the same with every
		* render distance. The Fog has a
		* specfic color defined above and
		* is optional (recommended) mixed
		* with the standard minecraft fog
		* so it doesn't looks ugly.
		*
		* apply now.
		*/
		#ifdef E_FOG
			float len = length(pos.xz);

			if(underwater){
				#ifdef E_UNDERWATER_FOG
					len *= 0.1;
					len = min(1.0, len);
					#ifdef MIX_E_FOG_WITH_MOJANG_FOG
						fog.rgb = mix(E_UNDERWATER_FOG_COLOR, fog.rgb, len);
					#endif

					diffuse.rgb = mix(diffuse.rgb, fog.rgb, len);
				#endif
			}else{
				len *= 1.1;
				len /= RENDER_DISTANCE;
				len = min(1.0, len);

				#ifdef MIX_E_FOG_WITH_MOJANG_FOG
					fog.rgb = mix(E_FOG_COLOR, fog.rgb, len*len);
				#endif

				diffuse.rgb = mix(diffuse.rgb, fog.rgb, max(0.0, len));
				diffuse.a = max(min(1.0,fog.a * len), diffuse.a);
			}
		#endif


	}
	#ifdef ALPHA_TEST
	#endif

	diffuse.rgb = toneMap(diffuse.rgb);

	return diffuse;
}
