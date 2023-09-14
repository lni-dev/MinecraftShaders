#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec3 ChunkOffset;
uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 normal;

out vec2 texCoord2;
out vec3 inChunkPos;
out vec4 inWorldPos;
out vec4 inScreenPos;


void main() {
    inChunkPos = Position;
    vec3 pos = Position + ChunkOffset;
    inWorldPos = ModelViewMat * vec4(pos, 1.0);
    inScreenPos = ProjMat * inWorldPos;
    gl_Position = inScreenPos;

    vertexDistance = fog_distance(ModelViewMat, pos, FogShape);
    vertexColor = Color; // * minecraft_sample_lightmap(Sampler2, UV2)*3.;
    texCoord0 = UV0;
    texCoord2 = UV2;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
