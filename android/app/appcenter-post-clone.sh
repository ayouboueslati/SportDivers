#!/usr/bin/env bash

# Debugging information
echo "Running appcenter-post-clone.sh"
pwd
ls -R

# Fail if any command fails
set -e
# Debug log
set -x

# Print the current Java version
java -version

# Set JAVA_HOME to Java 17
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
export PATH=$JAVA_HOME/bin:$PATH

# Verify Java version
java -version

# Clone the Flutter repository and set up Flutter
cd ..
git clone -b stable https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH

flutter doctor

echo "Installed flutter to `pwd`/flutter"

# Proceed with Flutter build as before
flutter build apk --release
mkdir -p android/app/build/outputs/apk/; mv build/app/outputs/apk/release/app-release.apk $_
