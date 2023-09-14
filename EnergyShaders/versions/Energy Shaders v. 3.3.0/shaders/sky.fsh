// __multiversion__
// This signals the loading code to prepend either #version 100 or #version 300 es as apropriate.

// To use centroid sampling we need to have version 300 es shaders, which requires changing:
// attribute to in
// varying to out when in vertex shaders or in when in fragment shaders
// defining an out vec4 FragColor and replacing uses of gl_FragColor with FragColor
// texture2D to texture
#if __VERSION__ >= 300

// version 300 code

#define varying in
#define texture2D texture
out vec4 FragColor;
#define gl_FragColor FragColor

#else

// version 100 code

#endif

uniform vec4 FOG_COLOR;
uniform highp float TIME;
uniform vec2 FOG_CONTROL;
uniform POS3 VIEW_POS;

varying vec4 color;
varying POS3 pos;

/*========================SETTINGS========================*/
/* You can Edit this to change the look of Energy Shaders */
/*        Energy Shaders is created by Pro Coder          */
/*========================SETTINGS========================*/

#define SKY_COLOR vec4(0.1, 0.35, 0.7, 0.5)

#define CLOUD 									//No, I don`t mean the Youtuber, sry

#define CLOUD_Z_MOVE_SCALE 0.05					//This sets how fast and in which
#define CLOUD_X_MOVE_SCALE 0.001				//direction the clouds are moving!

#define ROUND_SKY_FACTOR 4.0					//This two numbers will change the roundness of the sky,
#define ROUND_SKY_FACTOR_TOO 15.0				//It is hard to explain, so just play a bit through with it!

#define CLOUD_RAIN_COLOR vec3(0.25, 0.3, 0.3)

#define MIX_SKY_AND_FOG							//recommend

/*=====================STOP=====================*/
/* Stop here your Editing without permission of */
/*                   Pro Coder                  */
/*    Energy Shaders is created by Pro Coder    */
/*=====================STOP=====================*/

float getRain(){
  return min(1.0, max(0.0, 1.0-pow(FOG_CONTROL.y,5.0))*2.0);
}

highp float  unrealPos(highp float x, highp float z, float fact){
  highp float factor = length(vec2(x, z));
  
  return fact - factor * ROUND_SKY_FACTOR_TOO;
}

float clacCodeBasedNoiseTexture(vec2 a){
  float ca = sin(a.x + TIME*0.1 + a.y - a.x + sin(a.x+TIME*0.1) + cos(a.y + a.y - a.x));
  float cc = sin(a.x+(cos(a.y)*0.1));
  float cd = 0.0;
  
  return ca*1.5/*-cb*/*cc;
}

vec4 CloudColor(float a, vec3 fog, float dis){
  vec3 cloudColor = vec3(1.5);
  
  cloudColor *= fog*2.0;
  cloudColor += vec3(0.1);
  
  //cloudColor = mix(cloudColor, FOG_COLOR.rgb*1.2, 0.5);
  
  
  cloudColor *= mix(vec3(1.0) , CLOUD_RAIN_COLOR, getRain());
  a += 0.3*getRain();


  cloudColor = mix(cloudColor, fog, dis);

  
  cloudColor = min(vec3(1.0), cloudColor);
  
  return vec4(cloudColor, min(0.95, a));
}

void main()
{

	highp float dis = length(pos.xz);

	float disForSky = clamp(dis*1.3, 0.0, 1.0);
	float disForClouds = clamp(dis*2.7, 0.0, 2.0);

	disForClouds = disForClouds * max(1.0, 2.0-disForClouds);
	disForClouds = min(1.0, disForClouds - 0.055);
	
	vec4 diffuse = SKY_COLOR;
	vec4 cloud = vec4(0.0);
	diffuse.rgb *= vec3(FOG_COLOR.b+0.1, FOG_COLOR.b+0.1, FOG_COLOR.b+0.3);
	diffuse.rgb += vec3(0.1, 0.0, 0.0) * pow(FOG_COLOR.r, 2.0);

	//Clouds
	#ifdef CLOUD
		highp float x = pos.x;
		highp float z = pos.z;

		cloud.a = 1.25 + max(0.0,0.7-disForClouds);//unrealPos(x ,z, ROUND_SKY_FACTOR+2.0);
		
		x *= 2.0 * (cloud.a*4.0);
		z *= 2.0 * (cloud.a*4.0);
		z += TIME * CLOUD_Z_MOVE_SCALE;
		x += TIME * CLOUD_X_MOVE_SCALE;

		//cloud.a = max(0.0, sin(x - cos(z*2.0)));
		cloud.a = clacCodeBasedNoiseTexture(vec2(x, z));
		cloud.a = (mix(clacCodeBasedNoiseTexture((vec2(x, z*0.7))*5.0), cloud.a, cloud.a)*max(0.0, cloud.a))*2.0;
		cloud.a *= 0.2;
		cloud.a -= cloud.a * 0.2 * cloud.a;
		cloud.a *= max(0.0, min(1.0, unrealPos(pos.x, pos.z, ROUND_SKY_FACTOR + 4.0)));

		cloud = CloudColor(cloud.a, FOG_COLOR.rgb, disForClouds);

		diffuse.rgb = mix(diffuse.rgb, cloud.rgb, max(0.0, min(1.0, cloud.a)));
	#endif
	
	
	
	
	
	//Mix it with the Fog, so there is no "cut" between the fog and the sky!
	#ifdef MIX_SKY_AND_FOG
		diffuse.rgb = mix(diffuse.rgb, FOG_COLOR.rgb,	disForSky);
	#endif
	
	gl_FragColor = diffuse;
}