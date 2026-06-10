import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val keystoreProperties =
    Properties()

val keystoreFile =
    rootProject.file(
        "key.properties"
    )

if (
    keystoreFile.exists()
) {

    keystoreProperties.load(

        keystoreFile
            .inputStream()
    )
}

android {

    namespace =
        "com.example.edumate"

    compileSdk =
        flutter.compileSdkVersion

    defaultConfig {

        applicationId =
            "com.example.edumate"

        minSdk =
            flutter.minSdkVersion

        targetSdk =
            flutter.targetSdkVersion

        versionCode =
            flutter.versionCode

        versionName =
            flutter.versionName
    }

    signingConfigs {

        create(
            "release"
        ) {

            storeFile = file(

                keystoreProperties[
                    "storeFile"
                ] as String
            )

            storePassword =

                keystoreProperties[
                    "storePassword"
                ] as String

            keyAlias =

                keystoreProperties[
                    "keyAlias"
                ] as String

            keyPassword =

                keystoreProperties[
                    "keyPassword"
                ] as String
        }
    }

    buildTypes {

        release {

            signingConfig =
                signingConfigs
                    .getByName(
                        "release"
                    )
        }
    }

    compileOptions {

        sourceCompatibility =
            JavaVersion.VERSION_17

        targetCompatibility =
            JavaVersion.VERSION_17
    }

    kotlinOptions {

        jvmTarget = "17"
    }
}
afterEvaluate {

    tasks.named(
        "assembleDebug"
    ) {

        finalizedBy(
            "copyDebugApk"
        )
    }

    tasks.register<Copy>(
        "copyDebugApk"
    ) {

        from(
            layout.buildDirectory.file(
                "outputs/apk/debug/app-debug.apk"
            )
        )

        into(
            rootProject.rootDir.resolve(
                "../build/app/outputs/flutter-apk"
            )
        )
    }
}

