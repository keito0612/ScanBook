//
//  view.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/02/15.
//

import Foundation
import SwiftUI

extension View {
    func customBackButton() -> some View {
        self.modifier(CustomBackButton())
    }
}
extension View{
    func imageMagnificationView(contentSize: CGSize, aspectRatio: CGFloat) -> some View{
        self.modifier(ImageMagnificationView(contentSize: contentSize, aspectRatio: aspectRatio))
    }
}
