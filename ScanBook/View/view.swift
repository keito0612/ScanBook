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
    func tapGestureWithEffectView(action: @escaping () -> Void) -> some View{
        self.modifier(TapGestureWithEffectView(action: action))
    }
}
