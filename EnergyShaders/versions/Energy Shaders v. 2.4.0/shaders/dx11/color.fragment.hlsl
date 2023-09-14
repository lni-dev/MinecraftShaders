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


float getRain(){
  return min(1.0, max(0.0,pow(FOG_CONTROL.y, 5.0))*2.0);
};

min16float unrealPos(min16float x, min16float z, float fact){
  min16float factor = length(float2(x, z));
  
  return fact - factor*15.0;
};

float clacCodeBasedNoiseTexture(float2 a){
  float ca = sin(a.x + TIME*0.1 + a.y - a.x + sin(a.x+TIME*0.1) + cos(a.y + a.y - a.x));
  float cc = sin(a.x+(cos(a.y)*0.1));
  float cd = 0.0;
  
  return ca*1.5*cc;
};

float4 CloudColor(float a, float3 fog){
  float3 cloudColor = float3(1.5, 1.5, 1.5);
  
  cloudColor *= fog*2.0;
  
  cloudColor = lerp(cloudColor, float3(1.3, 0.7, 0.95), max(0.0, fog.r));
  
    //cloudColor *= max(0.7, getRain());
    a -= (1.0 - getRain())*1.5;
  
  cloudColor = min(float3(1.0, 1.0, 1.0), cloudColor);
  
  return float4(cloudColor, min(0.95, a));
};

float2 rando(float2 p){
  float2 np = frac(p * float2(443.897 , 441.423));
  np += dot(np, np.yx + float2(19.19, 19.19));
  np = frac((np.xx + np.yx)* np.xy) * 2.0 - 1.0;
  return np;
};




void main( in PS_Input PSInput, out PS_Output PSOutput )
{	
	
	if(PSInput.is_sky == 10.0){
	float4 cloud = float4(0.0, 0.0, 0.0, 0.0);
	float4 diffuse = PSInput.color;

	min16float x = PSInput.fragPos.x;
	min16float z = PSInput.fragPos.z;
	
	cloud.a = unrealPos(x ,z, 6.0);

	x *= 2.0 * (cloud.a*4.0);
	z *= 2.0 * (cloud.a*4.0);

	z += TIME * 0.05;
	x += TIME * 0.001;
	
	cloud.a = clacCodeBasedNoiseTexture(float2(x, z));
	cloud.a = (lerp(clacCodeBasedNoiseTexture((float2(x, z*0.7))*float2(5.0,5.0)), cloud.a, cloud.a)*max(0.0, cloud.a))*2.0;
	
	
	cloud.a *= 0.2;
	cloud.a -= cloud.a * 0.2 * cloud.a;

	
	cloud.a *= max(0.0, min(1.0, unrealPos(PSInput.fragPos.x, PSInput.fragPos.z, 4.0)));


	
	cloud = CloudColor(cloud.a, FOG_COLOR.rgb);

	diffuse.rgb = lerp(diffuse.rgb, cloud.rgb, max(0.0, min(1.0, cloud.a)));
	
	diffuse.rgb = lerp(diffuse.rgb, FOG_COLOR.rgb, min(1.0, max(0.0, length(float2(PSInput.fragPos.x, PSInput.fragPos.z*0.1))*3.0)));

    PSOutput.color = diffuse;
	}else{
		PSOutput.color = PSInput.color;
	}
}