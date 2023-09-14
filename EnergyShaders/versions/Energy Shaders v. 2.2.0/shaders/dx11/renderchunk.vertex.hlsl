#include "ShaderConstants.fxh"

struct VS_Input {
	float3 position : POSITION;
	float4 color : COLOR;
	float2 uv0 : TEXCOORD_0;
	float2 uv1 : TEXCOORD_1;
#ifdef INSTANCEDSTEREO
	uint instanceID : SV_InstanceID;
#endif
};


struct PS_Input {
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
#ifdef INSTANCEDSTEREO
	uint instanceID : SV_InstanceID;
#endif
};

//SETTINGS

//Waves
	static const bool LeaveWaves = true;
	static const bool GrassWaves = true;
	static const bool UnderWaterWaves = true;
	static const bool RefractionWaterWaves = true;
	static const bool WaterWaves = true;
		static const float waveWidth = 15.5;
		static const float waveHeight = 0.0889;
		static const float speedwav = 1.3;

static const float rA = 1.0;
static const float rB = 1.0;
static const float3 UNIT_Y = float3(0, 1, 0);
static const float DIST_DESATURATION = 56.0 / 255.0; //WARNING this value is also hardcoded in the water color, don'tchange
static const float pi = 3.141;


void main(in VS_Input VSInput, out PS_Input PSInput) {

#ifndef BYPASS_PIXEL_SHADER
	PSInput.uv0 = VSInput.uv0;
	PSInput.uv1 = VSInput.uv1;
	PSInput.color = VSInput.color;
#endif


//=:=========:=//
//Var,Vec,..   //
//=:=========:=//

float2 itsnight = float2(0.0, 0.0);
float holefog = FOG_COLOR.r+FOG_COLOR.g+FOG_COLOR.b;
float uw = 0.0; //underwater
float3 waves = float3(0.0, 0.0, 0.0);
float3 fixPos;

//calc the Texture we are currently rendering. make *32/*16 so we are able to use a floor function.
float2 tex = floor(float2(VSInput.uv0.x * 32.0, VSInput.uv0.y * 16.0));


//=:=========:=//
//BIG CALC     //
//=:=========:=// 

//is it night?
if(holefog <= 0.4){
	itsnight.r = 1.0;
	itsnight.g = 1.0-holefog*2.5;
}

//check if we are underwater
if(FOG_CONTROL.x <= 0.01){uw = 1.0;}


//=:=========:=//
//CODE         //
//=:=========:=//

#ifdef AS_ENTITY_RENDERER
	#ifdef INSTANCEDSTEREO
		int i = VSInput.instanceID;
		PSInput.position = mul(WORLDVIEWPROJ_STEREO[i], float4(VSInput.position, 1));
		PSInput.instanceID = i;
	#else
		PSInput.position = mul(WORLDVIEWPROJ, float4(VSInput.position, 1));
	#endif
		float3 worldPos = PSInput.position;
#else
		float3 worldPos = (VSInput.position.xyz * CHUNK_ORIGIN_AND_SCALE.w) + CHUNK_ORIGIN_AND_SCALE.xyz;
	
		// Transform to view space before projection instead of all at once to avoid floating point errors
		// Not required for entities because they are already offset by camera translation before rendering
		// World position here is calculated above and can get huge
	#ifdef INSTANCEDSTEREO
		int i = VSInput.instanceID;
	
		PSInput.position = mul(WORLDVIEW_STEREO[i], float4(worldPos, 1 ));
		PSInput.position = mul(PROJ_STEREO[i], PSInput.position);
	
		PSInput.instanceID = i;
	#else
		PSInput.position = mul(WORLDVIEW, float4( worldPos, 1 ));
		PSInput.position = mul(PROJ, PSInput.position);
	#endif
#endif

//The 0.0, 0.0, 0.0 point nof the worldPos is always at the position of the Player. We fix it if we calc the VIEW_POS to it.
fixPos = worldPos + VIEW_POS.xyz;
PSInput.fragPos = worldPos;

//Claculate the Screenpos.
PSInput.RealScreenPos = mul(PROJ, mul(WORLDVIEW, float4( worldPos, 1 ))).xyz;

//split it with pos.z so it is not getting smaller in the distance...
PSInput.RealScreenPos.xy /=  PSInput.RealScreenPos.z + 1.0;


//////Wavy Leaves Test!!

#ifdef ALPHA_TEST

	/*if(tex.x >= 0.0 && tex.y >= 0.0){
		float LScale = sin(TIME * 0.1) * cos(TIME);
		float3 WindDirection = float3(-1.0, 1.0, -1.0);
		
		float sw = 1.45; 
		float hw = 0.04 + sin(TIME)/1.0;
		
		waves.xz =  max(0.0, frac(fixPos.y)) * WindDirection * sin(0.6 * floor(fixPos.x) + TIME * sw) * cos(0.6 * floor(fixPos.z) +TIME*sw)*hw;
		
		
		
	}*/
	
	
#endif





///// find distance from the camera

#if defined(FOG) || defined(NEAR_WATER)
	#ifdef FANCY
		float3 relPos = -worldPos;
		float cameraDepth = length(relPos);
		#ifdef NEAR_WATER
			PSInput.cameraDist = cameraDepth / FAR_CHUNKS_DISTANCE;
		#endif
	#else
		float cameraDepth = PSInput.position.z;
		#ifdef NEAR_WATER
			float3 relPos = -worldPos;
			float cameraDist = length(relPos);
			PSInput.cameraDist = cameraDist / FAR_CHUNKS_DISTANCE;
		#endif
	#endif
#endif

	///// apply fog
#ifdef FOG
	
    float fogdis = length(-worldPos.xyz)/(RENDER_DISTANCE*0.75);

    PSInput.fogColor.a = min(1.0, max(0.0,fogdis-(0.7)))*0.767;
    PSInput.fogColor.r = FOG_COLOR.r;
    PSInput.fogColor.g = FOG_COLOR.g;
    PSInput.fogColor.b = FOG_COLOR.b;
	
	//PSInput.fogColor.a *= 1.0 + max(0.0, PSInput.fogColor.a-0.3)*5.0;
	
	PSInput.fogColor = lerp(PSInput.fogColor, float4(FOG_COLOR.rgb, 1.0), min(1.0, max(0.0, (PSInput.fogColor.a - 0.5)*5.0)));
	PSInput.fogColor.a *= PSInput.fogColor.a*2.0;
	
	
	
	if(uw == 1.0){
		fogdis = length(-worldPos.xyz);
		#ifndef NEAR_WATER
		
			float WScale = 2.0 - min(1.9, fogdis*0.1);//min(1.0, 1.0 - fogdis * 0.5);
		
			waves.x = sin(worldPos.x * WScale + TIME * 0.5) * sin(worldPos.z * WScale + TIME * 0.5) * max(0.0, fogdis - 3.0)*0.1;
			waves.z = waves.x;
		#endif
		
    
		PSInput.fogColor.a = max(0.3, min(1.0, fogdis * 0.01));
		PSInput.fogColor.rgb = float3(0.15,0.4,0.8);
		
	}//End of WaterWaves	
	
	
#endif



#ifdef NEAR_WATER

if(WaterWaves){
waves.y = sin(1.0 * fixPos.z + TIME * speedwav) * sin(1.1 * fixPos.x + TIME * speedwav)*0.08; 
}//End of WaterWaves	


#ifdef FANCY  /////enhance water
	float F = dot(normalize(relPos), UNIT_Y);
	F = 1.0 - max(F, 0.1);
	F = 1.0 - lerp(F*F*F*F, 1.0, min(1.0, cameraDepth / FAR_CHUNKS_DISTANCE));

	PSInput.color.rg -= float2(float(F * DIST_DESATURATION).xx);

	float4 depthColor = float4(1.0, 1.0, 1.0, 1.0);
	float4 traspColor = float4(1.0, 1.0, 1.0, 0.3 + waves.y);
	float4 surfColor = float4(1.0, 1.0, 1.0, 1.0);

	float4 nearColor = lerp(traspColor, depthColor, PSInput.color.a);
	PSInput.color = lerp(surfColor, nearColor, max(0.0, 1.0 - length(relPos)*0.01));
#else
	PSInput.color.a = PSInput.position.z / FAR_CHUNKS_DISTANCE + 0.5;
#endif //FANCY
#endif

#ifndef AS_ENTITY_RENDERER
		worldPos += waves;
	
	#ifdef INSTANCEDSTEREO
		i = VSInput.instanceID;
	
		PSInput.position = mul(WORLDVIEW_STEREO[i], float4(worldPos, 1 ));
		PSInput.position = mul(PROJ_STEREO[i], PSInput.position);
	
		PSInput.instanceID = i;
	#else
		PSInput.position = mul(WORLDVIEW, float4(worldPos, 1 ));
		PSInput.position = mul(PROJ, PSInput.position);
	#endif
#endif

}
