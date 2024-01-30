//
//  ScannerServise.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/01/21.
//

import Foundation
import VisionKit
import SwiftUI
final class ScannerServise: NSObject{
    @Binding var imageArray:[UIImage]
    init(imageArray: Binding<[UIImage]>) {
        self._imageArray = imageArray
    }
    
    func getDocumentCameraViewController() -> VNDocumentCameraViewController {
        let vc = VNDocumentCameraViewController()
        vc.delegate = self
        return vc
    }
}


extension ScannerServise: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        for i in 0..<scan.pageCount {
          self.imageArray.append(scan.imageOfPage(at: i))
        }
        controller.dismiss(animated: true)
    }
}
