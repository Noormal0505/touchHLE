#!/bin/bash
set -e

echo "=== Step 1: Patch src/lib.rs ==="
cat >> src/lib.rs << 'IOSEOF'

#[cfg(target_os = "ios")]
#[no_mangle]
pub extern "C" fn touchHLE_ios_main() -> std::ffi::c_int {
    match main(std::iter::empty()) {
        Ok(()) => 0,
        Err(e) => { eprintln!("touchHLE error: {}", e); 1 }
    }
}
IOSEOF
echo "Done."

echo "=== Step 2: Pre-fetch rust-sdl2 ==="
cargo fetch --target aarch64-apple-ios 2>/dev/null || true

echo "=== Step 3: Patch rust-sdl2 build.rs sysroot ==="
SDL2_BUILD=$(find $HOME/.cargo/git/checkouts -name "build.rs" -path "*rust-sdl2*sdl2-sys*" 2>/dev/null | grep -v "android" | head -1)

if [ -z "$SDL2_BUILD" ]; then
  echo "ERROR: Could not find rust-sdl2 build.rs!"
  exit 1
fi

echo "Found: $SDL2_BUILD"
SDKPATH=$(xcrun --sdk iphoneos --show-sdk-path)
echo "iOS SDK: $SDKPATH"

sed -i '' "s|define(\"CMAKE_OSX_SYSROOT\", \"/\")|define(\"CMAKE_OSX_SYSROOT\", \"$SDKPATH\")|g" "$SDL2_BUILD"
echo "Patched! Result:"
grep "CMAKE_OSX_SYSROOT" "$SDL2_BUILD" || echo "Line not found - showing surrounding context:"
grep -n "OSX\|sysroot\|SYSROOT" "$SDL2_BUILD" || true

echo "=== Done! ==="
