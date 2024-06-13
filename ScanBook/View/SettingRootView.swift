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
        
        @ViewBuilder
        func destination() -> some View {
            switch self {
            case .passCodeSetting:
                PassCodeSettingPage()
            case .passCodeSettingScreen:
                PassCodeSettingScreenView()
            case .passCodeSettingScreen2:
                PassCodeSettingScreen2View()
            }
        }
    }
}

struct SettingRootView: View {
    @StateObject private var navigationSettingRouter = NavigationSettingRouter()
    var body: some View {
        NavigationStack(path: $navigationSettingRouter.path) {
                 SettingPage()
                      .navigationDestination(for: NavigationSettingRouter.ScreenKey.self, destination: { screenKey in
                          screenKey.destination()
                      })
              }
              .environmentObject(navigationSettingRouter)
    }
}

#Preview {
    SettingRootView()
}
