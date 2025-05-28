//
//  AppDelegate.swift
//  AudioAppSwift
//
//  Created by AI Assistant on 2023-10-27.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)

        // Set use_custom_audio to false if not already set
        if UserDefaults.standard.object(forKey: "use_custom_audio") == nil {
            UserDefaults.standard.set(false, forKey: "use_custom_audio")
        }

        // Assuming MainScreen is a UIViewController subclass that will be created later
        let mainScreen = MainScreen() 
        window?.rootViewController = mainScreen
        window?.makeKeyAndVisible()
        return true
    }
}
