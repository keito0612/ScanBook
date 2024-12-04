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
    
    
    func addBookData(_ bookDataList: [BookData]) async  throws{
        let batch = db.batch()
        for bookData in bookDataList {
            var converImage: String = ""
            var images: Array<String> = []
            let date  = UtilDate().DateTimeToString(date: bookData.date!)
            try await upLoadImage(id: bookData.id!.description, scanImages: Array<UIImage>.decode(from: bookData.images!), converImage:                           UIImage(data:bookData.coverImage ?? Data()), resultImage: { downLoadConverImage , downLoadImages  in
                converImage =  downLoadConverImage
                images = downLoadImages
            })
            var firestoreBookData :FirestoreBookData = FirestoreBookData( coverImage:converImage, reading: bookData.reading,images:images, title: bookData.title!,pageCount: Int(bookData.pageCount),categoryStatus:bookData.categoryStatus,
                                                                          favorito:bookData.favorito, date:date)
            let documentRef = db.collection("users")
                .document(getUserId())
                .collection("books")
                .document()
            firestoreBookData.id = documentRef.documentID
            try batch.setData(from: firestoreBookData, forDocument: documentRef)
        }
        try await batch.commit()
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
            downLoadImages = try await withThrowingTaskGroup(of: String.self) { group -> [String] in
                    for (index, image) in scanImages.enumerated() {
                        group.addTask {
                            guard let uploadImage = image.jpegData(compressionQuality: 0.5) else {
                                throw NSError(domain: "ImageCompressionError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to compress image"])
                            }
                            
                            let scanImageReference = self.storage.reference(forURL: path).child("users/\(self.getUserId())/scanImage/images/scanImages/\(id)/scanImage\(index).jpg")
                            _ = try await scanImageReference.putDataAsync(uploadImage, metadata: nil)
                            return try await scanImageReference.downloadURL().absoluteString
                        }
                    }
                    
                    // タスクの実行結果を収集
                    var results = [String]()
                    for try await downloadURL in group {
                        results.append(downloadURL)
                    }
                    return results
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
    
    func deleteUpLoadImage() async throws{
        let path = "gs://scanbook-app-3a9c5.appspot.com"
        let storageRef = storage.reference(forURL: path).child("users/\(getUserId())/scanImage/images/scanImages")
        let folderList = try await storageRef.listAll()
        await withTaskGroup(of: Void.self) { taskGroup in
            for folder in folderList.prefixes {
                taskGroup.addTask {
                    do {
                        let fileList = try await folder.listAll()
                        // ファイルを並列で削除
                        await withTaskGroup(of: Void.self) { fileTaskGroup in
                            for file in fileList.items {
                                fileTaskGroup.addTask {
                                    do {
                                        try await file.delete()
                                    } catch {
                                        print("Failed to delete file \(file.name) in folder \(folder.fullPath): \(error.localizedDescription)")
                                    }
                                }
                            }
                        }
                    } catch {
                        print("Failed to list files in folder \(folder.fullPath): \(error.localizedDescription)")
                    }
                }
            }
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
