# Google ML Kit uses reflection/JNI to reach these classes at runtime.
# R8 strips them by default in release builds unless kept explicitly,
# which breaks image labeling and translation silently.
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_** { *; }
-dontwarn com.google.mlkit.**
-dontwarn com.google.android.gms.internal.mlkit_**
