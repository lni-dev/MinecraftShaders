package de.linusdev;

import de.linusdev.data.parser.exceptions.ParseException;
import de.linusdev.data.so.SOData;
import org.gradle.api.Project;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public record Pack(
        String name,
        String version,
        ReleaseType releaseType,
        List<String> supportedMcVersions,
        List<String> supportedMcVersionsShort,
        String modrinthProjectId,
        String curseforgeProjectId,
        String changelog
) {

    public enum ReleaseType {
        ALPHA("alpha"),
        BETA("beta"),
        RELEASE("release"),
        ;
        public final String name;

        ReleaseType(String name) {
            this.name = name;
        }

        public static ReleaseType ofString(String type) {
            for(var value: values()) {
                if(value.name.equals(type)) {
                    return value;
                }
            }

            throw new IllegalArgumentException(type);
        }
    }

    public static Pack readPackInfo(SOData json, String changelog) {
        SOData pack = json.getContainer("pack").requireNotNull().getAs();

        String name = pack.getAs("name");
        String version = pack.getAs("version");
        ReleaseType releaseType = pack.getContainer("release-type").requireNotNull().castAndConvert(ReleaseType::ofString).get();
        List<String> supportedMcVersions = pack.getListAndConvert("supported-mc-versions", (String s) -> s);
        List<String> supportedMcVersionsShort = pack.getListAndConvert("supported-mc-versions-short", (String s) -> s);
        String modrinthProjectId = pack
                .getContainer("modrinth").requireNotNull()
                .<SOData>getAs().getAs("project-id");

        String curseforgeProjectId = pack
                .getContainer("curseforge").requireNotNull()
                .<SOData>getAs().getAs("project-id");

        return new Pack(name, version, releaseType, supportedMcVersions, supportedMcVersionsShort, modrinthProjectId, curseforgeProjectId, changelog);
    }

    public static Pack readPackInfo(Project project) throws IOException, ParseException {
        Path projRoot = project.getLayout().getProjectDirectory().getAsFile().toPath();
        Path devVersionRoot =  Files.list(projRoot.resolve("current")).findFirst().get();

        Path infoFile = devVersionRoot.resolve("pack-info.json");
        Path changelogFile = devVersionRoot.resolve("changelog.md");

        SOData packInfo = SOData.PARSER.parseStream(Files.newInputStream(infoFile));
        String changelog = Files.readString(changelogFile, StandardCharsets.UTF_8);

        return readPackInfo(packInfo, changelog);
    }

    public String constructVersionName() {
        return name + " v. " + version;
    }
}
