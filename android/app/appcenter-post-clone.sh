#!/usr/bin/env bash
#Place this script in project/android/app/

# Debugging information
echo "Running appcenter-post-clone.sh"
pwd
ls -R

# Proceed with the original script
cd ..

# fail if any command fails
set -e
# debug log
set -x
java -version   
cd ..
git clone -b beta https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH
flutter channel stable
flutter doctor
echo "Installed flutter to `pwd`/flutter"
# Proceed with Flutter build as before
flutter build apk --release
mkdir -p android/app/build/outputs/apk/; mv build/app/outputs/apk/release/app-release.apk $_