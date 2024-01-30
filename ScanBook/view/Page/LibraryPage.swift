//
//  LibraryPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/01/08.
//

import SwiftUI

struct LibraryPage: View {
    var body: some View {
        NavigationStack{
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack{
                    Grid {
                        GridRow {
                            ForEach(0..<3) { _ in Color.red }
                        }
                        .frame(width: 80, height: 80)
                    }
                }.navigationTitle("ライブラリー")
            }
        }
    }
}


struct LibraryPage_Previews: PreviewProvider {
    static var previews: some View {
        LibraryPage()
    }
}
