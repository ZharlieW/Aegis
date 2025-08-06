#!/bin/bash

echo "Fixing iOS build configuration - Restoring Flutter expected format..."

# Backup current file
cp ios/Runner.xcodeproj/project.pbxproj ios/Runner.xcodeproj/project.pbxproj.current_backup

# Use sed command to restore build configuration names to Flutter expected format
sed -i '' 's/name = "Debug-Runner";/name = Debug;/g' ios/Runner.xcodeproj/project.pbxproj
sed -i '' 's/name = "Release-Runner";/name = Release;/g' ios/Runner.xcodeproj/project.pbxproj
sed -i '' 's/name = "Profile-Runner";/name = Profile;/g' ios/Runner.xcodeproj/project.pbxproj

echo "Build configuration fixed, now you can run: flutter run" 