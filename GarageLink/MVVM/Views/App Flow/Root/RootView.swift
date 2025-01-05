//
//  RootView.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 03/01/2025.
//

import SwiftUI

struct RootView: View {
    
    @StateObject private var vm = RootViewModel()
    
    @StateObject private var router = Router()
    
    var body: some View {
        
        Group {
            
            switch vm.screenFlow {
            case .login:
                LoginView()
                
            case .createAccount:
                CreateAccountView()
                
            case .home:
                Button("Logout") {
                    try? AuthManager.shared.signOut()
                }
            }
        }
        .environmentObject(router)
        .alert(
            vm.alertTitle,
            isPresented: $vm.showAlert,
            actions: {
                if vm.alertPrimaryAction != nil {
                    Button("", role: .cancel, action: vm.alertPrimaryAction!)
                }
                
                if vm.alertCancelAction != nil {
                    Button("", role: .cancel, action: vm.alertCancelAction!)
                }
            },
            message: {
                if let message = vm.alertMessage {
                    Text(message)
                }
            }
        )
    }
}
