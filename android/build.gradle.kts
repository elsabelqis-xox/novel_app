// D:\project\novel_app\android\app\build.gradle.kts

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // Ini adalah plugin Flutter yang mungkin ada atau tidak, tergantung konfigurasi.
    // id("dev.flutter.flutter-plugin") 
}

android {
    // BARIS ndkVersion AKAN KAMU TAMBAHKAN DI SEKITAR SINI.
    // Posisinya sejajar dengan properti seperti compileSdk atau namespace.

    namespace = "com.example.novel_app" // Contoh, sesuaikan dengan namespace proyekmu
    compileSdk = flutter.compileSdkVersion // Ini mungkin sudah ada

    // --- MULAI TAMBAHKAN DARI SINI ---
    ndkVersion = "27.0.12077973" // <--- INI BARIS YANG HARUS DITAMBAHKAN
    // --- AKHIR TAMBAHKAN SAMPAI SINI ---

    defaultConfig {
        applicationId = "com.example.novel_app" // Contoh, sesuaikan
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            signingConfig = debugSigningConfig
        }
    }

    // Pastikan blok ini juga ada dan di luar blok defaultConfig atau buildTypes
    // tapi masih di dalam blok android {}
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    kotlinOptions {
        jvmTarget = '1.8'
    }
}

flutter {
    source="../.."
}

dependencies {
    // ... (dependensi yang sudah ada di proyekmu)
}