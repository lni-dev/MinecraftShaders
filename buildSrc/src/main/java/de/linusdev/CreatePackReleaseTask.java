package de.linusdev;

import de.linusdev.data.so.SOData;
import org.gradle.api.DefaultTask;
import org.gradle.api.file.DirectoryProperty;
import org.gradle.api.file.RegularFileProperty;
import org.gradle.api.provider.Property;
import org.gradle.api.tasks.InputFile;
import org.gradle.api.tasks.OutputDirectory;
import org.gradle.api.tasks.OutputFile;
import org.gradle.api.tasks.TaskAction;

import java.io.IOException;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class CreatePackReleaseTask extends DefaultTask {

    Property<Path> packProjectRoot = getProject().getObjects().property(Path.class)
            .convention(getProject().provider(() ->
                    getProject().getLayout()
                            .getProjectDirectory()
                            .getAsFile()
                            .toPath()
            ));


    Property<Path> packDevVersionFolder = getProject().getObjects().property(Path.class)
            .convention(getProject().provider(() ->
                    Files
                            .list(packProjectRoot.get().resolve("current"))
                            .findFirst()
                            .get()
            ));


    Property<Path> packDevVersionInfoFile = getProject().getObjects().property(Path.class)
            .convention(getProject().provider(() ->
        packDevVersionFolder.get().resolve("pack-info.json")
    ));

    @InputFile
    RegularFileProperty packDevVersionInfoFileInput = getProject().getObjects().fileProperty()
            .convention(getProject().getLayout().file(getProject().provider(() ->
                    packDevVersionInfoFile.get().toFile())
            ));


    Property<Path> packReleaseVersionsFolder = getProject().getObjects().property(Path.class)
            .convention(getProject().provider(() ->
                    packProjectRoot.get().resolve("versions")
    ));


    Property<Pack> pack = getProject().getObjects().property(Pack.class)
            .convention(getProject().provider(() ->
                Pack.readPackInfo(getProject())));

    @OutputDirectory
    DirectoryProperty packReleaseVersionDir = getProject().getObjects().directoryProperty()
            .convention(getProject().provider(() -> {
                var versionDir = packReleaseVersionsFolder.get().resolve(pack.get().name() + " v. " + pack.get().version());
                return getProject().getLayout()
                        .getProjectDirectory()
                        .dir(
                                getProject()
                                        .getLayout()
                                        .getProjectDirectory()
                                        .getAsFile()
                                        .toPath()
                                        .relativize(versionDir)
                                        .toString()
                        );
            }));

    @OutputFile
    RegularFileProperty packReleaseZipFile = getProject().getObjects().fileProperty()
            .convention(
                    getProject().getLayout()
                            .file(
                                    getProject().provider(
                                            () -> packReleaseVersionDir.getAsFile()
                                                    .get().toPath()
                                                    .resolve(pack.get().name() + " v. " + pack.get().version() + ".zip")
                                                    .toFile()
                                    )
                            ));


    @TaskAction
    void execute() throws IOException {
        var versionDir = packReleaseVersionDir.get().getAsFile().toPath();

        if(Files.exists(versionDir) && Files.isDirectory(versionDir) && Files.list(versionDir).count() > 0L) {
            throw new IllegalStateException("This version already exists.");
        }

        // Copy
        Files.walkFileTree(packDevVersionFolder.get(),
                new SimpleFileVisitor<>() {

                    final Path source = packDevVersionFolder.get();
                    final Path target = versionDir;

                    @Override
                    public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs) throws IOException {
                        var relPath = source.relativize(dir);
                        if(!relPath.toString().equals(""))
                            Files.copy(dir, target.resolve(relPath), StandardCopyOption.COPY_ATTRIBUTES);
                        return FileVisitResult.CONTINUE;
                    }

                    @Override
                    public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
                        Files.copy(file, target.resolve(source.relativize(file)), StandardCopyOption.COPY_ATTRIBUTES);
                        return FileVisitResult.CONTINUE;
                    }
                }
        );

        // Zip
        final ZipOutputStream out = new ZipOutputStream( Files.newOutputStream(packReleaseZipFile.getAsFile().get().toPath()));
        Files.walkFileTree(packDevVersionFolder.get(),
                new SimpleFileVisitor<>() {
                    final Path source = packDevVersionFolder.get();

                    @Override
                    public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
                        Path relativePath = source.relativize(file);
                        ZipEntry entry = new ZipEntry(relativePath.toString());

                        out.putNextEntry(entry);
                        Files.copy(file, out);
                        out.closeEntry();

                        return FileVisitResult.CONTINUE;
                    }
                }
        );

        out.close();

    }

    public RegularFileProperty getPackDevVersionInfoFileInput() {
        return packDevVersionInfoFileInput;
    }

    public DirectoryProperty getPackReleaseVersionDir() {
        return packReleaseVersionDir;
    }

    public RegularFileProperty getPackReleaseZipFile() {
        return packReleaseZipFile;
    }
}
