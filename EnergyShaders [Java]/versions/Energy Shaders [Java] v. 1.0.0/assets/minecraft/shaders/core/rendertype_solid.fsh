#version 150

#moj_import <fog.glsl>
#moj_import "compatibility.glsl"
#moj_import "settings.glsl"
#moj_import "tonemaps.glsl"
#moj_import "ambient.glsl"
#moj_import "dimension.glsl"

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec2 textCoord2;
in vec4 normal;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;

    if (color.a < 0.1) {
        discard;
    }

    vec2 uv1 = textCoord2 / 256.;

    //Day-Night-Detection
    //doesnt work on java. The light Sampler probably changed. Or it was different on bedrock to begin with
    //I rather wait until 1.17 is properly released and then check the light curve texture on the minecraft wiki (https://minecraft.gamepedia.com/Light)
    vec4 sky_color = texelFetch(Sampler2, ivec2(0, 16), 0);
    vec4 mTime = vec4(sky_color.r, abs(sky_color.r - 0.5), 0.0/*getRain()*/, min(1.0, (1.0 - sky_color.r)*1.5));	//DAY-NIGHT, SUNSET, RAIN, NIGHT-DAY
    float mLight = (max(0.0, mTime.x + uv1.x));
    float mCave = min(1.0, max(0.0, SHADOW_WIDTH - uv1.y) * (1.0 / SHADOW_WIDTH) * 1.5);
    mCave = max(0.0, mCave - 0.2) * 1.25;
    mCave *= 2.0;
    mCave = min(1.0, mCave);
    float shadow = 0.0;

    //dimension is not working yet. same issue as above
    mTime.w = dimension(Sampler2, mTime.w); //mTime.w now also stores the dimension: 0-1 Overworld, 2: Nether, 3: End
    bool nether = mTime.w == 2.0;
    bool end = mTime.w == 3.0;

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

    //diffuse
    //screenPosition
    //shadow from 0.0(no shadow) - 1.0(full shadow)
    //light from 0.0(no light) - 1.0(light)
    //nightDay from 1.0(night) - 0.0(day)
    //rain 0.0(no rain) - 1.0(rain)
    //Nether
    //end
    //darkness 0.0(no darkness) - 1.0(darkness)
    //N normal vector
    color = Ambient(color, vec3(0.0), shadow, uv1.x, 0.0, false, false, 0.0, mCave, normal.xyz);

    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
