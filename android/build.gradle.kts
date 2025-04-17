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

android {
    compileSdkVersion 33 // หรือเวอร์ชันที่คุณใช้

    defaultConfig {
        // การตั้งค่าปัจจุบันของคุณ
    }

    // เพิ่ม NDK version ที่นี่
    ndkVersion = "27.0.12077973"

    // การตั้งค่าอื่นๆ
    buildTypes {
        release {
            // การตั้งค่าการสร้าง release ของคุณ
        }
    }
}
