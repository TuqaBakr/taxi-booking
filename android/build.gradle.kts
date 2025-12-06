buildscript {
    repositories {
        google()       // ✅ Needed for Google dependencies
        mavenCentral() // ✅ Needed for other libraries
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.2.1") // or your AGP version
        classpath("com.google.gms:google-services:4.3.15") // ✅ Google Services plugin
        classpath("com.google.firebase:firebase-appdistribution-gradle:4.0.0") // optional, for App Distribution
    }
}


allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}


