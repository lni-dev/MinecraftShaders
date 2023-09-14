#include "ShaderConstants.fxh"
#include "util.fxh"

struct PS_Input
{
    float4 position : SV_Position;
    float3 fragPos : POSI;
    float2 uv : TEXCOORD_0_FB_MSAA;
};

struct PS_Output
{
    float4 color : SV_Target;
};

void main( in PS_Input PSInput, out PS_Output PSOutput )
{
/*#if !defined(TEXEL_AA) || !defined(TEXEL_AA_FEATURE) || (VERSION < 0xa000 /*D3D_FEATURE_LEVEL_10_0*//*)
	float4 diffuse = TEXTURE_0.Sample(TextureSampler0, PSInput.uv);
#else
	float4 diffuse = texture2D_AA(TEXTURE_0, TextureSampler0, PSInput.uv);
#endif

#ifdef ALPHA_TEST
    if( diffuse.a < 0.5 )
    {
        discard;
    }
#endif*/

float4 diffuse = float4(FOG_COLOR.rgb, 1.0);

diffuse.r *= 2.0;

float magicValueToFixSomeShitDonNotDeleteThisExtremlyMagicalAndImportValue = 2.0;

float l_big = max(0.0, (1.0 - length(PSInput.fragPos.xz)) * max(0.0, 1.0 - length(PSInput.fragPos.xz*2.0)));;
float l_small = max(0.0, 1.0 - length(PSInput.fragPos.xz)*5.0);

diffuse.rgb *= l_big;
diffuse.rgb = min(float3(1.0, 1.0, 1.0), diffuse.rgb);
diffuse.a = 1.0;

if(FOG_COLOR.r * FOG_COLOR.b < 0.1){
  diffuse.rgb = float3(l_small, l_small, l_small) * 1.5;
  diffuse.rgb += float3(l_big, l_big, l_big)*1.15;
}

    PSOutput.color = CURRENT_COLOR * diffuse;
}
