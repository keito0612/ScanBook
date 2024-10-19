//
//  FormButtonView.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/10/19.
//

import SwiftUI

struct FormButtonView: View {
    let name:String
    let onTap:()->Void
    var body: some View {
        Button(action: onTap, label: {
            Text(name)
                .foregroundColor(Color.white)
                .frame(height: 48)
                .frame(maxWidth: .infinity).background(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white, lineWidth: 3)
                )
        })
    }
}

#Preview {
    FormButtonView(name: "ログイン", onTap: {})
}
