import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

dependencies {
    implementation("org.pytorch:pytorch_android:1.13.1")
    implementation("org.pytorch:pytorch_android_torchvision:1.13.1")
}

configurations.all {
    resolutionStrategy {
        force("androidx.activity:activity:1.9.3")
    }
}

android {
    namespace = "com.example.agristack"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.agristack"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Logic to resolve Google Maps API Key:
        // 1. Environment variable (CI/CD or shell)
        // 2. Gradle property (command line -P)
        // 3. key.properties (local file fallback)
        // 4. Fallback to empty string
        val mapsApiKey = System.getenv("GOOGLE_MAPS_API_KEY")
            ?: project.findProperty("GOOGLE_MAPS_API_KEY")
            ?: project.findProperty("GOOGLE_MAPS_API_KEY_RELEASE")
            ?: ""
            
        manifestPlaceholders["GOOGLE_MAPS_API_KEY"] = mapsApiKey.toString()
    }

    signingConfigs {
        create("release") {
            val keyAliasProp = keystoreProperties["keyAlias"] as? String
            val keyPasswordProp = keystoreProperties["keyPassword"] as? String
            val storeFileProp = keystoreProperties["storeFile"] as? String
            val storePasswordProp = keystoreProperties["storePassword"] as? String

            if (keyAliasProp != null && keyPasswordProp != null && storeFileProp != null && storePasswordProp != null) {
                keyAlias = keyAliasProp
                keyPassword = keyPasswordProp
                storeFile = file(storeFileProp)
                storePassword = storePasswordProp
            } else {
                println("Release signing configuration missing or incomplete in key.properties.")
            }
        }
    }

    buildTypes {
        debug {
             val mapsApiKeyDebug = System.getenv("GOOGLE_MAPS_API_KEY")
                ?: project.findProperty("GOOGLE_MAPS_API_KEY")
                ?: project.findProperty("GOOGLE_MAPS_API_KEY_DEBUG")
                ?: ""
            manifestPlaceholders["GOOGLE_MAPS_API_KEY"] = mapsApiKeyDebug.toString()
        }
        release {
            if (signingConfigs.findByName("release")?.storeFile != null) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

flutter {
    source = "../.."
}