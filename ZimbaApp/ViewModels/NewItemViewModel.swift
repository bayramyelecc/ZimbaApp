//
//  ItemViewModel.swift
//  ZimbaApp
//
//  Created by Bayram Yeleç on 5.09.2024.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class NewItemViewModel: ObservableObject {
    
    @Published var posts: [ItemModel] = []
    
    private var db = Firestore.firestore()
    private var postsListener: ListenerRegistration?
    
    init() {
        fetchPosts()
    }
    
    func uploadPost(title: String, image: UIImage, userId: String, fullName: String) {
        let storageRef = Storage.storage().reference().child("posts/\(UUID().uuidString).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        storageRef.putData(imageData, metadata: nil) { _, error in
            if error != nil {
                print("Error uploading image")
                return
            }
            storageRef.downloadURL { url, error in
                if error != nil {
                    print("Error fetching image URL")
                    return
                }
                guard let url = url else { return }
                let newPost = [
                    "title": title,
                    "imageUrl": url.absoluteString,
                    "userId": userId,
                    "fullName": fullName,
                    "timeStamp": Timestamp(date: Date())
                ] as [String: Any]
                
                self.db.collection("posts").addDocument(data: newPost)
            }
        }
    }
    
    func fetchPosts() {
        // Koleksiyondaki veriler için dinleyici ekleyin
        postsListener = db.collection("posts")
            .order(by: "timeStamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching posts: \(error.localizedDescription)")
                    return
                }
                
                if let documents = snapshot?.documents {
                    self?.posts = documents.map { doc in
                        let data = doc.data()
                        return ItemModel(
                            id: doc.documentID,
                            title: data["title"] as? String ?? "",
                            imageUrl: data["imageUrl"] as? String ?? "",
                            userId: data["userId"] as? String ?? "",
                            fullName: data["fullName"] as? String ?? "",
                            timeStamp: (data["timeStamp"] as? Timestamp)?.dateValue() ?? Date()
                        )
                    }
                }
            }
    }
    
    func deletePost(postId: String) {
        db.collection("posts").document(postId).delete() { [weak self] error in
            if let error = error {
                print("Error deleting post: \(error.localizedDescription)")
                return
            }
            // Dinleyici veri kaybolsa bile, listeyi güncellemek gerekebilir
            self?.posts.removeAll { $0.id == postId }
        }
    }
    
    deinit {
        // ViewModel silindiğinde dinleyiciyi temizle
        postsListener?.remove()
    }
}
