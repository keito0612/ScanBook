//
//  FirebaseServise.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/10/18.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUICore
import FirebaseStorage
import FirebaseAuth

class FirebaseServise{
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let auth = Auth.auth()
    
    func addStateDidChangeListener(completion: @escaping (Bool) -> Void) {
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let _ = user {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func signOut() throws{
        try Auth.auth().signOut()
    }
    
    func signUp(email: String, password: String)  async throws{
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    func signIn(email: String, password: String) async throws -> String {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        let uid = result.user.uid
        return uid
    }
    func upLoadImage(id:Int,scanImages:Array<UIImage>,converImage:UIImage) async throws{
        let path = "gs://scanBook.appspot.com"
        do {
            for ( index ,image) in scanImages.enumerated() {
                guard let uploadImage = image.jpegData(compressionQuality: 0.5) else {
                    break
                }
                let scanImageReference = storage.reference(forURL: path).child("scanImage/images/scanImages\(id)/scanImage\(index).jpg")
                _ =  try await scanImageReference.putDataAsync( uploadImage,metadata: nil, onProgress: nil)
            }
            
            guard let uploadConverImage = converImage.jpegData(compressionQuality: 0.5) else {
                return
            }
            
            let converImageReference = storage.reference(forURL: path).child("converImage/images/converImage\(id).jpg")
            _ =  try await converImageReference.putDataAsync( uploadConverImage,metadata: nil, onProgress: nil)
        }catch{
            print(error.localizedDescription)
        }
    }
    func downloadImage(){
        
    }
}
