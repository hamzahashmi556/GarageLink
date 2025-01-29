//
//  SignUpViewModel.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import Foundation

class SignUpViewModel: ObservableObject {

    @Published var email: String = ""
    
    @Published var password: String = ""
    
    @Published var confirmPassword: String = ""
    
    @Published var isLoading: Bool = false

    func signup() {
        
        guard !email.isEmpty else {
            AlertManager.shared.showAlert(title: "Sign up Failed", message: "Email cannot be empty")
            return
        }
        
        guard password == confirmPassword else {
            AlertManager.shared.showAlert(title: "Sign up Failed", message: "Passwords do not match")
            return
        }
        
        Task { @MainActor in
            
            self.isLoading = true
            
            do {
                try await AuthManager.shared.signUp(email: email, password: password)
            }
            catch {
                AlertManager.shared.showAlert(title: "Sign up Failed", message: error.localizedDescription)
            }
            
            self.isLoading = false
        }
    }
}
