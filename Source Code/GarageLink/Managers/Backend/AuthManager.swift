//
//  AuthManager.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class AuthManager {
    
    static let shared = AuthManager()
    
    @Published var isLoggedIn = false
        
    let db = Firestore.firestore()
    
    private init() {
        self.setupListener()
    }
    
    private func setupListener() {
        _ = Auth.auth().addStateDidChangeListener { auth, user in
            self.isLoggedIn = user != nil
            print("AuthID: \(user?.uid)")
        }
    }
    
    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func signUp(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func resetPassword(by email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    private func checkEmailExists(email: String) async throws -> Bool {
        let snapshot = try await db.collection("users").whereField("email", isEqualTo: email).getDocuments()
        let exists = !snapshot.documents.isEmpty
        return exists
    }
    
    /*
    @MainActor
    func signInGoogle() async throws -> GIDGoogleUser? {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return nil
        }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = config
        
        // 1. Sign in With Google
        let result = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: Application_utility.rootViewController
        )
        
        let googleUser = result.user
        
        guard let idToken = googleUser.idToken else {
            return nil
        }
        
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken.tokenString,
            accessToken: googleUser.accessToken.tokenString
        )
        
        // 2. Sign in Firebase Auth
        try await Auth.auth().signIn(with: credential)
        
        return googleUser
    }
    
    func logout() async throws{
        GIDSignIn.sharedInstance.signOut()
        try Auth.auth().signOut()
    }
    */
}
