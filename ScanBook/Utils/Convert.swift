//
//  Convert.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/02/24.
//

import Foundation
import UIKit
class Convert{
    
    static func convertImageToBase64(_ image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return nil }
        return imageData.base64EncodedString()
    }
    
    static func convertImagesToBase64(_ images: [UIImage]) -> [String]{
        var imageDataList :[String] = []
        if(!images.isEmpty){
            for image in images {
                let imageData = image.jpegData(compressionQuality: 1.0)
                imageDataList.append(imageData!.base64EncodedString())
            }
        }
        return imageDataList
    }
    
    static func convertBase64ToImages(_ base64StringList: [String]) -> [UIImage] {
        var imageList :[UIImage] = []
        if(!base64StringList.isEmpty){
            for base64String in base64StringList {
                let imageData = Data(base64Encoded: base64String)
                let image = UIImage(data: imageData!)
                imageList.append(image!)
            }
        }
        return imageList
    }
    
    static func convertBase64ToImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: imageData)
    }
}
