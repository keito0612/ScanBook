//
//  SettingPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/01/31.
//

import SwiftUI

struct SettingPage: View {
    var body: some View {
        NavigationStack{
            ZStack{
                Color.black.ignoresSafeArea()
                VStack{
                    
                }
            }.navigationTitle("設定").toolbarBackground(Color.black,for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark)
        }
    }
}

struct SettingPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingPage()
    }
}
