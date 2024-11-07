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
    
    
    func addBookData(_ bookData: BookData) async  throws{
        var converImage: String = ""
        var images: Array<String> = []
        let date  = UtilDate().DateTimeToString(date: bookData.date!)
        try await upLoadImage(id: bookData.id!.description, scanImages: Array<UIImage>.decode(from: bookData.images!), converImage:                           UIImage(data:bookData.coverImage ?? Data()), resultImage: { downLoadConverImage , downLoadImages  in
            converImage =  downLoadConverImage
            images = downLoadImages
        })
        let bookData :FirestoreBookData = FirestoreBookData( coverImage:converImage, reading: bookData.reading,images:images, title: bookData.title!,pageCount: Int(bookData.pageCount),categoryStatus:Int( bookData.categoryStatus),
                        favorito:bookData.favorito, date:date)
        try db.collection("users").document(getUserId()).collection("books").addDocument(from: bookData)
    }
        
    
    func passwordReset(email:String) async throws{
        try await auth.sendPasswordReset(withEmail: email)
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
    func upLoadImage(id:String,scanImages:Array<UIImage>,converImage:UIImage?, resultImage: ( _ converImage:String, _ images:Array<String>) -> Void) async throws{
        var downLoadConverImage:String = ""
        var downLoadImages:Array<String> = []
        let path = "gs://scanbook-app-3a9c5.appspot.com"
        do {
            for ( index ,image) in scanImages.enumerated() {
                guard let uploadImage = image.jpegData(compressionQuality: 0.5) else {
                    break
                }
                let scanImageReference = storage.reference(forURL: path).child("users/\(getUserId())/scanImage/images/scanImages/\(id)/scanImage\(index).jpg")
                _ =  try await scanImageReference.putDataAsync( uploadImage,metadata: nil, onProgress: nil)
                let downLoadImage = try await scanImageReference.downloadURL().absoluteString
                downLoadImages.append(downLoadImage)
            }
            if(converImage != nil){
                guard let uploadConverImage = converImage!.jpegData(compressionQuality: 0.5) else {
                    return
                }
                
                let converImageReference = storage.reference(forURL: path).child("users/\(getUserId())/scanImage/converImage/images/converImage\(id).jpg")
                _ =  try await converImageReference.putDataAsync( uploadConverImage,metadata: nil, onProgress: nil)
                downLoadConverImage =  try await converImageReference.downloadURL().absoluteString
                resultImage(downLoadConverImage, downLoadImages)
            }else{
                resultImage("", downLoadImages)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    func deleteUser() async throws{
        try await db.collection("users").document(getUserId()).delete()
        let user  = auth.currentUser
        try await user?.delete()
    }
    func getUserId() -> String{
       return auth.currentUser!.uid
    }
}
