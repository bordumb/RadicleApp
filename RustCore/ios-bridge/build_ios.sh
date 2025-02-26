#!/usr/bin/env bash
set -e

# Define paths
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BRIDGE_PATH="$BASE_DIR/Cargo.toml"
BUILD_DIR="$BASE_DIR/build/ios"
HEADER_PATH="$BASE_DIR/include/heartwood_bridge.h"

# Generate C header file
echo "📝 Generating heartwood_bridge.h..."
cbindgen --config cbindgen.toml --crate heartwood_ios_bridge --output "$HEADER_PATH"

# Ensure output directory exists
mkdir -p "$BUILD_DIR"

# Build Rust libraries for iOS device and Apple Silicon simulator only
echo "🔧 Building Heartwood iOS bridge for device (arm64)..."
cargo build --manifest-path "$BRIDGE_PATH" --target aarch64-apple-ios --release

echo "🔧 Building Heartwood iOS bridge for Apple Silicon simulator (arm64-sim)..."
cargo build --manifest-path "$BRIDGE_PATH" --target aarch64-apple-ios-sim --release

# Paths to built static libraries
LIB_ARM64="$BASE_DIR/target/aarch64-apple-ios/release/libheartwood_ios_bridge.a"
LIB_ARM64_SIM="$BASE_DIR/target/aarch64-apple-ios-sim/release/libheartwood_ios_bridge.a"

# Verify that all libraries were built
if [ ! -f "$LIB_ARM64" ] || [ ! -f "$LIB_ARM64_SIM" ]; then
    echo "❌ Error: One or more build artifacts are missing."
    exit 1
fi

# Create directories for simulator and device builds inside XCFramework
DEVICE_LIB_DIR="$BUILD_DIR/ios-arm64"
SIMULATOR_LIB_DIR="$BUILD_DIR/ios-arm64-simulator"

mkdir -p "$DEVICE_LIB_DIR/Headers"
mkdir -p "$SIMULATOR_LIB_DIR/Headers"

# Copy the libraries
cp "$LIB_ARM64" "$DEVICE_LIB_DIR/libheartwood_ios_bridge.a"
cp "$LIB_ARM64_SIM" "$SIMULATOR_LIB_DIR/libheartwood_ios_bridge.a"

# ✅ Copy headers into both locations
cp "$HEADER_PATH" "$DEVICE_LIB_DIR/Headers/"
cp "$HEADER_PATH" "$SIMULATOR_LIB_DIR/Headers/"

# Create XCFramework (Apple Silicon only)
echo "📦 Creating XCFramework..."
rm -rf "$BUILD_DIR/Heartwood.xcframework"

xcodebuild -create-xcframework \
    -library "$DEVICE_LIB_DIR/libheartwood_ios_bridge.a" -headers "$DEVICE_LIB_DIR/Headers/" \
    -library "$SIMULATOR_LIB_DIR/libheartwood_ios_bridge.a" -headers "$SIMULATOR_LIB_DIR/Headers/" \
    -output "$BUILD_DIR/Heartwood.xcframework"

echo "✅ XCFramework created at: $BUILD_DIR/Heartwood.xcframework"

# Verify XCFramework contents
ls -lah "$BUILD_DIR/Heartwood.xcframework"
lipo -info "$BUILD_DIR/ios-arm64-simulator/libheartwood_ios_bridge.a"

echo "🎉 Build completed successfully!"
