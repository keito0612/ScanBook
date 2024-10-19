//
//  ScanBookApp.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/01/08.
//

import SwiftUI
import GoogleMobileAds
import FirebaseCore
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil) //Mobile Ads SDK の初期化
        FirebaseApp.configure()
        return true
    }
}

@main
struct ScanBookApp: App {
    let password = UserDefaults.standard.bool(forKey: "isPassCodeLock")
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            if(password){
                PassCodeLockScreenView()
            }else{
                ZStack{
                    ContentView()
                        .environmentObject(PassCheck())
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .transition(.opacity)
                }
            }
        }
    }
}
