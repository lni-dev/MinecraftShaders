#ifndef STRUCT_DEFS
    #define STRUCT_DEFS

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

#endif