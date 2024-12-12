//
//  ScannerView.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/02/12.
//

import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable {
    
    var scannedImages: [UIImage] = []
    @Binding var scannedImage: UIImage
    @Binding var isScanning: Bool
    let multiCapture: Bool
    var completion: ([UIImage]) -> Void
    init(scannedImage: Binding<UIImage> , multiCapture: Bool, isScanning:Binding<Bool>,completion: @escaping ([UIImage]) -> Void) {
        self._scannedImage = scannedImage
        self.multiCapture = multiCapture
        self._isScanning = isScanning
        self.completion = completion
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = context.coordinator
        return scanner
    }
    
    func updateUIViewController(_ uiView: VNDocumentCameraViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension  ScannerView {
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: ScannerView
        
        init(_ parent: ScannerView) {
            self.parent = parent
        }
        
         func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController){
             controller.dismiss(animated: true)
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            if(parent.multiCapture){
                for i in 0..<scan.pageCount {
                    parent.scannedImages.append(scan.imageOfPage(at: i))
                }
                self.parent.completion(parent.scannedImages)
                controller.dismiss(animated: true)
            }else{
                for i in 0..<scan.pageCount {
                    parent.scannedImage =  scan.imageOfPage(at: i)
                }
                controller.dismiss(animated: true)
                self.parent.completion([])
            }
        }
    }
}
