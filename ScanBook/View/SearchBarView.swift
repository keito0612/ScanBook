//
//  SearchBarView.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/02/06.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
        let onSubmit: ()-> Void
        var body: some View {
            HStack {
                Image(systemName: "magnifyingglass")
                .font(.system(size:20, weight: .medium))
                .foregroundColor(Color.white)
                .padding(.leading, 10)
                TextField("", text: $searchText, prompt: Text("検索").foregroundColor(Color.gray.opacity(8.0)))
                    .frame(height: Bounds.height * 0.07)
                    .foregroundColor(Color.white)
                    .accentColor(Color.white)
                .background(Color.black)
                    .onSubmit() {
                        onSubmit()
                    }
                    .background(Color.black)
                if !searchText.isEmpty {
                    Button {
                        searchText.removeAll()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size:20, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 10)
                }
            }.overlay(
                RoundedRectangle(cornerRadius: 30)
                 .stroke(Color.white, lineWidth: 3)
            ).background(Color.black).frame(maxWidth: .infinity)
                .cornerRadius(30).padding(.horizontal)
        }
}

struct SearchBarView_Previews: PreviewProvider {
    @State static var text = "検索"
    static var previews: some View {
        SearchBarView(searchText: $text, onSubmit: {
            
        })
    }
}
