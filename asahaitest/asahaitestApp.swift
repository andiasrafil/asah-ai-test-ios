//
//  asahaitestApp.swift
//  asahaitest
//
//  Created by Andi Asrafil on 05/03/25.
//

import SwiftUI
import SDWebImageSwiftUI
import SDWebImageSVGCoder

@main
struct asahaitestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainView()
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
        return true
    }
}

