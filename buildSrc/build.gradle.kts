plugins {
    id("java")
}

group = "de.linusdev"
version = "unspecified"

repositories {
    mavenCentral()
}

dependencies {
    implementation("de.linusdev:data:+")
    implementation("net.lingala.zip4j:zip4j:2.11.5")

}
