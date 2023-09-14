




//diffuse
//shadow from 0.0(no shadow) - 1.0(full shadow)
//light from 0.0(no light) - 1.0(light)
//nightDay from 1.0(night) - 0.0(day)
//rain 0.0(no rain) - 1.0(rain)
//darkness 0.0(no darkness) - 1.0(darkness)
//N normal vector
vec4 Ambient(vec4 diffuse, float shadow, float light, float nightDay, float rain, float darkness, vec3 N){
	
	vec3 shadowColor = mix(SHADOW_COLOR_NIGHT, SHADOW_COLOR_DAY, nightDay);
	shadowColor = mix(shadowColor, SHADOW_COLOR_CAVE, darkness);
	
	vec3 lightColor = mix(TORCH_COLOR_DAY, TORCH_COLOR_NIGHT, nightDay);
	lightColor = mix(lightColor, TORCH_COLOR_CAVE, min(1.0, darkness*1.2));
	
	float lightOffset = mix(TROCH_LIGHT_OFFSET, TORCH_LIGHT_OFFSET_CAVES, darkness);
	
	vec3 sunColor = mix(SUN_LIGHT_COLOR_DAY, SUN_LIGHT_COLOR_NIGHT, nightDay);
	
	#ifdef TONE_MAPPING
		float r = diffuse.r;
		float g = diffuse.g;
		float b = diffuse.b;
		
		
		diffuse.r += max(-0.1, r - (g+b));
		diffuse.g += max(-0.1, g - (r+b));
		diffuse.b += max(-0.1, b - (g+r));
	#endif
	
	#ifdef SUN_LIGHT
		
		diffuse.rgb = mix(diffuse.rgb * sunColor, diffuse.rgb, shadow);
		
	#endif
	
	#ifdef SHADOW
		diffuse.rgb = mix(diffuse.rgb, diffuse.rgb * shadowColor, shadow);
	#endif
	
	#ifdef TORCH_LIGHT
	 light += lightOffset;
	 light = max(0.0, light);
	 light *= light;
	 light *= TORCH_LIGHT_STRENGTH;
		diffuse.rgb *= (lightColor * light + vec3(1.0));
	#endif
	
	
	
	return diffuse;
}
