#!/bin/bash
set -e

APP_NAME="aegis"
APP_PATH="build/macos/Build/Products/Release/aegis.app"
DMG_NAME="${APP_NAME}"
OUTPUT_DIR="build/macos/Build/Products/Release/"

if [ ! -d "$APP_PATH" ]; then
  echo "Error: Application not found at $APP_PATH"
  exit 1
fi

flutter build macos --release

APP_PATH="build/macos/Build/Products/Release/aegis.app"

# Create a temporary folder for DMG contents
TEMP_DMG_DIR="build/macos/Build/Products/Release/dmg_contents"
mkdir -p "$TEMP_DMG_DIR"

# Copy the app to the temporary folder
cp -R "$APP_PATH" "$TEMP_DMG_DIR/"

echo "Creating DMG using hdiutil..."
# Create DMG using hdiutil (more reliable than create-dmg)
hdiutil create -volname "$APP_NAME" -srcfolder "$TEMP_DMG_DIR" -ov -format UDZO "$OUTPUT_DIR/$DMG_NAME.dmg"

# Clean up temporary folder
rm -rf "$TEMP_DMG_DIR"

echo "DMG file created successfully: $OUTPUT_DIR/$DMG_NAME.dmg"