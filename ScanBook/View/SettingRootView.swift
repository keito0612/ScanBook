//
//  SettingRootView.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/06/13.
//

import SwiftUI

class NavigationSettingRouter: ObservableObject {
    @Published var path = [ScreenKey]()
    
    enum ScreenKey{
        case passCodeSetting
        case passCodeSettingScreen
        case passCodeSettingScreen2
        case iCloudSetting
        case account
        case login
        case sinUp
        
        @ViewBuilder
        func destination() -> some View {
            switch self {
            case .passCodeSetting:
                PassCodeSettingPage()
            case .passCodeSettingScreen:
                PassCodeSettingScreenView()
            case .passCodeSettingScreen2:
                PassCodeSettingScreen2View()
            case .iCloudSetting:
                ICloudSettingPage()
            case .account:
                AccountPage()
            case .login:
                LoginPage()
            case .sinUp:
                SinUpPage()
            }
        }
    }
}

struct SettingRootView: View {
    @StateObject private var navigationSettingRouter = NavigationSettingRouter()
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        NavigationStack(path: $navigationSettingRouter.path) {
                 SettingPage()
                      .navigationDestination(for: NavigationSettingRouter.ScreenKey.self, destination: { screenKey in
                          screenKey.destination()
                      })
              }
              .environmentObject(navigationSettingRouter)
              .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}

#Preview {
    SettingRootView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
