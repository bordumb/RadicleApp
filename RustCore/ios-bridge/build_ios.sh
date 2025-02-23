#!/usr/bin/env bash
set -e

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HEADER_PATH="$BASE_DIR/include"

BRIDGE_PATH="$BASE_DIR/Cargo.toml"
BUILD_DIR="$BASE_DIR/build/ios"

# Ensure output directory exists
mkdir -p "$BUILD_DIR"

echo "🔧 Building Heartwood iOS bridge for device (arm64)..."
cargo build --manifest-path "$BRIDGE_PATH" --target aarch64-apple-ios --release

echo "🔧 Building Heartwood iOS bridge for Intel-based simulator (x86_64)..."
cargo build --manifest-path "$BRIDGE_PATH" --target x86_64-apple-ios --release

echo "🔧 Building Heartwood iOS bridge for Apple Silicon simulator (arm64-sim)..."
cargo build --manifest-path "$BRIDGE_PATH" --target aarch64-apple-ios-sim --release

# Paths to built static libraries
LIB_ARM64="$BASE_DIR/target/aarch64-apple-ios/release/libheartwood_ios_bridge.a"
LIB_X86_64="$BASE_DIR/target/x86_64-apple-ios/release/libheartwood_ios_bridge.a"
LIB_ARM64_SIM="$BASE_DIR/target/aarch64-apple-ios-sim/release/libheartwood_ios_bridge.a"
LIB_SIMULATOR_MERGED="$BUILD_DIR/libheartwood_ios_bridge_sim.a"

# Ensure all libraries exist
if [ ! -f "$LIB_ARM64" ]; then
    echo "❌ Error: $LIB_ARM64 not found! Device build may have failed."
    exit 1
fi

if [ ! -f "$LIB_X86_64" ]; then
    echo "❌ Error: $LIB_X86_64 not found! Simulator build may have failed."
    exit 1
fi

if [ ! -f "$LIB_ARM64_SIM" ]; then
    echo "❌ Error: $LIB_ARM64_SIM not found! Apple Silicon simulator build may have failed."
    exit 1
fi

echo "📦 Merging Simulator Libraries..."
lipo -create -output "$LIB_SIMULATOR_MERGED" "$LIB_X86_64" "$LIB_ARM64_SIM"

echo "📦 Creating XCFramework..."
rm -rf "$BUILD_DIR/Heartwood.xcframework"

xcodebuild -create-xcframework \
    -library "$LIB_ARM64" -headers "$HEADER_PATH" \
    -library "$LIB_SIMULATOR_MERGED" -headers "$HEADER_PATH" \
    -output "$BUILD_DIR/Heartwood.xcframework"

echo "✅ XCFramework created at: $BUILD_DIR/Heartwood.xcframework"
