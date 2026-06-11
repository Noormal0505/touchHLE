// AppDelegate.swift
// touchHLE iOS port
// Bridges between the iOS app lifecycle and the touchHLE Rust core via SDL2.

import UIKit

// Declaration of the Rust entry point exposed via #[no_mangle] in lib.rs
@_silgen_name("touchHLE_ios_main")
func touchHLE_ios_main() -> Int32

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // SDL2 needs the window set up before we call into Rust.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        // Run touchHLE on a background thread so the main thread stays alive
        // for SDL2's event loop (SDL2 on iOS pumps events on the main thread).
        DispatchQueue.global(qos: .userInteractive).async {
            let result = touchHLE_ios_main()
            if result != 0 {
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "touchHLE Error",
                        message: "touchHLE exited with code \(result).\nCheck the console for details.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.window?.rootViewController?.present(alert, animated: true)
                }
            }
        }

        return true
    }
}
