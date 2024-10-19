//
//  view.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/02/15.
//

import Foundation
import SwiftUI

extension View {
    func customBackButton(onBack: @escaping () -> Void ) -> some View {
        self.modifier(CustomBackButton(onBack:{
            onBack()
        }))
    }
}
extension View{
    func imageMagnificationView(contentSize: CGSize, aspectRatio: CGFloat) -> some View{
        self.modifier(ImageMagnificationView(contentSize: contentSize, aspectRatio: aspectRatio))
    }
}
extension View{
    func loadingView(message:String, scaleEffect:CGFloat, isPresented:Binding<Bool>) -> some View{
        self.modifier(LoadingView(message: message, scaleEffect: scaleEffect, isPresented: isPresented))
    }
}

enum Design {
    enum Padding {
        case small, medium, large, xlarge
    }
}

extension View {

    @ViewBuilder
    func padding(_ context: Design.Padding) -> some View {
        switch context {
        case .small:
            self.padding(4)

        case .medium:
            self.padding(8)

        case .large:
            self.padding(16)

        case .xlarge:
            self.padding(32)

        }
    }
}

extension Image {
    init(path: String) {
        self.init(uiImage: UIImage(named: path)!)
    }
}

