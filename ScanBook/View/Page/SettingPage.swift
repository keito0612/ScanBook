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
                  List{
                      Section(header: Text("設定").bold().foregroundStyle(Color.white)) {
                          Text("パスコード").foregroundStyle(Color.white).bold().listRowBackground(Color(white: 0.2, opacity: 1.0)).onTapGesture {
                              
                          }
                          Text("iCloud").foregroundStyle(Color.white).bold().listRowBackground(Color(white: 0.2, opacity: 1.0)).onTapGesture {
                              
                          }
                      }
                      Section(header: Text("利用規約・プライバシーポリシー").bold().foregroundStyle(Color.white)) {
                          Text("プライバシーポリシー").bold().foregroundStyle(Color.white).listRowBackground(Color(white: 0.2, opacity: 1.0))
                          Text("利用規約").bold().foregroundStyle(Color.white).listRowBackground(Color(white: 0.2, opacity: 1.0))
                      }
                      Section(header: Text("お問い合わせ").bold().foregroundStyle(Color.white)) {
                          Text("お問い合わせ").bold().foregroundStyle(Color.white) .listRowBackground(Color(white: 0.2, opacity: 1.0))
                      }
                  }.listStyle(.sidebar)
                   .background(Color.black)
                   .scrollContentBackground(.hidden)
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
