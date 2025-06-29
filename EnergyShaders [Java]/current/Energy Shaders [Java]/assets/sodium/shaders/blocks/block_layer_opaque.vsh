#version 330 core

#import <sodium:include/fog.glsl>
#import <sodium:include/chunk_vertex.glsl>
#import <sodium:include/chunk_matrices.glsl>
#import <sodium:include/chunk_material.glsl>

out vec4 v_Color;
out vec2 v_TexCoord;
out vec2 v_LightCoord;

out float v_MaterialMipBias;
#ifdef USE_FRAGMENT_DISCARD
out float v_MaterialAlphaCutoff;
#endif

out vec3 inChunkPos;
out vec4 inWorldPos;
out vec4 inScreenPos;

uniform int u_FogShape;
uniform vec3 u_RegionOffset;

uniform sampler2D u_LightTex; // The light map texture sampler

uvec3 _get_relative_chunk_coord(uint pos) {
    // Packing scheme is defined by LocalSectionIndex
    return uvec3(pos) >> uvec3(5u, 0u, 2u) & uvec3(7u, 3u, 7u);
}

vec3 _get_draw_translation(uint pos) {
    return _get_relative_chunk_coord(pos) * vec3(16.0);
}

void main() {
    _vert_init();

    inChunkPos = _vert_position.xyz;
    inWorldPos = vec4(_vert_position + u_RegionOffset + _get_draw_translation(_draw_id), 1.0);
    inScreenPos = u_ProjectionMatrix * u_ModelViewMatrix * inWorldPos;

    // Transform the vertex position into model-view-projection space
    gl_Position = inScreenPos;

    // Add the light color to the vertex color, and pass the texture coordinates to the fragment shader
    v_Color = _vert_color;
    v_TexCoord = _vert_tex_diffuse_coord;
    v_LightCoord = _vert_tex_light_coord;

    v_MaterialMipBias = _material_mip_bias(_material_params);
    #ifdef USE_FRAGMENT_DISCARD
    v_MaterialAlphaCutoff = _material_alpha_cutoff(_material_params);
    #endif
}