#include "ShaderConstants.fxh"

struct VS_Input
{
    float3 position : POSITION;
    float2 uv : TEXCOORD_0;
#ifdef INSTANCEDSTEREO
	uint instanceID : SV_InstanceID;
#endif
};


struct PS_Input
{
    float4 position : SV_Position;
    float3 fragPos : POSI;
    float2 uv : TEXCOORD_0;
#ifdef INSTANCEDSTEREO
	uint instanceID : SV_InstanceID;
#endif
};


void main( in VS_Input VSInput, out PS_Input PSInput )
{
    PSInput.uv = VSInput.uv;

    PSInput.fragPos = VSInput.position.xyz * float3(2.5, 1.0, 2.5);



#ifdef INSTANCEDSTEREO
	int i = VSInput.instanceID;
	PSInput.position = mul( WORLDVIEWPROJ_STEREO[i], float4( PSInput.fragPos, 1 ) );
	PSInput.instanceID = i;
#else
	PSInput.position = mul(WORLDVIEWPROJ, float4( PSInput.fragPos, 1 ));
#endif
}
