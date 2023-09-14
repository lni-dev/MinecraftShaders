#version 150

#moj_import <fog.glsl>
#moj_import "compatibility.h"
#moj_import "checks.h"
#moj_import "settings.h"
#moj_import "tonemaps.h"
#moj_import "normal.h"
#moj_import "dimension.h"

#moj_import "ambient.h"
#moj_import "fog.h"



uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec4 normal;

in vec2 texCoord2;
in vec3 inChunkPos;
in vec4 inWorldPos;
in vec4 inScreenPos;
//WARNING: these are not the same dimensions as on bedrock!

out vec4 fragColor;

void main() {

  //vec2 uv0 = texCoord0;
  //vec2 uv1 = texCoord2 / 256.0;

  //texture on Sampler2 is different then in bedrock, clamp required!
  //no FOG_CONTROL on Java
  vec4 sky_color = texture2D(TEXTURE_1, CONVERT_LIGHT_UV(vec2(0.0, 1.0)));
  vec4 mTime = vec4(sky_color.r, abs(sky_color.r - 0.5), getRain(FogStart, FogEnd), min(1.0, (1.0 - sky_color.r)*1.5));	//DAY-NIGHT, SUNSET, RAIN, NIGHT-DAY
  float mLight = (max(0.0, mTime.x + uv1.x));
  float mCave = min(1.0, max(0.0, SHADOW_WIDTH - uv1.y) * (1.0 / SHADOW_WIDTH) * 1.5);
  mCave = max(0.0, mCave - 0.2) * 1.25;
  mCave *= 2.0;
  mCave = min(1.0, mCave);
  vec3 N = calculateSurfaceNormal(inChunkPos.xyz);
  float shadow = 0.0;
  mTime.w = dimension(TEXTURE_1, mTime.w); //mTime.w now also stores the dimension: 0-1 Overworld, 2: Nether, 3: End
  bool nether = mTime.w == 2.0;
  bool end = mTime.w == 3.0;

  vec4 color = texture(TEXTURE_0, texCoord0) * vertexColor * ColorModulator;

  if (color.a < 0.1) {
    discard;
  }

  #ifdef SHADOW
	if(uv1.y <= SHADOW_WIDTH){	//if rendering in shadow

		shadow = 1.0;
		if(uv1.y >= SHADOW_WIDTH - FADE_IN_SHADOW_WIDTH){
			#ifdef SHADOW_FADE_IN
				float fadeInE = (uv1.y - (SHADOW_WIDTH - FADE_IN_SHADOW_WIDTH)) * (1.0 / FADE_IN_SHADOW_WIDTH);	//calculate fade in
				shadow = mix(1.0, 0.0, fadeInE);
			#endif
		}
	}
#endif

  color = Ambient(color, inScreenPos.xyz, shadow, uv1.x, mTime.w, nether, end, mTime.z, mCave, N);
  color = Fog(color, inWorldPos.xyz, mTime.w, nether, end, mTime.z, mCave, FOG_COLOR.rgb, FogEnd);

  #ifdef TEST
    color *= 5.0;
  #endif

  fragColor = color;
}
