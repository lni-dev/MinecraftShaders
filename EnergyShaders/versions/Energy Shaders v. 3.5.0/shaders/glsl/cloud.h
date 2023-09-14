

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

float getRain(){
  return min(1.0, max(0.0, 1.0-pow(FOG_CONTROL.y,5.0))*2.0);
}

vec3 worldPosToCloudPos(vec3 n, float sky_height){

	//Expand factor
	float Expandfactor = sky_height / n.y;

	//It is now it the heigh of the clouds, and it would be the right refletion, but the sky position doesn't equals the worldPos, so it is still not real :/
	vec3 UnrealCloudPos = n * Expandfactor;


	return (UnrealCloudPos / (RENDER_DISTANCE*60.0));
}

highp float  unrealPos(highp float x, highp float z, float fact){
  highp float factor = length(vec2(x, z));

  //return pow(5.6-factor, 20.0) / (pow(10.0, 12.0)*0.98);
 highp float angle = atan(factor, fact);
 return cos(angle)*25.0;
}



highp float nn(POS3 a){
  highp float ca = sin(a.x + TIME*0.1 + a.y + sin(a.x+TIME*0.1) + cos(a.y + a.y));
  highp float cc = sin(a.x+(cos(a.y)*0.1));

  return max(0.0, ca) + max(0.0, cc);
}

highp float clacCodeBasedNoiseTexture(POS3 a){
  highp float ca = sin(a.x + TIME*0.1 + a.y - a.x + sin(a.x+TIME*0.1) + cos(a.y + a.y - a.x));
  highp float cc = sin(a.x+(cos(a.y)*0.1));


  return ca * 1.5 * cc;
}

//Function by Will!
highp vec2 ra(highp vec2 p){
		 return p + sin(acos(abs(fract(p*100.0)-0.5)*2.0))*0.004;
}

highp vec2 ran(highp vec2 p){
		 return p;// + sin(atan(abs(fract(ra(p)*100.0)-0.5)*2.0))*0.004;
}



//New clouds
float frTime(highp float t){
	return abs(fract(t)-0.5);
}

highp vec2 newPos(highp vec2 p, float a, float b){
	p *= 10.0;
	p += vec2(a, b);
	p *= 0.4;//fract(a)*0.5;
	p += vec2(a+ 627.83, b + 137.67);
	p *= vec2(p.x*0.001 - a*0.001, p.y*0.001 - b*0.01);
	p *= 0.1;
	return p;
}

float cloud(highp vec2 p){
	highp vec2 p1 = newPos(p, 27.78 + frTime(TIME*0.004)*1000.0, 197.67 + frTime(TIME*0.004)*100.0);
	highp vec2 p2 = newPos(p, 67.955 + frTime(TIME*0.004)*1000.0, 178.59 + frTime(TIME*0.004)*100.0);
	highp vec2 p3 = newPos(p, p1.x*0.001, p2.x*0.001);

	float a = sin(p1.x + p2.y);
	float b = sin(p1.y + p2.y);
	float c = cos(p2.x + p1.y);
	float d = cos(p.x  + p2.y);
	float e = sin(p3.x + p2.y);


 return (a * b * c + d + e) * 0.45;
}

float smoooth(highp vec2 p, float scale){

	highp vec2 pl = p + vec2(-0.1*scale, 0.0);
	highp vec2 pr = p + vec2(0.1 *scale, 0.0);
	highp vec2 pt = p + vec2(0.0, 0.1*scale );
	highp vec2 pb = p + vec2(0.0, -0.1*scale);

	return mix(cloud(p), mix(mix(cloud(pl), cloud(pr), 0.5), mix(cloud(pt), cloud(pb), 0.5), 0.5), 0.5);
}

float nice(highp vec2 p){
	highp vec2 p1 = newPos(p, 728.872, 283.772);

	float c1 = smoooth(p , 2500.0);
	float c2 = smoooth(p1, 2000.0);

	return (c1 - c2)*0.75;
}

float finish(highp vec2 p){

	float c1 = nice(p - vec2(10.0, 5.0));

	p = newPos(p, c1*7.0, c1* 7.56);

	float c2 = nice(p + vec2(10.1));


	return mix(c1, c2, 0.5)*1.5;
}


vec4 CloudColor(float a, vec3 fog, float dis, float v){
  vec3 cloudColor = vec3(1.5);

  cloudColor *= fog*2.0 + getRain()*0.5;
  cloudColor += vec3(0.1);

  //cloudColor = mix(cloudColor, FOG_COLOR.rgb*1.2, 0.5);


  cloudColor *= mix(vec3(1.0) , CLOUD_RAIN_COLOR, getRain());
  a += 1.5*getRain();
  //a *= 1.0 - v * 0.2;
  //a += 0.1;
  cloudColor *= 1.0 - v *0.3;


  cloudColor = mix(cloudColor, fog, dis);


  cloudColor = min(vec3(1.0), cloudColor);

  return vec4(cloudColor, min(0.95, a));
}


////////////...

vec4 calcClouds(POS3 pos, sampler2D noise){
	vec4 cloud = vec4(0.0);

	highp float dis = length(pos.xz);

	float disForClouds = clamp(dis*2.7, 0.0, 2.0);

	disForClouds = disForClouds * max(1.0, 2.0-disForClouds);
	disForClouds = min(1.0, disForClouds - 0.055);

  #ifdef CLOUD
  	highp float x = pos.x * unrealPos(pos.x, pos.z, 0.15);
  	highp float z = pos.z * unrealPos(pos.x, pos.z, 0.15);


  	cloud.a = 1.25 + max(0.0,0.7-disForClouds);//unrealPos(x ,z, ROUND_SKY_FACTOR+2.0);;//unrealPos(x ,z, 6.0);

  	//x *= 2.0 * (cloud.a*4.0);
  	//z *= 2.0 * (cloud.a*4.0);

  	z += TIME * CLOUD_Z_MOVE_SCALE;
  	x += TIME * CLOUD_X_MOVE_SCALE;

 		float v = 0.0;
  	#ifdef ULTRA_CLOUDS
  		cloud.a = finish(vec2(x, z)* 10.0);
  	#else
  		/*cloud.a = max(0.0, sin(x - cos(z*2.0)));
  		cloud.a = clacCodeBasedNoiseTexture(vec3(x, z, 0.0));
	  	cloud.a = (mix(clacCodeBasedNoiseTexture((vec3(x, z*0.7, 0.0))*5.0), cloud.a, cloud.a)*max(0.0, cloud.a))*2.0;
	  	cloud.a *= 0.2;
	  	cloud.a -= cloud.a * 0.2 * cloud.a;
	  	cloud.a *= 1.5;*/


  	//cloud.a *= max(0.0, min(1.0, unrealPos(pos.x, pos.z, 8.0)));

				float scale = 0.05;//0.2
				vec3 n = texture2D( noise, ran(fract(vec2(x, z)*0.1*scale))).rgb;
				vec3 n2 = texture2D( noise, fract(newPos(vec2(x+TIME*0.05, z + TIME *0.05)*0.1*scale, 829.2, 388.7))).rgb;

				float a = 1.0;

				for(int i=0;i<5;i++){
					a += a*1.343;
					n += texture2D( noise, fract(vec2(x+a*3.0, z+a*3.0)*scale)).rgb;
					n *= 0.75;
				}


				cloud.a = clacCodeBasedNoiseTexture(vec3(x, z, 0.0));
				//0.35
				cloud.a = 0.35*((n.r + n2.r + n.g + n2.g + n.b + n2.b)*0.75-4.51);
				cloud.a *= 100.0 * cloud.a*cloud.a*cloud.a;
				cloud.a -= 0.1;

				v = 0.0;//max(0.0, n.r - n.g + n.b + n2.r);
  	#endif

  	cloud = CloudColor(cloud.a, FOG_COLOR.rgb, disForClouds, v);

  	//cloud.rgb *= (1.0 - v*0.2);

  #endif

	return cloud;
}

vec4 calcSky(POS3 pos, sampler2D noise){
  highp float dis = length(pos.xz);
	float disForSky = clamp(dis*1.3, 0.0, 1.0);

  vec4 diffuse = SKY_COLOR;
	diffuse.rgb *= vec3(FOG_COLOR.b+0.1, FOG_COLOR.b+0.1, FOG_COLOR.b+0.3);
	diffuse.rgb += vec3(0.1, 0.0, 0.0) * pow(FOG_COLOR.r, 2.0);

  #ifdef CLOUD
    vec4 cloud = calcClouds(pos, noise);
    diffuse.rgb = mix(diffuse.rgb, cloud.rgb, max(0.0, min(1.0, cloud.a)));
  #endif

  //Mix it with the Fog, so there is no "cut" between the fog and the sky!
	#ifdef MIX_SKY_AND_FOG
		diffuse.rgb = mix(diffuse.rgb, FOG_COLOR.rgb,	disForSky);
    diffuse.a = min(1.0, diffuse.a + disForSky);
	#endif


  return diffuse;
}
