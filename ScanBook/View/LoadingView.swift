//
//  LoadingView.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/05/20.
//

import SwiftUI

struct LoadingView: View {
    private let scaleEffect: CGFloat
    init(scaleEffect: CGFloat) {
        self.scaleEffect = scaleEffect
    }
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle( tint: Color.white))
                .scaleEffect(scaleEffect)
                .frame(width: scaleEffect * 20, height: scaleEffect * 20)
            Text("読み込み中")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .font(.title)
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.gray.opacity(0.8))
    }
}

#Preview {
  return LoadingView(scaleEffect: 3)
}
