#!/bin/bash
set -e

echo "=== Patching src/lib.rs: adding iOS entry point ==="
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

echo "=== Patching src/paths.rs: adding iOS bundle path ==="
# Add iOS to the android cfg so path resolution works similarly
sed -i '' 's/target_os = "android"/target_os = "android", target_os = "ios"/g' src/paths.rs
echo "Done."

echo "=== All patches applied successfully! ==="
