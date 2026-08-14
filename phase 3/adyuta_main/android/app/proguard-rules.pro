# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Supabase
-keep class com.supabase.** { *; }

# Local Auth & Biometrics
-keep class io.flutter.plugins.localauth.** { *; }
-keep class androidx.biometric.** { *; }

# Secure Storage
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Hive
-keep class com.hive.** { *; }

# Background Service
-keep class id.flutter.flutter_background_service.** { *; }

-dontwarn io.flutter.embedding.**
-ignorewarnings
