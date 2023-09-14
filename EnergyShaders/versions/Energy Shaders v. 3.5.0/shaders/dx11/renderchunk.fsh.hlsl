#include "ShaderConstants.fxh"
#include "Util.fxh"

struct PS_Input
{
	float4 position : SV_Position;
	float3 fragPos : POSI;
	float3 RealScreenPos : SPOSI;

#ifndef BYPASS_PIXEL_SHADER
	lpfloat4 color : COLOR;
	snorm float2 uv0 : TEXCOORD_0_FB_MSAA;
	snorm float2 uv1 : TEXCOORD_1_FB_MSAA;
#endif

#ifdef NEAR_WATER
	float cameraDist : TEXCOORD_2;
#endif

#ifdef FOG
	float4 fogColor : FOG_COLOR;
#endif
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
//#define INIFINTE_BUMP	//NEDDS GOOD GRAPHIC CARD
//#define ULTRA_CLOUDS	//NEDDS GOOD GRAPHIC CARD
//END




/*float hash( float n )
{
  return frac(cos(n)*41415.92653);
}

float Enoise( float3 x )
{
  float3 p  = floor(x);
  float3 f  = smoothstep(0.0, 1.0, frac(x));
  float n = p.x + p.y*57.0 + 113.0*p.z;

  return lerp(lerp(lerp( hash(n+  0.0), hash(n+  1.0),f.x),lerp( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),lerp(lerp( hash(n+113.0), hash(n+114.0),f.x),lerp( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
}

float2 rando(float2 p){
  float2 np = frac(p * float2(443.897 , 441.423));
  np += dot(np, np.yx + float2(19.19, 19.19));
  np = frac((np.xx + np.yx)* np.xy) * 2.0 - 1.0;
  return np;
};

float st(float2 p){
	float s;

    float X = floor(p.x*90.0);
    float Y = floor(p.y*90.0);

    p += floor(p * 90.0) + X + Y;

    s = sin(p.x) * sin(p.y);

    return s;//1.0
}

float st2(float2 p){
	float s;
    float ss = 2.0;
    float f = 45.0;

   	p += floor(p * (f));

    s = sin(p.x + TIME * ss) * sin(p.y + TIME * ss);

    return s;//0.3
}*/

min16float3 calculateSurfaceNormal(min16float3 chunkedPos){
	//use opengl es build in function to fix prcision issue.
	//also use chunkedPos here because it is much more exact
	min16float3 normal = normalize(cross(ddx(chunkedPos), ddy(chunkedPos)));
	return normal;
}

float4 EnergyColorMap(float4 c){
	float R,G,B;

	R = c.r;
	G = c.g;
	B = c.b;

	R = lerp(R,R * 1.5, max(0.0, R - (G + B)));
	G = lerp(G,G * 1.5, max(0.0, G - (R + B)));
	B = lerp(B,B * 1.5, max(0.0, B - (G + R)));

	return float4(R, G, B, c.a);
}

float3 EnergyColorMap(float3 c){
	float R,G,B;

	R = c.r;
	G = c.g;
	B = c.b;

	R = lerp(R,R * 1.5, max(0.0, R - (G + B)));
	G = lerp(G,G * 1.5, max(0.0, G - (R + B)));
	B = lerp(B,B * 1.5, max(0.0, B - (G + R)));

	return float3(R, G, B);
}

/**
*returns the difference of the two given colors from 0.0 to ...
*/
float getColorDifference(float3 c1, float3 c2){
	float3 d = abs(c1 - c2);	//think about using length function
	return (d.r + d.g*0.0f + d.b);//1.0f;
}

float3 addLight(min16float3 pos, float light, float height, float3 colorC){
  //vec3 m = max(vec3(0.75), min(vec3(1.0), (vec3(1.0) - colorC.rgb) + vec3(0.75)));
	return colorC * (max(1.0, height - 1.0)*2.0* max(0.0, light-0.5) + 1.0);
}

float3 getRelativeBrightness(float3 diffuse){
	float r = max(0.0, diffuse.r - (diffuse.g + diffuse.b));
	float g = max(0.0, diffuse.g - (diffuse.r + diffuse.b));
	float b = max(0.0, diffuse.b - (diffuse.r + diffuse.g));
	return pow(float3(r, g, b)*5.0, float3(2.0, 2.0, 2.0))*5.0;
}

float3 toneMap(float3 diffuse){
	float3 invert = float3(1.0, 1.0, 1.0) - diffuse;
	diffuse = lerp(diffuse, diffuse*1.2, invert);
	return diffuse;
}

float colorTA(min16float3 pos){
	pos.x += pos.y*0.5;
	pos.z += pos.y*0.5;

	float2 u1 = pos.xz*0.5 - floor(pos.xz*0.5);
	float2 u2 = pos.xz*5.0 - floor(pos.xz*5.0);
	float2 u3 = pos.xz*0.2 - floor(pos.xz*0.2);

	float4 n1 = TEXTURE_3.Sample( TextureSampler3, u1 );
	float4 n2 = TEXTURE_3.Sample( TextureSampler3, u2 );
	float4 n3 = TEXTURE_3.Sample( TextureSampler3, u3 );
	n1 += n2 - n3;

	float a = 0.6 + (n1.r-n1.g+n1.b)*0.8;

	return a;
}

float4 colorT(float2 mUv, min16float3 pos, float4 diffuse, float3 N){

	float3 AN = abs(N);

	if(AN.z > AN.x+AN.y){
		pos.z = pos.y;
	}else if(AN.x > AN.z+AN.y){
		pos.x = pos.y;
	}

	float2 u1 = pos.xz*0.5 - floor(pos.xz*0.5);
	float2 u2 = pos.xz*5.0 - floor(pos.xz*5.0);
	float2 u3 = pos.xz*0.2 - floor(pos.xz*0.2);

	float4 n1 = TEXTURE_3.Sample( TextureSampler3, u1 );
	float4 n2 = TEXTURE_3.Sample( TextureSampler3, u2 );
	float4 n3 = TEXTURE_3.Sample( TextureSampler3, u3 );
	float4 cur = diffuse;

	n1 += n2 - n3;


	cur.rgb *= 0.6 + (n1.r-n1.g+n1.b)*0.8;
	cur.a = 0.6 + (n1.r-n1.g+n1.b)*0.8;

	return cur;
}

float4 doColor(min16float3 pos, min16float3 CamPos, min16float3 screenPos, float2 uv, float2 light, float4 diffuse, bool water, float3 N, float4 co){
	diffuse.rgb *= co.rgb;	//to get the Real block Color

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
	float4 fog = float4(E_FOG_COLOR, 0.0);
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
			if(co.g <= co.r){	//No grass
				float4 dxm = TEXTURE_0.Sample( TextureSampler0, float2(uv.x-0.1 * FACT, uv.y) ) * co;
				float4  dym = TEXTURE_0.Sample( TextureSampler0, float2(uv.x, uv.y-0.2 * FACT) ) * co;

				float4 d5 = lerp(dxm, dym, 0.5);
				diffuse.rgb = lerp(diffuse.rgb, (diffuse.rgb * 0.5),max(0.0, min(1.0, getColorDifference(diffuse.rgb, d5.rgb)*3.0)) );	//fake bump effect
			}
		#endif

		#if defined(BUMP_WITH_NOISE) && !defined(ALPHA_TEST)
			float le = length(pos);
			#ifdef INIFINTE_BUMP
				float3 ndif = diffuse.rgb*1.1;
				ndif = EnergyColorMap(ndif);
				diffuse.rgb *= 0.8;

				float4 bump = colorT(uv,(pos+VIEW_POS.xyz), diffuse, N);
				diffuse.rgb = bump.rgb;
				diffuse.rgb = addLight(pos, light.x, bump.a, diffuse.rgb);

			#else
				if(le <= 20.0){	//It is really laggy, so don`t do it over the hole world
					float3 ndif = diffuse.rgb*1.1;
	        ndif = EnergyColorMap(ndif);
					float mValue = max(0.0, le-18.0)*0.5;
	        diffuse.rgb *= 0.8;

	   			float4 bump = colorT(uv,(pos+VIEW_POS.xyz), diffuse, N);
					diffuse.rgb = bump.rgb;
					diffuse.rgb = addLight(pos, light.x, bump.a, diffuse.rgb);
					diffuse.rgb = lerp(diffuse.rgb, ndif, mValue);
				}else{
					diffuse.rgb *= 1.1;
				}
			#endif

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
						shadow = lerp(1.0, 0.0, fadeInE);
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
				diffuse.rgb = lerp(diffuse.rgb, float3(0.7, 0.3, 0.2), max(0.0, light.x-0.6)*(abs(sin(TIME*5.0-cos(TIME*2.0)+sin(TIME)))*0.5+1.5));
			#else
				float3 experimental = float3(1.0, 1.0, 1.0);

				#ifdef EXPERIMENTAL_LIGHT
					experimental =  diffuse.rgb * (float3(1.0, 1.0, 1.0) - diffuse.rgb)*2.7;
				#endif

				diffuse.rgb += max(float3(0.0, 0.0, 0.0), E_TORCH_LIGHT_COLOR * (light.x + E_TORCH_LIGHT_OFFSET)) * experimental;
			#endif
		#endif

		/*
		* Sun light
		*
		* Not finished yet.
		*/
		#ifdef SUN_LIGHT
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
			diffuse.rgb *= max(float3(0.3+max(0.0, light.x-0.5)*1.2, 0.3+max(0.0, light.x-0.5)*1.2, 0.3+max(0.0, light.x-0.5)*1.2), min(float3(0.5, 0.5, 0.5), FOG_COLOR.rgb*2.0) * 2.0);
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
        shadow += max(0.0, (1.0 - max(0.0, pow(min(1.0, co.a + 0.3 + (1.0 - light.y)), 7.0)))*2.0 - light.x * 2.0);
        shadow = min(1.0, shadow);
      #endif
			diffuse.rgb = lerp(diffuse.rgb, (diffuse.rgb) * max(0.3, min(0.5, light.y)), shadow);
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
			diffuse.rgb = lerp(diffuse.rgb, diffuse.rgb*0.2, max(0.0, length(screenPos.xy)-0.3));
		#endif

		diffuse.rgb = toneMap(diffuse.rgb);

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
						fog.rgb = lerp(E_UNDERWATER_FOG_COLOR, fog.rgb, len);
					#endif

					diffuse.rgb = lerp(diffuse.rgb, fog.rgb, len);
				#endif
			}else{
				len *= 1.1;
				len /= RENDER_DISTANCE;
				len = min(1.0, len);

				#ifdef MIX_E_FOG_WITH_MOJANG_FOG
					fog.rgb = lerp(E_FOG_COLOR, fog.rgb, clamp(0.0, 1.0, len*len));
				#endif

				diffuse.rgb = lerp(diffuse.rgb, fog.rgb, clamp(0.0, 1.0, len));
				diffuse.a = max(min(1.0,fog.a * len), diffuse.a);
			}
		#endif
	}



	return diffuse;
}


float getRain(){
  return min(1.0, max(0.0, 1.0-pow(FOG_CONTROL.y,5.0))*2.0);
};

float clacCodeBasedNoiseTexture(min16float2 a){
  float ca = sin(a.x + TIME*0.1 + a.y - a.x + sin(a.x+TIME*0.1) + cos(a.y + a.y - a.x));
  float cc = sin(a.x+(cos(a.y)*0.1));
  float cd = 0.0;

  return ca*1.5*cc;
};

float getFlackering(min16float t){

	t*=0.005;

	t *= abs(sin(t) + cos(t)) / 2 + 0.5f;

	t*= 200;

	float f = cos(t*1.2) + sin(t);
	f /= 2.0f;

	f += cos(t/2);
	f *= sin(t/4);

	f += cos(t + 45.0f);
	f -= sin(cos(t*0.05f) * sin(t*0.02f) * 90.0f);

	f *= 0.5f;

	return abs(f);
}


//////////////////////CLOUDS---------------------------------------------------------------------------

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
				float scale = 0.05;

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






float waves(min16float3 pos){
	float time = 1.0;//TIME;//*0.5 - floor(TIME*0.5);
	float2 offset1 = float2(0.8, 0.4) * time * 0.1;
	float2 offset2 = float2(0.6, 1.1) * time * 0.4;

	float2	mUv = (pos.xz + offset1)*0.1 - floor((pos.xz + offset1)*0.1);
	float2	mUv2 = (pos.xz + offset2)*0.3 - floor((pos.xz + offset2)*0.3);

	float4 ddd = TEXTURE_3.Sample( TextureSampler3, mUv);
	float4 dd2 = TEXTURE_3.Sample( TextureSampler3, mUv2);

	//float NWaves = cos(pos.x + time) * cos(pos.z + time)-0.5;


	return (ddd.r + dd2.r - ddd.g - dd2.g + ddd.b + dd2.b)*0.1;
}

float waves(min16float3 pos, float scale){
	float time = 1.0;//TIME;//*0.5 - floor(TIME*0.5);
	float2 offset1 = float2(0.8, 0.4) * time * 0.1;
	float2 offset2 = float2(0.6, 1.1) * time * 0.4;

	float2	mUv = (pos.xz + offset1)*scale - floor((pos.xz + offset1)*scale);
	float2	mUv2 = (pos.xz + offset2)*scale*3.0 - floor((pos.xz + offset2)*scale*3.0);

	float4 ddd = TEXTURE_3.Sample( TextureSampler3, mUv);
	float4 dd2 = TEXTURE_3.Sample( TextureSampler3, mUv2);

	//float NWaves = cos(pos.x + time) * cos(pos.z + time)-0.5;


	return (ddd.r + dd2.r - ddd.g - dd2.g + ddd.b + dd2.b)*0.1;
}

float3 nW(min16float3 pos){
	float time = TIME;//*0.5 - floor(TIME*0.5);
	float2 offset1 = float2(0.8, 0.4) * time * 0.1;
	float2 offset2 = float2(0.6, 1.1) * time * 0.4;

	float2	mUv = (pos.xz + offset1)*0.1 - floor((pos.xz + offset1)*0.1);
	float2	mUv2 = (pos.xz + offset2)*0.3 - floor((pos.xz + offset2)*0.3);

	float4 ddd = TEXTURE_3.Sample( TextureSampler3, mUv);
	float4 dd2 = TEXTURE_3.Sample( TextureSampler3, mUv2);

	return ddd.rgb - dd2.rgb;

}

float4 waterColor(min16float3 pos, min16float3 CamPos, float3 N){

	N = -N;

	bool side = false;

	if(abs(N.y) < abs(N.x) || abs(N.y) < abs(N.z)){
		side = true;
	}else{
		N += nW(pos)*0.1;
		N = normalize(N);

	}


	float3 mReflect = normalize(reflect(normalize(CamPos - pos), N));

	float3 cloudPos = worldPosToCloudPos(mReflect, SKY_HEIGH);

	float4 cloudReflection = calcSky(cloudPos);

	//Calculate water transparents
	float len = 1.0;
	float3 viewVec = pos - CAMERA_OFFSET;
	float3 otherVec = float3(0.0, pos.y, 0.0);
	float le = (length(viewVec) * length(otherVec));
	if(le != 0.0){
		len = dot(viewVec, otherVec) / le;
	}

	len = min(1.0, (1.0 - abs(len))+ 0.4);

	if(side){
		N = float3(0.0, 0.0, 0.0);
	}

	float4 wC = float4(lerp(float3(E_WATER_COLOR_NEAR.r, E_WATER_COLOR_NEAR.g, E_WATER_COLOR_NEAR.b + N.x*2.0+N.z*2.0), float3(E_WATER_COLOR_FAR.r, E_WATER_COLOR_FAR.g, E_WATER_COLOR_FAR.b + N.x*2.0+N.z*2.0), len), len);

	wC.rgb = lerp(wC.rgb, cloudReflection.rgb, (0.6-N.x-N.z) * len );

	return wC;
}

float4 doWater(min16float3 pos, min16float3 camPos, float4 diffuse, float3 N){

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
  			diffuse.rgb = lerp(E_WATER_COLOR_NEAR, E_WATER_COLOR_FAR, diffuse.a - TRANSPARENT_WATER_OFFSET);

  			diffuse.rgb = lerp(diffuse.rgb, FOG_COLOR.rgb, min(1.0, le*le*le*3.0));
  		#endif
  #endif

  return diffuse;
}






  static const float3 UNIT_Y = float3(0.0,1.0,0.0);
  static const float maxDist = 0.9579790980632242;




void main( in PS_Input PSInput, out PS_Output PSOutput )
{
	//if pixel shader is used, return 0.0f
#ifdef BYPASS_PIXEL_SHADER
    PSOutput.color = float4(0.0f, 0.0f, 0.0f, 0.0f);
    return;
#else

bool water = false;

#ifdef NEAR_WATER
	water = true;	//if we are rendering water set water to true
#endif

//Get Color of the current texel
#if !defined(TEXEL_AA) || !defined(TEXEL_AA_FEATURE) || (VERSION < 0xa000 /*D3D_FEATURE_LEVEL_10_0*/)
	float4 diffuse = TEXTURE_0.Sample(TextureSampler0, PSInput.uv0 );
#else
	float4 diffuse = texture2D_AA(TEXTURE_0, TextureSampler0, PSInput.uv0 );
#endif

//fix far water bug - ESPE changes the water texture to a half transparent black texture, so it is easy to detect without
//messing up other stuff
if(diffuse.a < 0.5f && diffuse.a > 0.1f && diffuse.r == 0.0f && PSInput.color.g*diffuse.g <= 0.01f && PSInput.color.b*diffuse.b <= 0.01f){
		water = true;
}

float3 N = calculateSurfaceNormal(PSInput.fragPos.xyz);

if(water){
	#ifdef REFLECTION
		diffuse = doWater(PSInput.fragPos.xyz, float3(0.0, 1.75, 0.0), diffuse, N);
	#else
		#ifdef TRANSPARENT_WATER
			float le = length(PSInput.fragPos.xz) / (RENDER_DISTANCE * 0.5f) + TRANSPARENT_WATER_OFFSET;
			diffuse.a = min(1.0f, le);
		#endif

		#ifdef E_WATER
			diffuse.rgb = lerp(E_WATER_COLOR_NEAR, E_WATER_COLOR_FAR, diffuse.a - TRANSPARENT_WATER_OFFSET);
		#endif
	#endif
}else{

diffuse = doColor(PSInput.fragPos.xyz, float3(0.0, 1.75, 0.0), PSInput.RealScreenPos.xyz, PSInput.uv0, PSInput.uv1, diffuse, water, N, PSInput.color);




#ifdef SEASONS_FAR
	diffuse.a = 1.0f;
	PSInput.color.b = 1.0f;
#endif

#ifdef ALPHA_TEST
//If we know that all the verts in a triangle will have the same alpha, we should cull there first.
	#ifdef ALPHA_TO_COVERAGE
		float alphaThreshold = .05f;
	#else
		float alphaThreshold = .5f;
	#endif
	if(diffuse.a < alphaThreshold)
		discard;
#endif

#ifdef USE_MOJANG_TORCH_LIGHT_AND_SHADOW
	#if !defined(ALWAYS_LIT)
		diffuse = diffuse * TEXTURE_1.Sample(TextureSampler1, PSInput.uv1);
	#endif
#endif

#ifndef SEASONS

	#if !defined(ALPHA_TEST) && !defined(BLEND)
		diffuse.a = PSInput.color.a;
	#elif defined(BLEND)
		diffuse.a *= PSInput.color.a;

	#endif
#else
	#ifdef ALPHA_TEST
		//float2 uv = PSInput.color.xy;
		//diffuse.rgb *= lerp(1.0f, TEXTURE_2.Sample(TextureSampler2, uv).rgb*2.0f, PSInput.color.b);

		//diffuse.a = 1.0f;
	#endif
#endif
}

PSOutput.color = diffuse;

#ifdef VR_MODE
	// On Rift, the transition from 0 brightness to the lowest 8 bit value is abrupt, so clamp to
	// the lowest 8 bit value.
	PSOutput.color = max(PSOutput.color, 1 / 255.0f);
#endif

#endif // BYPASS_PIXEL_SHADER
}
