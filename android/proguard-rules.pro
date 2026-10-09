# Required by ZEGO: MethodChannel calls use Java reflection and JNI.
# R8 must retain SDK classes, method names, and native entry points.
-keep class **.zego.** { *; }
