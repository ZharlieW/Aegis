#!/bin/bash

echo "🔧 Android Studio APK Filename Fix"
echo "=================================="

# Function to create symbolic link
create_symbolic_link() {
    local apk_dir="build/app/outputs/flutter-apk"
    local correct_apk="app-debug.apk"
    local incorrect_apk="app--debug.apk"
    
    if [ ! -f "$apk_dir/$correct_apk" ]; then
        echo "❌ $correct_apk not found"
        echo "💡 Building APK first..."
        flutter build apk --debug
    fi
    
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
        
        echo "✅ Symbolic link created successfully"
        echo "📱 Now you can run the app from Android Studio"
        
        # Show the files
        echo "📂 Files in $apk_dir:"
        ls -la
        
        cd - > /dev/null
    else
        echo "❌ Failed to build APK"
        exit 1
    fi
}

# Function to clean up symbolic link
cleanup_symbolic_link() {
    local apk_dir="build/app/outputs/flutter-apk"
    local incorrect_apk="app--debug.apk"
    
    if [ -L "$apk_dir/$incorrect_apk" ]; then
        echo "🧹 Cleaning up symbolic link..."
        rm "$apk_dir/$incorrect_apk"
        echo "✅ Cleanup completed"
    else
        echo "ℹ️  No symbolic link to clean up"
    fi
}

# Main script logic
case "${1:-fix}" in
    "fix")
        create_symbolic_link
        ;;
    "clean")
        cleanup_symbolic_link
        ;;
    "rebuild")
        echo "🔄 Rebuilding APK and fixing symbolic link..."
        flutter clean
        flutter pub get
        create_symbolic_link
        ;;
    *)
        echo "Usage: $0 [fix|clean|rebuild]"
        echo "  fix    - Create symbolic link for Android Studio (default)"
        echo "  clean  - Remove symbolic link"
        echo "  rebuild - Clean, rebuild, and fix"
        exit 1
        ;;
esac 