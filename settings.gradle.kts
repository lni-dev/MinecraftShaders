
rootProject.name = "MinecraftShaders"

include("NightVisionShaders [Java]")
include("EnergyShaders [Java]")

pluginManagement {
    repositories {
        mavenCentral()
        gradlePluginPortal()
    }
}
include("BetterPistonSounds")
