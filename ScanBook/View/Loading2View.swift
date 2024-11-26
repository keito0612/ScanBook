//
//  miniLoadingView.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/10/29.
//

import SwiftUI

struct Loading2View: View {
    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
            VStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding()
                    .tint(Color.white)
                    .background(Color.gray)
                    .cornerRadius(8)
                    .scaleEffect(1.2)
                Spacer()
            }
        }
    }
}

#Preview {
    Loading2View()
}
