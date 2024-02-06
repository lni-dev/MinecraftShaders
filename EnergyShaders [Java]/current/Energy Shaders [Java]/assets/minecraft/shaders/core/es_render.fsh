#version 150

#define ES_JAVA

#moj_import <compatibility.glsl>
#moj_import <settings.glsl>

#moj_import <checks.glsl>
#moj_import <tonemaps.glsl>
#moj_import <render.glsl>

uniform sampler2D Sampler0;
uniform sampler2D Sampler1;
uniform sampler2D Sampler2;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform int FogShape;
uniform int ES_RenderInfo;

in vec4 vertexColor;
in vec4 overlayColor;
in vec2 texCoord0;
in vec2 texCoord2;
in vec4 normal;

in VEC3 inChunkPos;
in VEC4 inWorldPos;
in VEC4 inScreenPos;

out VEC4 fragColor;

struct WorldInfo {
    VEC4 colorRaw; // texture(TEXTURE_0, texCoord0) * vertexColor * ColorModulator
    VEC3 normal; // normal vector
    VEC3 screenPos; // pixel position
    VEC3 playerCenteredPos; //position, centered at the players position

    VEC4 fogColor; // color of the background in mc (not the sky)
    float fogStart;
    float fogEnd; // render distance (not really but usefull)
    int fogShape; // 0 = sphere, 1 = cylinder

    float shadow; // (0.0: no shadow - 1.0: max shadow)
    float light; // (0.0: no light - 1.0: max light)
    float time; // (0.0: day - 1.0: night)
    float cave; // (0.0: not in a cave - 1.0: deep in a cave)
    bool nether;
    bool end;
    bool gui;
    bool hasNormal;
};

void main() {
    WorldInfo worldInfo;
    worldInfo.colorRaw = ES_COLOR_RAW;
    worldInfo.normal = ES_NORMAL.xyz;
    worldInfo.hasNormal = ES_RI_HAS_NORMAL;
    worldInfo.screenPos = inScreenPos.xyz;
    worldInfo.playerCenteredPos = inWorldPos.xyz;

    worldInfo.fogColor = ES_IN_FOG_COLOR;
    worldInfo.fogStart = ES_IN_FOG_START;
    worldInfo.fogEnd = ES_IN_FOG_END;
    worldInfo.fogShape = ES_IN_FOG_SHAPE;

    calcDimension(ES_LIGHT_TEXTURE, worldInfo.nether, worldInfo.end);
    worldInfo.gui = worldInfo.fogStart > worldInfo.fogEnd;

    worldInfo.shadow = calcShadow(ES_UV_LIGHT_TEXTURE, worldInfo.hasNormal, worldInfo.normal, worldInfo.nether, worldInfo.end);
    worldInfo.light = calcLight(ES_UV_LIGHT_TEXTURE, worldInfo.normal);
    worldInfo.time = calcTime(ES_LIGHT_TEXTURE);
    worldInfo.cave = calcCave(ES_UV_LIGHT_TEXTURE);

    VEC4 color = worldInfo.colorRaw;

    #ifdef ES_JAVA
        if (ES_RI_DO_ALPHA_CUTOFF && color.a < ES_RI_GET_ALPHA_CUTOFF) {
            discard;
        }
    #endif
    #ifdef ES_SODIUM
        #ifdef DO_ALPHA_CUTOFF
            if (color.a < ALPHA_CUTOFF) {
                discard;
            }
        #endif
    #endif

    #ifdef ES_JAVA
        if(ES_RI_DO_MIX_OVERLAY_COLOR) {
            color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
        }
    #endif

    if(worldInfo.gui) {
        ESRenderGui(color, worldInfo);
    } else if(worldInfo.nether) {
        ESRenderNether(color, worldInfo);
    } else if(worldInfo.end) {
        ESRenderEnd(color, worldInfo);
    } else {
        ESRenderOverworld(color, worldInfo);
    }

    //Debug Stuff
    #ifdef DEBUG_SHOW_ES_LIGHT_TEXTURE
        if(inChunkPos.x > 0.0 && inChunkPos.x < 1.0 && inChunkPos.z > 0.0 && inChunkPos.z < 1.0) {
            color.rgb = texture2D(ES_LIGHT_TEXTURE, CONVERT_LIGHT_UV(inChunkPos.xz)).rgb;
        }

        if(inChunkPos.x > 1.0 && inChunkPos.x < 1.1 && inChunkPos.z > 0.0 && inChunkPos.z < 1.0) {
            color.rgb = VEC3(0.0, 0.0, inChunkPos.z);
        }

        if(inChunkPos.z > 1.0 && inChunkPos.z < 1.1 && inChunkPos.x > 0.0 && inChunkPos.x < 1.0) {
            color.rgb = VEC3(inChunkPos.x, 0.0, 0.0);
        }
    #endif

    #ifdef DEBUG_SHOW_TIME
        float value = worldInfo.time; //clamp(worldInfo.fogEnd, 0.0, 1.0); //
        if(inChunkPos.x < 16.0 && inChunkPos.x > 15.9 && inChunkPos.z > 0.0 && inChunkPos.z < 1.0) {
            color.rgb = VEC3(inChunkPos.z);

            if(inChunkPos.z-0.025 < value && inChunkPos.z+0.025 > value) {
                color.rgb = VEC3(0., 1., 0.);
            }
        }
    #endif

    #ifdef DEBUG_SHOW_NORMAL
        if(worldInfo.hasNormal) color.rgba = VEC4(abs(normal.rgb), 1.0);
        else color.rgba = VEC4(VEC3(0.0), 1.0);
    #endif

    ES_COLOR_OUT = color;
}
