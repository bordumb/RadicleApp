# #!/usr/bin/env bash
# set -e

# # Generate header file
# cbindgen --config cbindgen.toml --crate heartwood_ios_bridge --output RustCore/ios-bridge/include/heartwood_bridge.h

# # Run Cargo build for iOS
# cargo build --release --target aarch64-apple-ios

# BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# HEADER_PATH="$BASE_DIR/include"

# BRIDGE_PATH="$BASE_DIR/Cargo.toml"
# BUILD_DIR="$BASE_DIR/build/ios"

# # Ensure output directory exists
# mkdir -p "$BUILD_DIR"

# echo "🔧 Building Heartwood iOS bridge for device (arm64)..."
# cargo build --manifest-path "$BRIDGE_PATH" --target aarch64-apple-ios --release

# echo "🔧 Building Heartwood iOS bridge for Intel-based simulator (x86_64)..."
# cargo build --manifest-path "$BRIDGE_PATH" --target x86_64-apple-ios --release

# echo "🔧 Building Heartwood iOS bridge for Apple Silicon simulator (arm64-sim)..."
# cargo build --manifest-path "$BRIDGE_PATH" --target aarch64-apple-ios-sim --release

# # Paths to built static libraries
# LIB_ARM64="$BASE_DIR/target/aarch64-apple-ios/release/libheartwood_ios_bridge.a"
# LIB_X86_64="$BASE_DIR/target/x86_64-apple-ios/release/libheartwood_ios_bridge.a"
# LIB_ARM64_SIM="$BASE_DIR/target/aarch64-apple-ios-sim/release/libheartwood_ios_bridge.a"
# LIB_SIMULATOR_MERGED="$BUILD_DIR/libheartwood_ios_bridge_sim.a"

# # Ensure all libraries exist
# if [ ! -f "$LIB_ARM64" ]; then
#     echo "❌ Error: $LIB_ARM64 not found! Device build may have failed."
#     exit 1
# fi

# if [ ! -f "$LIB_X86_64" ]; then
#     echo "❌ Error: $LIB_X86_64 not found! Simulator build may have failed."
#     exit 1
# fi

# if [ ! -f "$LIB_ARM64_SIM" ]; then
#     echo "❌ Error: $LIB_ARM64_SIM not found! Apple Silicon simulator build may have failed."
#     exit 1
# fi

# echo "📦 Merging Simulator Architectures..."
# lipo -create -output "$LIB_SIMULATOR_MERGED" "$LIB_X86_64" "$LIB_ARM64_SIM"

# echo "📦 Creating XCFramework..."
# rm -rf "$BUILD_DIR/Heartwood.xcframework"

# xcodebuild -create-xcframework \
#     -library "$LIB_ARM64" -headers "$HEADER_PATH" \
#     -library "$LIB_SIMULATOR_MERGED" -headers "$HEADER_PATH" \
#     -output "$BUILD_DIR/Heartwood.xcframework"


# echo "✅ XCFramework created at: $BUILD_DIR/Heartwood.xcframework"

#!/usr/bin/env bash
set -e

# Define paths
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BRIDGE_PATH="$BASE_DIR/Cargo.toml"
BUILD_DIR="$BASE_DIR/build/ios"
HEADER_PATH="$BASE_DIR/include"

# Generate C header file
echo "📝 Generating heartwood_bridge.h..."
cbindgen --config cbindgen.toml --crate heartwood_ios_bridge --output include/heartwood_bridge.h

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

# Create directory for Apple Silicon simulator libraries
SIMULATOR_LIB_DIR="$BUILD_DIR/ios-arm64-simulator"
mkdir -p "$SIMULATOR_LIB_DIR"

# Copy the arm64 simulator build directly
cp "$LIB_ARM64_SIM" "$SIMULATOR_LIB_DIR/libheartwood_ios_bridge.a"

# Create XCFramework (Apple Silicon only)
echo "📦 Creating XCFramework..."
rm -rf "$BUILD_DIR/Heartwood.xcframework"

xcodebuild -create-xcframework \
    -library "$LIB_ARM64" -headers "$HEADER_PATH" \
    -library "$SIMULATOR_LIB_DIR/libheartwood_ios_bridge.a" -headers "$HEADER_PATH" \
    -output "$BUILD_DIR/Heartwood.xcframework"

echo "✅ XCFramework created at: $BUILD_DIR/Heartwood.xcframework"

# Verify XCFramework contents
ls -lah "$BUILD_DIR/Heartwood.xcframework"
lipo -info "$BUILD_DIR/ios-arm64-simulator/libheartwood_ios_bridge.a"

echo "🎉 Build completed successfully!"

