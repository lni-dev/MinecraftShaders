#version 150

#moj_import <light.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler1;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec4 vertexColor;
out vec4 overlayColor;
out vec2 texCoord0;
out vec2 texCoord2;

out vec4 normal;

out vec3 inChunkPos;
out vec4 inWorldPos;
out vec4 inScreenPos;
out float projMat3x;

void main() {
    inChunkPos = Position;
    inWorldPos = vec4(Position, 1.0);
    inScreenPos = ProjMat * ModelViewMat * vec4(Position, 1.0);

    gl_Position = inScreenPos;

    vertexColor = Color;
    overlayColor = texelFetch(Sampler1, UV1, 0);
    texCoord0 = UV0;
    texCoord2 = UV2;

    projMat3x = ProjMat[3].x;

    normal = vec4(Normal, 0.0);
}
