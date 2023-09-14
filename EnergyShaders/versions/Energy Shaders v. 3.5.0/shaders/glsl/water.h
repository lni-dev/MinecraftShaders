

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

float waves(POS3 pos){
	float time = 1.0;//TIME;//*0.5 - floor(TIME*0.5);
	vec2 offset1 = vec2(0.8, 0.4) * time * 0.1;
	vec2 offset2 = vec2(0.6, 1.1) * time * 0.4;

	vec2	mUv = (pos.xz + offset1)*0.1 - floor((pos.xz + offset1)*0.1);
	vec2	mUv2 = (pos.xz + offset2)*0.3 - floor((pos.xz + offset2)*0.3);

	vec4 ddd = texture2D( TEXTURE_3, mUv);
	vec4 dd2 = texture2D( TEXTURE_3, mUv2);

	//float NWaves = cos(pos.x + time) * cos(pos.z + time)-0.5;


	return (ddd.r + dd2.r - ddd.g - dd2.g + ddd.b + dd2.b)*0.1;
  return 0.5;
}

float waves(POS3 pos, float scale){
	float time = 1.0;//TIME;//*0.5 - floor(TIME*0.5);
	vec2 offset1 = vec2(0.8, 0.4) * time * 0.1;
	vec2 offset2 = vec2(0.6, 1.1) * time * 0.4;

	vec2	mUv = (pos.xz + offset1)*scale - floor((pos.xz + offset1)*scale);
	vec2	mUv2 = (pos.xz + offset2)*scale*3.0 - floor((pos.xz + offset2)*scale*3.0);

	vec4 ddd = texture2D( TEXTURE_3, mUv);
	vec4 dd2 = texture2D( TEXTURE_3, mUv2);

	//float NWaves = cos(pos.x + time) * cos(pos.z + time)-0.5;


	return (ddd.r + dd2.r - ddd.g - dd2.g + ddd.b + dd2.b)*0.1;
}

vec3 nW(POS3 pos){
	float time = TIME;//*0.5 - floor(TIME*0.5);
	vec2 offset1 = vec2(0.8, 0.4) * time * 0.1;
	vec2 offset2 = vec2(0.6, 1.1) * time * 0.4;

	vec2	mUv = (pos.xz + offset1)*0.1 - floor((pos.xz + offset1)*0.1);
	vec2	mUv2 = (pos.xz + offset2)*0.3 - floor((pos.xz + offset2)*0.3);

	vec4 ddd = texture2D( TEXTURE_3, mUv);
	vec4 dd2 = texture2D( TEXTURE_3, mUv2);
	
	return ddd.rgb - dd2.rgb;
	
}

vec4 waterColor(POS3 pos, POS3 CamPos, vec3 N){
	
	bool side = false;
	
	if(N.y < N.x || N.y < N.z){
		side = true;
	}
	
	N += nW(pos)*0.1;
	N = normalize(N);
	

	vec3 mReflect = normalize(reflect(normalize(CamPos - pos), N));

	vec3 cloudPos = worldPosToCloudPos(mReflect, SKY_HEIGH);

	vec4 cloudReflection = calcSky(cloudPos, TEXTURE_3);

	//Calculate water transparents
	float len = 1.0;
	vec3 viewVec = pos - CAMERA_OFFSET;
	vec3 otherVec = vec3(0.0, pos.y, 0.0);
	float le = (length(viewVec) * length(otherVec));
	if(le != 0.0){
		len = dot(viewVec, otherVec) / le;
	}

	len = min(1.0, (1.0 - abs(len))+ 0.4);

	if(side){
		N = vec3(0.0);
	}

	vec4 wC = vec4(mix(vec3(E_WATER_COLOR_NEAR.r, E_WATER_COLOR_NEAR.g, E_WATER_COLOR_NEAR.b + N.x*2.0+N.z*2.0), vec3(E_WATER_COLOR_FAR.r, E_WATER_COLOR_FAR.g, E_WATER_COLOR_FAR.b + N.x*2.0+N.z*2.0), len), len);

	wC.rgb = mix(wC.rgb, cloudReflection.rgb, (0.6-N.x-N.z) * len );

	return wC;
}


vec4 doWater(POS3 pos, POS3 camPos, vec4 diffuse, vec3 N){

  float le = 0.0;

  #ifdef TRANSPARENT_WATER
  		le = length(pos.xz) / (RENDER_DISTANCE*0.5) + TRANSPARENT_WATER_OFFSET;

  		diffuse.a = min(1.0, le * 0.75 + 0.1);
  #endif

  #ifdef E_WATER
  		#ifdef REFLECTION
  			diffuse = waterColor(pos.xyz, camPos, N);
  		#else
  			le = length(pos.xz);

  			le /= RENDER_DISTANCE*1.2;
  			le = min(1.0, le);
  			diffuse.rgb = mix(E_WATER_COLOR_NEAR, E_WATER_COLOR_FAR, diffuse.a - TRANSPARENT_WATER_OFFSET);

  			diffuse.rgb = mix(diffuse.rgb, FOG_COLOR.rgb, min(1.0, le*le*le*3.0));
  		#endif
  #endif

  return diffuse;
}
