#!/usr/bin/env bash

# Debugging information
echo "Running appcenter-post-clone.sh"
pwd
ls -R

# Fail if any command fails
set -e
# Debug log
set -x

# Set Java version to 17
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# Check Java version
java -version

# Clone the Flutter repository and set up Flutter
cd ..
git clone -b beta https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH

flutter channel stable
flutter doctor

echo "Installed flutter to `pwd`/flutter"

# Proceed with Flutter build as before
flutter build apk --release
mkdir -p android/app/build/outputs/apk/; mv build/app/outputs/apk/release/app-release.apk $_
