//
//  SignUpScreen.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 04/01/2025.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject private var vm = SignUpViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            
            Header(title: "Sign Up")
            
            SubHeader(title: "Enter your email & password to register your account")
            
            AppTextField("Email Address", text: $vm.email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
            
            AppTextField("Enter Password", text: $vm.password, isSecureField: true)
            
            AppTextField("Enter Confirm Password", text: $vm.confirmPassword, isSecureField: true)
            
            Spacer()
            
            AppButton(title: "Sign Up", isLoading: vm.isLoading) {
                vm.signup()
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(UIColor.systemGray6))
        }
        .padding()
    }
}
