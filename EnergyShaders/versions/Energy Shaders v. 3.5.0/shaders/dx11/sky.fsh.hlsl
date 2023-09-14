#include "ShaderConstants.fxh"

struct PS_Input
{
    float4 position : SV_Position;
	float3 fragPos : POSI;
    float4 color : COLOR;
	float is_sky : IS_SKY;
};

struct PS_Output
{
    float4 color : SV_Target;
};

Texture2D TEXTURE_3 : register (t3);
sampler TextureSampler3 : register(s3);

#define CAMERA_OFFSET float3(0.0, 1.75, 0.0);

#define E_FOG
#define USE_MOJANG_FOG_COLOR
#define E_FOG_COLOR float3(0.3, 0.4, 0.7)
#define MIX_E_FOG_WITH_MOJANG_FOG
#define E_UNDERWATER_FOG
#define E_UNDERWATER_FOG_COLOR float3(0.2, 0.4, 0.8)

#define E_SHADOW
#define E_SHADOW_WIDTH 0.87
#define E_SHADOW_FADE_IN
#define CAVE_DARKNESS 0.2
#define FADE_IN_E_SHADOW_WIDTH float2(0.025, 1.0 / 0.025)

//#define USE_MOJANG_TORCH_LIGHT_AND_SHADOW

#define E_TORCH_LIGHT
#define E_TORCH_LIGHT_COLOR float3(0.9, 0.15, 0.05)
#define E_TORCH_LIGHT_OFFSET -0.4
//#define USE_TORCH_LIGHT_OF_CHRISMAS_SHADERS
//#define EXPERIMENTAL_LIGHT

#define ENERGY_COLOR_MAP
#define SUN_LIGHT
#define FOG_BASED_NIGHT_LIGHT
#define SCREEN_BASED_BLOOM

#define TRANSPARENT_WATER
#define TRANSPARENT_WATER_OFFSET 0.65
#define E_WATER
#define E_WATER_COLOR_NEAR float3(0.1, 0.3, 0.5)
#define E_WATER_COLOR_FAR float3(0.3, 0.5, 0.6)

#define REFLECTION
#define WATER_COLOR float3(0.1, 0.25, 0.5)	//Only If REFLECTION is defined!
#define E_SKY_COLOR float3(0.1, 0.35, 0.7)
#define SKY_HEIGH 270.0

//#define FAKE_BUMP_EFFECT	//A generated 3D effect - looks weird sometimes!
#define FACT 0.00065

//REFLECTION
#define SKY_COLOR float4(0.1, 0.35, 0.7, 0.5)

#define CLOUD 									//No, I don`t mean the Youtuber, sry

#define CLOUD_Z_MOVE_SCALE 0.05					//This sets how fast and in which
#define CLOUD_X_MOVE_SCALE 0.001				//direction the clouds are moving!

#define ROUND_SKY_FACTOR 4.0					//This two numbers will change the roundness of the sky,
#define ROUND_SKY_FACTOR_TOO 15.0				//It is hard to explain, so just play a bit through with it!

#define CLOUD_RAIN_COLOR float3(0.25, 0.3, 0.3)

#define MIX_SKY_AND_FOG							//recommend
#define BUMP_WITH_NOISE
//#define ULTRA_CLOUDS

//////////////////////CLOUDS---------------------------------------------------------------------------

float getRain(){
  return min(1.0, max(0.0, 1.0-pow(FOG_CONTROL.y,5.0))*2.0);
};

float3 worldPosToCloudPos(float3 n, float sky_height){

	//Expand factor
	float Expandfactor = sky_height / n.y;

	//It is now it the heigh of the clouds, and it would be the right refletion, but the sky position doesn't equals the worldPos, so it is still not real :/
	float3 UnrealCloudPos = n * Expandfactor;


	return (UnrealCloudPos / (RENDER_DISTANCE*60.0));
}

min16float unrealPos(min16float x, min16float z, float fact){
  min16float factor = length(float2(x, z));

  //return pow(5.6-factor, 20.0) / (pow(10.0, 12.0)*0.98);
 min16float angle = atan2(factor, fact);
 return cos(angle)*25.0;
}

min16float nn(min16float3 a){
  min16float ca = sin(a.x + TIME*0.1 + a.y + sin(a.x+TIME*0.1) + cos(a.y + a.y));
  min16float cc = sin(a.x+(cos(a.y)*0.1));

  return max(0.0, ca) + max(0.0, cc);
}

min16float clacCodeBasedNoiseTexture(min16float3 a){
  min16float ca = sin(a.x + TIME*0.1 + a.y - a.x + sin(a.x+TIME*0.1) + cos(a.y + a.y - a.x));
  min16float cc = sin(a.x+(cos(a.y)*0.1));


  return ca * 1.5 * cc;
}

/*min16float2 ra(min16float2 p){
		 return p + sin(acos(abs(fract(p*100.0)-0.5)*2.0))*0.004;
}

min16float2 ran(min16float2 p){
		 return p;// + sin(atan(abs(fract(ra(p)*100.0)-0.5)*2.0))*0.004;
}*/

//New clouds
float frTime(min16float t){
	return abs(frac(t)-0.5);
}

min16float2 newPos(min16float2 p, float a, float b){
	p *= 10.0;
	p += float2(a, b);
	p *= 0.4;//frac(a)*0.5;
	p += float2(a+ 627.83, b + 137.67);
	p *= float2(p.x*0.001 - a*0.001, p.y*0.001 - b*0.01);
	p *= 0.1;
	return p;
}

float cloud(min16float2 p){
	min16float2 p1 = newPos(p, 27.78 + frTime(TIME*0.004)*1000.0, 197.67 + frTime(TIME*0.004)*100.0);
	min16float2 p2 = newPos(p, 67.955 + frTime(TIME*0.004)*1000.0, 178.59 + frTime(TIME*0.004)*100.0);
	min16float2 p3 = newPos(p, p1.x*0.001, p2.x*0.001);

	float a = sin(p1.x + p2.y);
	float b = sin(p1.y + p2.y);
	float c = cos(p2.x + p1.y);
	float d = cos(p.x  + p2.y);
	float e = sin(p3.x + p2.y);


 return (a * b * c + d + e) * 0.45;
}

float smoooth(min16float2 p, float scale){

	min16float2 pl = p + float2(-0.1*scale, 0.0);
	min16float2 pr = p + float2(0.1 *scale, 0.0);
	min16float2 pt = p + float2(0.0, 0.1*scale );
	min16float2 pb = p + float2(0.0, -0.1*scale);

	return lerp(cloud(p), lerp(lerp(cloud(pl), cloud(pr), 0.5), lerp(cloud(pt), cloud(pb), 0.5), 0.5), 0.5);
}

float nice(min16float2 p){
	min16float2 p1 = newPos(p, 728.872, 283.772);

	float c1 = smoooth(p , 2500.0);
	float c2 = smoooth(p1, 2000.0);

	return (c1 - c2)*0.75;
}

float finish(min16float2 p){

	float c1 = nice(p - float2(10.0, 5.0));

	p = newPos(p, c1*7.0, c1* 7.56);

	float c2 = nice(p + float2(10.1, 10.1));


	return lerp(c1, c2, 0.5)*1.5;
}

float4 CloudColor(float a, float3 fog, float dis, float v){
  float3 cloudColor = float3(1.5, 1.5, 1.5);

  cloudColor *= fog*2.0 + getRain()*0.5;
  cloudColor += float3(0.1, 0.1, 0.1);

  //cloudColor = mix(cloudColor, FOG_COLOR.rgb*1.2, 0.5);


  cloudColor *= lerp(float3(1.0, 1.0, 1.0) , CLOUD_RAIN_COLOR, getRain());
  a += 1.5*getRain();
  //a *= 1.0 - v * 0.2;
  //a += 0.1;
  cloudColor *= 1.0 - v *0.2;


  cloudColor = lerp(cloudColor, fog, dis);


  cloudColor = min(float3(1.0, 1.0, 1.0), cloudColor);

  return float4(cloudColor, min(0.95, a));
}

float4 calcClouds(min16float3 pos){
	float4 cloud = float4(0.0, 0.0, 0.0, 0.0);

	min16float dis = length(pos.xz);

	float disForClouds = clamp(dis*2.7, 0.0, 2.0);

	disForClouds = disForClouds * max(1.0, 2.0-disForClouds);
	disForClouds = min(1.0, disForClouds - 0.055);

  #ifdef CLOUD
  	min16float x = pos.x * unrealPos(pos.x, pos.z, 0.15);
  	min16float z = pos.z * unrealPos(pos.x, pos.z, 0.15);


  	cloud.a = 1.25 + max(0.0,0.7-disForClouds);//unrealPos(x ,z, ROUND_SKY_FACTOR+2.0);;//unrealPos(x ,z, 6.0);

  	//x *= 2.0 * (cloud.a*4.0);
  	//z *= 2.0 * (cloud.a*4.0);

  	z += TIME * CLOUD_Z_MOVE_SCALE;
  	x += TIME * CLOUD_X_MOVE_SCALE;

 		float v = 0.0;
  	#ifdef ULTRA_CLOUDS
  		cloud.a = finish(float2(x, z)* 5.0);
  	#else
  		/*cloud.a = max(0.0, sin(x - cos(z*2.0)));
  		cloud.a = clacCodeBasedNoiseTexture(vec3(x, z, 0.0));
	  	cloud.a = (mix(clacCodeBasedNoiseTexture((vec3(x, z*0.7, 0.0))*5.0), cloud.a, cloud.a)*max(0.0, cloud.a))*2.0;
	  	cloud.a *= 0.2;
	  	cloud.a -= cloud.a * 0.2 * cloud.a;
	  	cloud.a *= 1.5;*/


  	//cloud.a *= max(0.0, min(1.0, unrealPos(pos.x, pos.z, 8.0)));


        float a = 0.0;
        float scale = 0.25;

        float3 n = TEXTURE_3.Sample( TextureSampler3, (frac(float2(x, z)*0.1))).rgb;
        float3 n2 = TEXTURE_3.Sample( TextureSampler3, (frac(float2(x+TIME*0.05, z + TIME *0.05)*0.1))).rgb;

        [loop]
        for( uint i = 0;i < 5; i++ )
        {
          a += a*1.343;
          n +=  TEXTURE_3.Sample( TextureSampler3, frac(float2(x+a*3.0, z+a*3.0)*scale)).rgb;
          n *= 0.75;
        }

				cloud.a =  0.35*((n.r + n2.r + n.g + n2.g + n.b + n2.b)*0.75-4.51);
				cloud.a *= 100.0 * cloud.a*cloud.a*cloud.a;
				cloud.a -= 0.1;

				v = max(0.0, n.r - n.g + n.b + n2.r);
  	#endif

  	cloud = CloudColor(cloud.a, FOG_COLOR.rgb, disForClouds, v);

  	//cloud.rgb *= (1.0 - v*0.2);

  #endif

	return cloud;
}

float4 calcSky(min16float3 pos){
  min16float dis = length(pos.xz);
	float disForSky = clamp(dis*1.3, 0.0, 1.0);

  float4 diffuse = SKY_COLOR;
	diffuse.rgb *= float3(FOG_COLOR.b+0.1, FOG_COLOR.b+0.1, FOG_COLOR.b+0.3);
	diffuse.rgb += float3(0.1, 0.0, 0.0) * pow(FOG_COLOR.r, 2.0);

  #ifdef CLOUD
    float4 cloud = calcClouds(pos);
    diffuse.rgb = lerp(diffuse.rgb, cloud.rgb, max(0.0, min(1.0, cloud.a)));
  #endif

  //Mix it with the Fog, so there is no "cut" between the fog and the sky!
	#ifdef MIX_SKY_AND_FOG
		diffuse.rgb = lerp(diffuse.rgb, FOG_COLOR.rgb,	disForSky);
    diffuse.a = min(1.0, diffuse.a + disForSky);
	#endif


  return diffuse;
}
/////////////////////////CLOUDS___________________________________________________________




void main( in PS_Input PSInput, out PS_Output PSOutput )
{
  PSOutput.color = calcSky(PSInput.fragPos.xyz);
}
