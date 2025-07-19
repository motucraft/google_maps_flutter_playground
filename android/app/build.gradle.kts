import java.util.Base64

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val dartDefines: Map<String, String> = if (project.hasProperty("dart-defines")) {
    project.property("dart-defines").toString()
        .split(",")
        .map {
            // Base64デコードして、"key=value"の形式に分割
            val decoded = String(Base64.getDecoder().decode(it), Charsets.UTF_8)
            val (key, value) = decoded.split("=")
            key to value
        }.toMap()
} else {
    emptyMap()
}

android {
    namespace = "jp.motucraft.google_maps_flutter_playground"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "jp.motucraft.google_maps_flutter_playground"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        resValue("string", "google_map_api_key", dartDefines["GOOGLE_MAP_API_KEY"] ?: "")
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
