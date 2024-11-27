//
//  ConfigPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/11/27.
//

import SwiftUI

struct AppearanceModePage: View {
    
    @AppStorage(wrappedValue: 0, "appearanceMode") var appearanceMode
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Form {
                Picker("Appearance setting", selection: $appearanceMode) {
                    Text("Follow system")
                        .tag(0)
                    Text("Dark mode")
                        .tag(1)
                    Text("Light mode")
                        .tag(2)
                }
            }
        }
    }
}

#Preview {
    @Previewable @AppStorage(wrappedValue: 0, "appearanceMode") var appearanceMode
    AppearanceModePage().applyAppearenceSetting(DarkModeSetting(rawValue: appearanceMode) ?? .normal)
}
