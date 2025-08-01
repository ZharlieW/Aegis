#!/bin/bash

echo "🚀 Android Development Helper"
echo "============================="

# Function to fix APK filename issue
fix_apk_filename() {
    local apk_dir="build/app/outputs/flutter-apk"
    local correct_apk="app-debug.apk"
    local incorrect_apk="app--debug.apk"
    
    if [ -f "$apk_dir/$correct_apk" ]; then
        echo "✅ Found $correct_apk"
        
        cd "$apk_dir"
        
        # Remove existing symbolic link if it exists
        if [ -L "$incorrect_apk" ]; then
            echo "🔄 Removing existing symbolic link..."
            rm "$incorrect_apk"
        fi
        
        # Create new symbolic link
        echo "🔗 Creating symbolic link $incorrect_apk -> $correct_apk"
        ln -sf "$correct_apk" "$incorrect_apk"
        
        echo "✅ APK filename fixed for Android Studio"
        cd - > /dev/null
    else
        echo "❌ $correct_apk not found"
        return 1
    fi
}

# Function to build and fix APK
build_and_fix() {
    echo "🔨 Building APK..."
    flutter build apk --debug
    
    if [ $? -eq 0 ]; then
        echo "✅ APK built successfully"
        fix_apk_filename
    else
        echo "❌ Failed to build APK"
        exit 1
    fi
}

# Function to clean and rebuild
clean_and_rebuild() {
    echo "🧹 Cleaning project..."
    flutter clean
    flutter pub get
    
    build_and_fix
}

# Function to run on device
run_on_device() {
    local device_id="${1:-emulator-5554}"
    
    echo "📱 Running on device: $device_id"
    flutter run -d "$device_id"
}

# Function to show available devices
show_devices() {
    echo "📱 Available devices:"
    flutter devices
}

# Main script logic
case "${1:-help}" in
    "fix")
        fix_apk_filename
        ;;
    "build")
        build_and_fix
        ;;
    "rebuild")
        clean_and_rebuild
        ;;
    "run")
        run_on_device "$2"
        ;;
    "devices")
        show_devices
        ;;
    "help"|*)
        echo "Usage: $0 [command] [options]"
        echo ""
        echo "Commands:"
        echo "  fix     - Fix APK filename for Android Studio"
        echo "  build   - Build APK and fix filename"
        echo "  rebuild - Clean, rebuild, and fix"
        echo "  run     - Run on device (default: emulator-5554)"
        echo "  devices - Show available devices"
        echo "  help    - Show this help message"
        echo ""
        echo "Examples:"
        echo "  $0 fix                    # Fix APK filename"
        echo "  $0 build                  # Build and fix"
        echo "  $0 run                    # Run on default device"
        echo "  $0 run emulator-5554      # Run on specific device"
        ;;
esac 