#!/bin/bash

echo "Fixing iOS build configuration..."

# Backup original file
cp ios/Runner.xcodeproj/project.pbxproj ios/Runner.xcodeproj/project.pbxproj.backup

# Use sed command to rename build configurations
sed -i '' 's/name = Debug;/name = "Debug-Runner";/g' ios/Runner.xcodeproj/project.pbxproj
sed -i '' 's/name = Release;/name = "Release-Runner";/g' ios/Runner.xcodeproj/project.pbxproj
sed -i '' 's/name = Profile;/name = "Profile-Runner";/g' ios/Runner.xcodeproj/project.pbxproj

echo "Build configuration fixed, now you can run: flutter run --flavor Runner" 