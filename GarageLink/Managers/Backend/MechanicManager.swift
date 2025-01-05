//
//  UserManager 2.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import FirebaseAuth
import FirebaseFirestore

final class MechanicManager {
    
    static let shared = MechanicManager()
    
    private let ref = Firestore.firestore().collection("mechanics")
    
    private var listener: ListenerRegistration? = nil
    
    @Published var mechanic: Mechanic?
    
    private init() {
        _ = Auth.auth().addStateDidChangeListener({ auth, user in
            if user == nil {
                self.removeListener()
            }
            else {
                self.fetchListener()
            }
        })
    }
    
    func create(mechanic: Mechanic) async throws {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        try await mechanic.setDataInFirestore(documentReference: ref.document(uid))
        
        self.mechanic = mechanic
    }
    
    private func fetchListener() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
//            debugPrint(#function, AuthErrorCode(.userNotFound))
            return
        }
        
        self.listener = self.ref.document(uid).addSnapshotListener { document, error in
            if let document = document {
                do {
                    let user = try document.data(as: Mechanic.self)
                    
                    self.mechanic = user
                }
                catch {
                    debugPrint(#function, error)
                }
                self.mechanic = try? document.data(as: Mechanic.self)
            }
        }
    }

    func removeListener() {
        self.listener?.remove()
        self.listener = nil
    }
}
