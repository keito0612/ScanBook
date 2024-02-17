//
//  PreviewPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/02/03.
//

import SwiftUI

struct PreviewPage: View {
    let images : [UIImage]
    var body: some View {
        VStack{
            Image("image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .imageMagnificationView(contentSize: CGSize(width: 300, height: 300), aspectRatio: 1)
        }
    }
}
struct PreviewPage_Previews: PreviewProvider {
    static let images :[UIImage] = []
    static var previews: some View {
        PreviewPage(images: images)
    }
}
