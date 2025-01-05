//
//  WelcomeScreen.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 03/01/2025.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject private var router: Router
        
    @StateObject private var vm = LoginViewModel()
    
    var body: some View {
        
        NavigationStack(path: $router.onboardingPath) {
            
            ZStack {
                
                VStack(spacing: 20) {
                    
                    Header(title: "Welcome to Garage Link")
                    
                    SubHeader(title: "Enter your account email & password to continue as Customer or Mechanic")
                        
                    AppTextField("Enter Email Address", text: $vm.email)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        
                    AppTextField("Enter Password", text: $vm.password, isSecureField: true)
                        .textContentType(.password)
                        
                    Button {
                        NotificationCenter.default.post(name: .onboardingPathChanged, object: OnboardingPath.forgotPassword)
                    } label: {
                        Text("Forgot Password")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .underline()
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                        
                    Spacer()
                        
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                        
                        Button("Sign Up here") {
                            NotificationCenter.default.post(name: .onboardingPathChanged, object: OnboardingPath.signup)
                        }
                        .underline()
                    }
                    .font(.callout)

                    AppButton(title: "Continue", isLoading: vm.isLoading) {
                        vm.login()
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(UIColor.systemGray6))
                }
                .padding()
                
            }
            .navigationDestination(for: OnboardingPath.self) { path in
                switch path {
                case .forgotPassword:
                    Text("Forgot Password")
                    
                case .signup:
                    SignUpView()
                }
            }
        }
    }
}

enum UserRole: CaseIterable {
    case customer
    case mechanic
}
