import de.linusdev.lutils.color.Color;
import de.linusdev.lutils.color.RGBAColor;
import de.linusdev.lutils.image.Image;
import de.linusdev.lutils.image.java.JavaBackedImage;
import org.w3c.dom.css.RGBColor;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;

public class GlassTextureGenerator {

    public record TexInfo(
            String texName,
            Color outer,
            Color inner
    ){}

    public static ArrayList<TexInfo> texInfos = new ArrayList<>();

    public static void addStainedGlass(String colorName, Color color) {
        RGBAColor c = color.toRGBAColor();
        texInfos.add(new TexInfo(
                colorName + "_stained_glass",
                Color.ofRGBA(c.getRed(), c.getGreen(), c.getBlue(), 224),
                Color.ofRGBA(c.getRed(), c.getGreen(), c.getBlue(), 114)
        ));

        double fac = 0.7;
        texInfos.add(new TexInfo(
                colorName + "_stained_glass_pane_top",
                Color.ofRGBA((int)(c.getRed()*fac), (int)(c.getGreen()*fac), (int)(c.getBlue()*fac), 255),
                Color.ofRGBA((int)(c.getRed()*fac), (int)(c.getGreen()*fac), (int)(c.getBlue()*fac), 255)
        ));
    };

    public static void addTintedGlass(Color color) {
        RGBAColor c = color.toRGBAColor();
        texInfos.add(new TexInfo(
                "tinted_glass",
                Color.ofRGBA(c.getRed(), c.getGreen(), c.getBlue(), 224),
                Color.ofRGBA(c.getRed(), c.getGreen(), c.getBlue(), 144)
        ));
    };

    public static void main(String[] args) throws IOException {
        addStainedGlass("black", Color.ofRGB(25, 25, 25));
        addStainedGlass("blue", Color.ofRGB(51, 76, 177));
        addStainedGlass("brown", Color.ofRGB(101, 76, 51));
        addStainedGlass("cyan", Color.ofRGB(75, 127, 152));
        addStainedGlass("gray", Color.ofRGB(75, 75, 75));
        addStainedGlass("green", Color.ofRGB(102, 127, 50));
        addStainedGlass("light_blue", Color.ofRGB(102, 152, 216));
        addStainedGlass("light_gray", Color.ofRGB(153, 153, 153));
        addStainedGlass("lime", Color.ofRGB(127, 204, 25));
        addStainedGlass("magenta", Color.ofRGB(178, 75, 216));
        addStainedGlass("orange", Color.ofRGB(216, 127, 50));
        addStainedGlass("pink", Color.ofRGB(241, 127, 164));
        addStainedGlass("purple", Color.ofRGB(127, 62, 177));
        addStainedGlass("red", Color.ofRGB(153, 51, 51));
        addStainedGlass("silver", Color.ofRGB(152, 152, 152));
        addStainedGlass("white", Color.ofRGB(254, 254, 254));
        addStainedGlass("yellow", Color.ofRGB(228, 228, 50));
        addTintedGlass(Color.ofRGB(35, 35, 35));

        Path genFolder = Paths.get("../current/BetterClearerGlass/assets/minecraft/textures/block/");

        for (TexInfo texInfo : texInfos) {
            JavaBackedImage image = (JavaBackedImage) Image.create(32, 32);
            for (int x = 0; x < 32; x++) {
                for (int y = 0; y < 32; y++) {
                    if(x == 0 || x == 31 || y == 0 || y == 31) {
                        image.setPixelAsRGBA(x, y, texInfo.outer.toRGBAColor().toRGBAHex());
                    } else {
                        image.setPixelAsRGBA(x, y, texInfo.inner.toRGBAColor().toRGBAHex());
                    }
                }
            }
            Path file = genFolder.resolve(texInfo.texName + ".png");
            if(!Files.exists(file)) Files.createFile(file);
            try (OutputStream outputStream = Files.newOutputStream(file)) {
                image.write(null, outputStream);
            }

        }
    }

}
