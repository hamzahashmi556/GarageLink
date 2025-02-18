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
                TabbarView()
            }
        }
        .environmentObject(router)
        .alert(
            vm.alertTitle,
            isPresented: $vm.showAlert,
            actions: {
                if let action1 = vm.alertPrimaryAction {
                    Button(action1.title, role: .cancel, action: action1.action)
                }
                
                if let action2 = vm.alertPrimaryAction {
                    Button(action2.title, role: .cancel, action: action2.action)
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
