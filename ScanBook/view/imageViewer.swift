//
//  imageViewer.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/03/08.
//

import SwiftUI

struct ImageViewer: UIViewRepresentable {
    let image: UIImage
    
    func makeUIView(context: Context) -> UIImageViewerView {
        let view = UIImageViewerView(image: image)
        return view
    }
    
    func updateUIView(_ uiView: UIImageViewerView, context: Context) {}
}
