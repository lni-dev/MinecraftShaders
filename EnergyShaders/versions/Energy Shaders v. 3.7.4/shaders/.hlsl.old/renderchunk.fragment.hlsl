#include "ShaderConstants.fxh"
#include "util.fxh"

struct PS_Input
{
	float4 position : SV_Position;

#ifndef BYPASS_PIXEL_SHADER
	lpfloat4 color : COLOR;
	snorm float2 uv0 : TEXCOORD_0_FB_MSAA;
	snorm float2 uv1 : TEXCOORD_1_FB_MSAA;
	float3	inChunkPos	: POSITION;
	float3			inWorldPos : WPOSITION;
	float3 			inScreenPos : SPOSITION;
	float3 			inBlockPos : BPOSITION;
#endif
};

struct PS_Output
{
	float4 color : SV_Target;
};



ROOT_SIGNATURE
void main(in PS_Input PSInput, out PS_Output PSOutput)
{
#ifdef BYPASS_PIXEL_SHADER
    PSOutput.color = float4(0.0f, 0.0f, 0.0f, 0.0f);
    return;
#else

//Day-Night-Dedection
vec4 sky_color = TEXTURE_1.Sample(TextureSampler1, vec2(0.0, 1.0));
vec4 mTime = vec4(sky_color.r, abs(sky_color.r - 0.5), getRain(), min(1.0, (1.0 - sky_color.r)*1.5));	//DAY-NIGHT, SUNSET, RAIN, NIGHT-DAY
float mLight = (max(0.0, mTime.x + PSInput.uv1.x));
float mCave = min(1.0, max(0.0, SHADOW_WIDTH - PSInput.uv1.y) * (1.0 / SHADOW_WIDTH) * 1.5);
mCave = max(0.0, mCave - 0.2) * 1.25;
mCave *= 2.0;
mCave = min(1.0, mCave);
hvec3 N = calculateSurfaceNormal(PSInput.inChunkPos.xyz);
float shadow = 0.0;
mTime.w = dimension(TEXTURE_1, TextureSampler1, mTime.w); //mTime.w now also stores the dimension: 0-1 Overworld, 2: Nether, 3: End
bool nether = mTime.w == 2.0;
bool end = mTime.w == 3.0;



#if USE_TEXEL_AA
	float4 diffuse = texture2D_AA(TEXTURE_0, TextureSampler0, PSInput.uv0);
#else
	float4 diffuse = TEXTURE_0.Sample(TextureSampler0, PSInput.uv0);
#endif


#ifdef SEASONS_FAR
	diffuse.a = 1.0f;
#endif

#if USE_ALPHA_TEST
	#ifdef ALPHA_TO_COVERAGE
		#define ALPHA_THRESHOLD 0.05
	#else
		#define ALPHA_THRESHOLD 0.5
	#endif
	if(diffuse.a < ALPHA_THRESHOLD)
		discard;
#endif



#ifndef SEASONS
	#if !USE_ALPHA_TEST && !defined(BLEND)
		diffuse.a = PSInput.color.a;
	#endif

	diffuse.rgb *= PSInput.color.rgb;
#endif


#ifdef SHADOW
	if(PSInput.uv1.y <= SHADOW_WIDTH){	//if rendering in shadow

		shadow = 1.0;
		if(PSInput.uv1.y >= SHADOW_WIDTH - FADE_IN_SHADOW_WIDTH){
			#ifdef SHADOW_FADE_IN
				float fadeInE = (PSInput.uv1.y - (SHADOW_WIDTH - FADE_IN_SHADOW_WIDTH)) * (1.0 / FADE_IN_SHADOW_WIDTH);	//calculate fade in
				shadow = mix(1.0, 0.0, fadeInE);
			#endif
		}
		//shadow = max(0.0, shadow - max(0.0, light.x + E_TORCH_LIGHT_OFFSET));
	}
#endif

diffuse = Ambient(TEXTURE_0, TextureSampler0, diffuse, PSInput.inScreenPos /*screenPosition*/, shadow, PSInput.uv1.x/*light*/, mTime.w/*nightDay*/, nether, end, mTime.z/*rain*/, mCave/*darkness*/, N /*Normal*/);

#ifdef BLEND
	vec4 b = TEXTURE_0.Sample(TextureSampler0, PSInput.uv0);
	if(b.r <= 0.01 && b.g <= 0.01 && b.b <= 0.01 && b.a > 0.5 && PSInput.color.a < 0.95){
		//Water stuff
		vec3 waterColor = PSInput.color.rgb;
		diffuse = water(waterColor, PSInput.inWorldPos, CAMERA_OFFSET, shadow, PSInput.uv1.x/*light*/, mTime.w/*nightDay*/, mTime.z/*rain*/, mCave/*darkness*/, N /*Normal*/);
	}

#else
	vec4 b = TEXTURE_0.Sample(TextureSampler0, PSInput.uv0);
	if(b.r <= 0.01 && b.g <= 0.01 && b.b <= 0.01 && length(PSInput.inWorldPos) > FAR_CHUNKS_DISTANCE * 0.9){
		//Water stuff
		vec3 waterColor = PSInput.color.rgb;
		diffuse = water(waterColor, PSInput.inWorldPos, CAMERA_OFFSET, shadow, PSInput.uv1.x/*light*/, mTime.w/*nightDay*/, mTime.z/*rain*/, mCave/*darkness*/, N /*Normal*/);
	}
#endif

diffuse = Fog(diffuse, PSInput.inWorldPos, mTime.w/*nightDay*/, nether, end, mTime.z/*rain*/, mCave/*darkness*/);

	//Debug show TEXTURE_1
	#ifdef DEBUG_SHOW_TEXTURE_1
		if(length(PSInput.inWorldPos.xz) < 2.0){
			vec2 uvTest = (PSInput.inWorldPos.xz);
			if(uvTest.x < 1.0 && uvTest.y < 1.0 && uvTest.x*uvTest.y > 0.0){
				diffuse.rgb = pow(TEXTURE_1.Sample(TextureSampler1, uvTest).rgb, VEC3(1.0));
			}
		}
	#endif

	PSOutput.color = diffuse;

#ifdef VR_MODE
	// On Rift, the transition from 0 brightness to the lowest 8 bit value is abrupt, so clamp to
	// the lowest 8 bit value.
	PSOutput.color = max(PSOutput.color, 1 / 255.0f);
#endif

#endif // BYPASS_PIXEL_SHADER
}
