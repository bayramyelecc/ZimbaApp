//
//  AuthViewModel.swift
//  ZimbaApp
//
//  Created by Bayram Yeleç on 4.09.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AuthViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var currentUser: AuthModel?
    @Published var fullName: String = ""
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    init() {
        isSignedIn = Auth.auth().currentUser != nil
        if let user = Auth.auth().currentUser {
            fetchUser(uid: user.uid)
        }
    }
    
    func fetchUser(uid: String) {
        db.collection("users").document(uid).addSnapshotListener { [weak self] document, error in
            if let document = document, document.exists {
                let data = document.data()
                let fullName = data?["fullName"] as? String ?? ""
                let email = data?["email"] as? String ?? ""
                let photoUrl = data?["photoUrl"] as? String ?? ""
                let dateCreated = (data?["dateCreated"] as? Timestamp)?.dateValue() ?? Date()
                self?.currentUser = AuthModel(id: uid, email: email, fullName: fullName, dateCreated: dateCreated, photoUrl: photoUrl)
                self?.fullName = fullName
            } else {
                print("Belge mevcut değil veya veriler alınırken bir hata oluştu: \(error?.localizedDescription ?? "error")")
            }
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if error != nil {
                print("Hata")
            } else if let user = result?.user {
                self?.fetchUser(uid: user.uid)
                self?.isSignedIn = true
            }
        }
    }
    
    func signUp(email: String, password: String, fullName: String, photo: UIImage?) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if error != nil {
                print("Kayıt hatası")
            } else if let user = result?.user {
                let dateCreated = Date()
                
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = fullName
                
                changeRequest.commitChanges { error in
                    if let error = error {
                        print("Profil güncelleme hatası: \(error.localizedDescription)")
                    } else {
                        print("Kullanıcı profili başarıyla güncellendi.")
                    }
                }
                
                if let photo = photo, let imageData = photo.jpegData(compressionQuality: 0.8) {
                    let storageRef = self?.storage.reference().child("profile_pictures/\(user.uid).jpeg")
                    storageRef?.putData(imageData, metadata: nil) { metadata, error in
                        if error != nil {
                            print("Yükleme hatası")
                        } else {
                            storageRef?.downloadURL { url, error in
                                if error != nil {
                                    print("Hata")
                                } else if let url = url {
                                    self?.saveUser(uid: user.uid, fullName: fullName, email: user.email ?? "", dateCreated: dateCreated, photoUrl: url.absoluteString)
                                    self?.fetchUser(uid: user.uid)
                                    self?.isSignedIn = true
                                }
                            }
                        }
                    }
                } else {
                    self?.saveUser(uid: user.uid, fullName: fullName, email: user.email ?? "", dateCreated: dateCreated, photoUrl: nil)
                    self?.fetchUser(uid: user.uid)
                    self?.isSignedIn = true
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isSignedIn = false
            self.currentUser = nil
        } catch {
            print("Çıkış hatası")
        }
    }
    
    func saveUser(uid: String, fullName: String, email: String, dateCreated: Date, photoUrl: String?) {
        db.collection("users").document(uid).setData([
            "fullName": fullName,
            "email": email,
            "dateCreated": dateCreated,
            "photoUrl": photoUrl ?? ""
        ]) { error in
            print("Kaydetme hatası: \(error?.localizedDescription ?? "hata")")
        }
    }
}
