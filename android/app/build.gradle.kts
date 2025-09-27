// android/app/build.gradle.kts
plugins {
    id("com.android.application")
    kotlin("android")                  // use kotlin DSL plugin
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.muskmelon_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.example.muskmelon_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        vectorDrawables.useSupportLibrary = true
    }

    buildTypes {
        release {
            // For now keep debug signing so `flutter run --release` works
            signingConfig = signingConfigs.getByName("debug")
            // isMinifyEnabled = false // enable + add proguard rules when ready
        }
    }

    // >>> IMPORTANT: move to Java 17 <<<
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }

    // Helps avoid duplicate license files if you add extra libs later
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

flutter {
    source = "../.."
}
