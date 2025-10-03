plugins {
    id("java")
}

group = "de.linusdev"
version = "unspecified"

repositories {
    mavenCentral()
}

dependencies {
    implementation("de.linusdev:data:2.1.0")
    implementation("net.lingala.zip4j:zip4j:2.11.5")

}
