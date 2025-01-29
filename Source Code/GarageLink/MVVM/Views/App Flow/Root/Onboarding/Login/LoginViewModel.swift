//
//  LoginViewModel.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var email = String()
    
    @Published var password = String()
    
    @Published var showPasswordField = false
    
    @Published var isLoading = false
    
    func login() {
        
        guard email.count > 6 else {
            AlertManager.shared.showAlert(title: "Email", message: "Email Not Correct")
            return
        }
        
        guard password.count >= 6 else {
            AlertManager.shared.showAlert(title: "Password Incorrect", message: "Password must be atleast 6 characters")
            return
        }
        
        Task { @MainActor in
            
            self.isLoading = true
            
            do {
                try await AuthManager.shared.signIn(email: email, password: password)
            }
            catch {
                AlertManager.shared.showAlert(title: "Login Error", message: error.localizedDescription)
            }
            self.isLoading = false
        }
    }
    
    func resetPassword() {
        AlertManager.shared.showAlert(
            title: "Forgot Password?",
            message: "Enter your email address to recieve reset password link",
            alertCancelAction: nil,
            alertPrimaryAction: AlertAction(title: "Reset", action: resetPasswordPrimaryAction)
        )
    }
    
    func resetPasswordPrimaryAction() {
        Task { @MainActor in
            self.isLoading = true
            do {
                try await AuthManager.shared.resetPassword(by: email)
            }
            catch {
                AlertManager.shared.showAlert(title: "Error", message: error.localizedDescription)
            }
            self.isLoading = false
        }
    }
}
