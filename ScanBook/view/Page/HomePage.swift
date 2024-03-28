//
//  HomeView.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/03/28.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        NavigationStack{
            ZStack {
                Color.black
                    .ignoresSafeArea()
                ScrollView {
                    VStack{
                        Divider().frame(height: 2).background(Color.white)
                        Text("続ける")
                            .bold()
                            .font(.system(size:Bounds.width * 0.08 ))
                            .foregroundStyle(Color.white) .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider().frame(height: 2).background(Color.white)
                    }.padding(.all, 10)
                }
            }.navigationBarTitle("ホーム" , displayMode: .inline)
                .toolbarBackground(Color.black,for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark)
        }
    }
}
#Preview {
    HomePage()
}
