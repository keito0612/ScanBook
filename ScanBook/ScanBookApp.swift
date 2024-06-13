//
//  ScanBookApp.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/01/08.
//

import SwiftUI

@main
struct ScanBookApp: App {
    let password = UserDefaults.standard.string(forKey: "password")
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            if(password != nil ){
                PassCodeLockScreenView()
            }else{
                ContentView()
                    .environmentObject(PassCheck())
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .transition(.opacity)
            }
        }
    }
}
