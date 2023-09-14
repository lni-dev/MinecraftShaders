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


static const float rA = 1.0;
static const float rB = 1.0;
static const float3 UNIT_Y = float3(0, 1, 0);
static const float DIST_DESATURATION = 56.0 / 255.0; //WARNING this value is also hardcoded in the water color, don'tchange


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
	float fogCon = FOG_CONTROL.x;
    float fogtoorainy =(1.0 - fogCon)*0.6;
	float fogdis = length(-worldPos.xyz)/(RENDER_DISTANCE*fogCon);
    
    PSInput.fogColor.a = min(1.5,max(0.0,fogdis-(0.65+fogtoorainy)))*0.567;
    PSInput.fogColor.r = FOG_COLOR.r-fogCon;
    PSInput.fogColor.g = FOG_COLOR.g-fogCon;
    PSInput.fogColor.b = FOG_COLOR.b * 1.18 - fogCon;
	
	if(itsnight.r == 1.0){
		PSInput.fogColor.rgb = lerp(PSInput.fogColor.rgb, float3(0.1,0.3,0.6), itsnight.g);
    }
	if(uw == 1.0){
		fogdis = length(-worldPos.xyz)/(RENDER_DISTANCE);
    
		PSInput.fogColor.a = min(0.43,max(0.35,fogdis*10.0));
		PSInput.fogColor.rgb = float3(0.15,0.4,0.8);	
	}
	
#endif


#ifdef NEAR_WATER
#ifdef FANCY  /////enhance water
	float F = dot(normalize(relPos), UNIT_Y);
	F = 1.0 - max(F, 0.1);
	F = 1.0 - lerp(F*F*F*F, 1.0, min(1.0, cameraDepth / FAR_CHUNKS_DISTANCE));

	PSInput.color.rg -= float2(float(F * DIST_DESATURATION).xx);

	float4 depthColor = float4(PSInput.color.rgb * 0.5, 1.0);
	float4 traspColor = float4(PSInput.color.rgb * 0.45, 0.8);
	float4 surfColor = float4(PSInput.color.rgb, 1.0);

	float4 nearColor = lerp(traspColor, depthColor, PSInput.color.a);
	PSInput.color = lerp(surfColor, nearColor, F);
#else
	PSInput.color.a = PSInput.position.z / FAR_CHUNKS_DISTANCE + 0.5;
#endif //FANCY
#endif
}
