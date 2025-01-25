
plugins {
    id("java")
    id("com.modrinth.minotaur").version("2.+")
    id("com.matthewprenger.cursegradle").version("+")
}

group = "de.linusdev"
version = "unspecified"

repositories {
    mavenCentral()
    mavenLocal()
}

dependencies {
    implementation("de.linusdev:lutils:+")
}

