# **Heartwood iOS Bridge – Build & Integration Guide**

This guide explains how to build and integrate **Heartwood** into an iOS application by compiling the Rust-based Heartwood library into an **XCFramework** (`.xcframework`) that can be used in Swift.

---

## **📌 Project Overview**
This repository contains:
- A **Swift-based iOS application** with UI and networking components.
- **Heartwood**, a Rust-based Git protocol integrated as a submodule.
- A build system that compiles Rust into an `.xcframework` for use in Swift.


Building locally it looks like below, pulling real data from the API endpoints:

![](./resources/image.png)

---

## But...why?!?

This project is meant as a fun test to see what is possible for mobile devices.

My underlying hypothesis is that by allowing passive seeding of repositories on mobile devices, the network might be more resilient.

---

## **📌 Prerequisites**
Before proceeding, ensure you have the following installed:

### **1️⃣ Install Rust & Required Targets**
Ensure you have **Rust** installed (via `rustup`) and the required iOS targets.

```bash
# Install Rust if not already installed
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Ensure Rust is up to date
rustup update

# Install iOS and Simulator targets
rustup target add aarch64-apple-ios x86_64-apple-ios aarch64-apple-ios-sim
```

### **2️⃣ Install Xcode Command Line Tools**
```bash
xcode-select --install
```

### **3️⃣ Verify `lipo` is Available**
Run:
```bash
which lipo
```
If not found, install the developer tools:
```bash
xcode-select --install
```

---

## **📂 Project Structure**
This setup assumes your project has the following directory structure:

```
📂 RadicleApp
 ┣ 📂 API/              # Handles API calls (Repositories, Commits, Files, Issues)
 ┣ 📂 Models/           # Swift models representing data structures
 ┣ 📂 ViewModels/       # Business logic for SwiftUI Views
 ┣ 📂 Views/            # SwiftUI UI components
 ┣ 📂 Utils/            # Utility functions (caching, formatting, etc.)
 ┣ 📂 Navigation/       # App navigation & routing
 ┣ 📂 RustCore/         # Rust integration layer
 ┃ ┣ 📂 Heartwood/      # (Git Submodule) Heartwood's Rust source
 ┃ ┣ 📂 ios-bridge/     # Rust-to-iOS bridge for FFI integration
 ┃ ┃ ┣ 📜 Cargo.toml    # Rust package manifest for the iOS bridge
 ┃ ┃ ┣ 📜 build_ios.sh  # Script to build Rust into an XCFramework
 ┃ ┃ ┣ 📂 include/       # Header files for Swift interoperability
 ┃ ┃ ┗ 📂 build/ios/    # Compiled `Heartwood.xcframework`
 ┣ 📜 Info.plist             # iOS app metadata
 ┗ 📜 Assets.xcassets        # App icons and assets
```

---

## **⚙️ Building the Rust iOS Library**

The build process consists of:
1. **Compiling Rust for iOS (device & simulator)**
2. **Merging simulator libraries (`x86_64` & `arm64-sim`) using `lipo`**
3. **Creating an `.xcframework` using `xcodebuild`**

### **🔨 Step 1: Run the Build Script**
From the project root, run:
```bash
sh RustCore/ios-bridge/build_ios.sh
```

### **🔎 What This Script Does**
- Compiles **Heartwood iOS Bridge** for:
  - **iOS devices** (`aarch64-apple-ios`)
  - **Intel iOS Simulators** (`x86_64-apple-ios`)
  - **Apple Silicon Simulators** (`aarch64-apple-ios-sim`)
- Merges simulator libraries using `lipo`.
- Creates `Heartwood.xcframework` inside:
  ```
  RustCore/ios-bridge/build/ios/Heartwood.xcframework
  ```

---

## **📍 Verify the Build Output**
After the script completes, check for the `.xcframework`:
```bash
ls -l RustCore/ios-bridge/build/ios/
```
Expected output:
```
Heartwood.xcframework
```

---

## **🔗 Integrating Into Xcode**

### **1️⃣ Add the XCFramework to Xcode**
1. Open **Xcode**.
2. Select your **project** in the left panel.
3. Go to **Target → General → Frameworks, Libraries, and Embedded Content**.
4. Click `+`, then **Add Other… → Add Files…`.
5. Select:
   ```
   RustCore/ios-bridge/build/ios/Heartwood.xcframework
   ```
6. Ensure **Status** is **Do Not Embed** (since it’s a static library).

### **2️⃣ Set Library Search Paths**
1. Go to **Xcode → Target → Build Settings**.
2. Search for **"Library Search Paths"**.
3. Add:
   ```
   $(PROJECT_DIR)/RustCore/ios-bridge/build/ios/
   ```
4. Set it to **recursive**.

---

## **🛠 Calling Rust Code from Swift**

### **1️⃣ Create a Swift Wrapper for Rust Functions**
Create `RustInterop.swift`:
```swift
import Foundation

class RustInterop {
    static func testRust() {
        hw_hello_world()
    }
}
```

### **2️⃣ Modify `ContentView.swift` to Call Rust**
```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, Radicle!")
                .padding()
            Button("Test Rust Function") {
                RustInterop.testRust()
            }
        }
    }
}
```

---

## **✅ Running & Testing**
1. **Build & Run in Xcode**.
2. **Tap the "Test Rust Function" button**.
3. Check **Xcode Console (`Cmd+Shift+C`)** for:
   ```
   Hello from Rust!
   ```

🎉 **You’ve successfully integrated Rust into Swift using an XCFramework!** 🚀

---

## **📌 Summary**
| Step | Action |
|------|------------|
| **1. Install Dependencies** | Ensure Rust & Cargo targets are installed |
| **2. Build Rust Library** | Run `sh RustCore/Heartwood/build_ios.sh` |
| **3. Verify Output** | Check for `Heartwood.xcframework` in `build/ios/` |
| **4. Add to Xcode** | Drag `Heartwood.xcframework` into **Frameworks & Libraries** |
| **5. Set Library Search Paths** | `$(PROJECT_DIR)/RustCore/ios-bridge/build/ios/` |
| **6. Call from Swift** | Use `RustInterop.testRust()` in Swift |
| **7. Run & Test** | Ensure Rust logs appear in Xcode Console |

---

### **📢 Need Help?**
- Check Cargo logs: `cargo build --verbose`
- Check iOS logs: `Cmd+Shift+C` in Xcode
- Check Rust logs: `println!()` in Rust functions

🔥 **Now go build amazing things with Rust & iOS!** 🚀

