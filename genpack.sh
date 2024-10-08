ANDROID_BUILD_TOOLS_VER=$ANDROID_SDK_ROOT/build-tools/34.0.0
export PATH=$ANDROID_BUILD_TOOLS_VER:$PATH

#packaging into apk
aapt package -f -M AndroidManifest.xml -I $ANDROID_SDK_ROOT/platforms/android-30/android.jar -S res -F apk-unaligned.apk apk

#zipalign to read data directly not copy
zipalign -f 4 apk-unaligned.apk apk-unsigned.apk

#generate our keystore
if [ ! -f $(realpath .)/my-release-key.keystore  ]; then
keytool -genkey -v -keystore my-release-key.keystore -alias my-release-key -keyalg RSA -keysize 2048 -validity 100000
fi

#put our signature
apksigner sign --ks $(realpath .)/my-release-key.keystore --ks-key-alias=my-release-key --out apk-signed.apk apk-unsigned.apk
