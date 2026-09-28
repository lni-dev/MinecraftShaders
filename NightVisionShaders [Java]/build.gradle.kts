import com.matthewprenger.cursegradle.CurseArtifact
import com.matthewprenger.cursegradle.CurseProject
import com.matthewprenger.cursegradle.CurseRelation
import de.linusdev.CreatePackReleaseTask
import de.linusdev.Pack
import java.util.Properties

plugins {
    id("base")
    id("com.modrinth.minotaur").version("2.+")
    id("com.matthewprenger.cursegradle").version("+")
}

// Load secrets from gradle-secrets.properties
val secretsFile = rootProject.file("gradle-secrets.properties")
val secrets = Properties()
secretsFile.inputStream().use { secrets.load(it) }

val pack: Pack = Pack.readPackInfo(project)
val taskProvider = tasks.register<CreatePackReleaseTask>("create release")

tasks.register("release") {
    dependsOn(taskProvider.get())
    dependsOn(tasks.named("modrinth"))
    dependsOn(tasks.named("curseforge"))
}

if(secrets["modrinthToken"] != null && pack.modrinthProjectId != null) {

    tasks.named("modrinth") {
        dependsOn(taskProvider.get())
    }

    modrinth {
        token.set(secrets["modrinthToken"] as String)
        projectId.set(pack.modrinthProjectId)

        versionNumber.set(pack.version)
        versionName.set(pack.constructVersionName())
        versionType.set(pack.releaseType.name)
        changelog.set(pack.changelog)
        uploadFile.set(taskProvider.get().packReleaseZipFile)

        gameVersions.addAll(pack.supportedMcVersions)
        loaders.add("vanilla")
        dependencies {
            optional.project("G8yJPRdl")
        }
    }
}

if(secrets["curseForgeToken"] != null && pack.curseforgeProjectId != null) {

    tasks.named("curseforge") {
        dependsOn(taskProvider.get())
    }

    curseforge {
        apiKey = secrets["curseForgeToken"]
        project(closureOf<CurseProject> {
            id = pack.curseforgeProjectId
            releaseType = pack.releaseType.name
            changelog = pack.changelog
            changelogType = "markdown"


            pack.supportedMcVersionsShort.forEach {
                addGameVersion(it)
            }
            mainArtifact(taskProvider.get().outputs
                .files
                .filter { it.path.endsWith(".zip") }
                .singleFile, closureOf<CurseArtifact> {
                displayName = pack.constructVersionName()
            })
        })
    }
}

