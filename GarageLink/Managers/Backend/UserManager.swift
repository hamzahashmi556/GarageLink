//
//  UserManager.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import Firebase
import FirebaseFirestore
import FirebaseAuth

final class UserManager {
    
    static let shared = UserManager()
    
    private let usersRef = Firestore.firestore().collection("users")
    
    @Published var userProfile: Appuser?
    
    private var listener: ListenerRegistration? = nil
    
    private init() {
        _ = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.fetch()
            }
            else {
                self.remove()
            }
        }
    }
    
    func createCustomer(bio: Bio, addre: String = "") async throws {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let user = Appuser(bio: bio)
        
        try await user.setDataInFirestore(documentReference: usersRef.document(uid))
        
        self.userProfile = user
    }
    
    private func fetch() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
//            debugPrint(#function, AuthErrorCode(.userNotFound))
            return
        }
        
        guard self.listener == nil else {
            return
        }
        
        self.listener = self.usersRef.document(uid).addSnapshotListener { document, error in
            if let document = document {
                do {
                    let user = try document.data(as: Appuser.self)
                    
                    self.userProfile = user
                }
                catch {
                    debugPrint(#function, error)
                }
                self.userProfile = try? document.data(as: Appuser.self)
            }
        }
    }

    private func remove() {
        listener?.remove()
        listener = nil
    }
}
