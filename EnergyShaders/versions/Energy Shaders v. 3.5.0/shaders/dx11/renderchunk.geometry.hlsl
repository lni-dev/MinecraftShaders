#include "ShaderConstants.fxh"

struct GeometryShaderInput
{
	float4			pos				: SV_POSITION;
	float3			fragPos			: POSI;
	float3			RealScreenPos			: SPOSI;
#ifndef BYPASS_PIXEL_SHADER
	lpfloat4		color				: COLOR;
	snorm float2		uv0				: TEXCOORD_0;
	snorm float2		uv1				: TEXCOORD_1;
#endif
#ifdef NEAR_WATER
	float 			cameraDist 			: TEXCOORD_2;
#endif
#ifdef FOG
	float4				fogColor		: FOG_COLOR;
#endif
#ifdef INSTANCEDSTEREO
	uint				instanceID		: SV_InstanceID;
#endif
};

// Per-pixel color data passed through the pixel shader.
struct GeometryShaderOutput
{
	float4				pos				: SV_POSITION;
	float3				fragPos			: POSI;
	float3				RealScreenPos	: SPOSI;
#ifndef BYPASS_PIXEL_SHADER
	lpfloat4			color			: COLOR;
	snorm float2		uv0				: TEXCOORD_0;
	snorm float2		uv1				: TEXCOORD_1;
#endif
#ifdef NEAR_WATER
	float 			cameraDist 			: TEXCOORD_2;
#endif
#ifdef FOG
	float4				fogColor		: FOG_COLOR;
#endif
#ifdef INSTANCEDSTEREO
	uint				renTarget_id : SV_RenderTargetArrayIndex;
#endif
};






/*
ID3D11Buffer*   g_pConstantBuffer11 = NULL;

// Define the constant data used to communicate with shaders.
struct VS_CONSTANT_BUFFER
{                            
    XMFLOAT4 vSomeVectorThatMayBeNeededByASpecificShader;
    float fSomeFloatThatMayBeNeededByASpecificShader;
} VS_CONSTANT_BUFFER;

// Supply the vertex shader constant data.
VS_CONSTANT_BUFFER VsConstData;
VsConstData.vSomeVectorThatMayBeNeededByASpecificShader = XMFLOAT4(1,2,3,4);
VsConstData.fSomeFloatThatMayBeNeededByASpecificShader = 3.0f;

// Fill in a buffer description.
D3D11_BUFFER_DESC cbDesc;
cbDesc.ByteWidth = sizeof( VS_CONSTANT_BUFFER );
cbDesc.Usage = D3D11_USAGE_DYNAMIC;
cbDesc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
cbDesc.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
cbDesc.MiscFlags = 0;
cbDesc.StructureByteStride = 0;

// Fill in the subresource data.
D3D11_SUBRESOURCE_DATA InitData;
InitData.pSysMem = &VsConstData;
InitData.SysMemPitch = 0;
InitData.SysMemSlicePitch = 0;

// Create the buffer.
hr = g_pd3dDevice->CreateBuffer( &cbDesc, &InitData, 
                                 &g_pConstantBuffer11 );

if( FAILED( hr ) )
   return hr;

// Set the buffer.
g_pd3dContext->VSSetConstantBuffers( 0, 1, &g_pConstantBuffer11 );
*/













bool inBounds(float3 worldPos)
{
	bool inBounds = true;
	if (worldPos.x < CHUNK_CLIP_MIN.x ||
		worldPos.x > CHUNK_CLIP_MAX.x ||
		worldPos.z < CHUNK_CLIP_MIN.y ||
		worldPos.z > CHUNK_CLIP_MAX.y)
	{
		inBounds = false;
	}

	return inBounds;
}

// passes through the triangles, except changint the viewport id to match the instance
[maxvertexcount(3)]
void main(triangle GeometryShaderInput input[3], inout TriangleStream<GeometryShaderOutput> outStream)
{
	GeometryShaderOutput output = (GeometryShaderOutput)0;

#ifdef INSTANCEDSTEREO
	int i = input[0].instanceID;
#endif
	{
		for (int j = 0; j < 3; j++)
		{
			output.pos = input[j].pos;
#ifndef BYPASS_PIXEL_SHADER
			output.color			= input[j].color;
			output.uv0				= input[j].uv0;
			output.uv1				= input[j].uv1;
#endif
#ifdef NEAR_WATER
			output.cameraDist		= input[j].cameraDist;
#endif

#ifdef INSTANCEDSTEREO
			output.renTarget_id = i;
#endif

#ifdef FOG
			output.fogColor			= input[j].fogColor;
#endif
			outStream.Append(output);
		}
	}
}