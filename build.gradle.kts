plugins {
    id("com.android.application") version "8.7.0" apply false
    id("org.jetbrains.kotlin.android") version "1.5.31" apply false
    id("dev.flutter.flutter-plugin-loader") version "1.0.0" apply false
    id("groovy")
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    apply(plugin = "groovy")

    dependencies {
        "implementation"("org.codehaus.groovy:groovy:3.0.9")
    }

    tasks.withType<JavaCompile> {
        options.encoding = "UTF-8"
        sourceCompatibility = "11"
        targetCompatibility = "11"
    }
}