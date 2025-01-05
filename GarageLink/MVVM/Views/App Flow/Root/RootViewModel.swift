//
//  RootViewModel.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 03/01/2025.
//

import Foundation
import Combine

class RootViewModel: ObservableObject {
    
    @Published var isLoggedIn = false
    
    @Published var showAlert = false
    
    @Published var alertTitle: String = ""
    
    @Published var alertMessage: String? = nil
    
    @Published var alertCancelAction: (() -> Void)? = nil
    
    @Published var alertPrimaryAction: (() -> Void)? = nil
    
    @Published var screenFlow: ScreenFlow = .login
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        AlertManager.shared.$isPresent
            .receive(on: RunLoop.main)
            .sink { [weak self] showAlert in
                self?.showAlert = showAlert
            }
            .store(in: &cancellables)

        
        AlertManager.shared.$title
            .combineLatest(AlertManager.shared.$message)
            .receive(on: RunLoop.main)
            .sink { [weak self] (title, message) in
                self?.alertTitle = title
                self?.alertMessage = message
            }
            .store(in: &cancellables)
        
        AlertManager.shared.$cancelAction
            .combineLatest(AlertManager.shared.$primaryAction)
            .receive(on: RunLoop.main)
            .sink { [weak self] (cancel, action) in
                self?.alertCancelAction = cancel
                self?.alertPrimaryAction = action
            }
            .store(in: &cancellables)
        
        AuthManager.shared.$isLoggedIn
            .combineLatest(UserManager.shared.$userProfile)
            .combineLatest(MechanicManager.shared.$mechanic)
            .receive(on: RunLoop.main)
            .sink { [weak self] (arg0, arg1) in
                
                let (isLoggedIn, userProfile) = arg0
                
                let mechanic = arg1
                
                if isLoggedIn, (userProfile != nil || mechanic != nil) {
                    self?.screenFlow = .home
                }
                else if isLoggedIn {
                    self?.screenFlow = .createAccount
                }
                else {
                    self?.screenFlow = .login
                }
            }
            .store(in: &cancellables)
    }
}

enum ScreenFlow {
    case login
    case createAccount
    case home
}
