//
//  AlertManager.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 04/01/2025.
//

import Foundation

final class AlertManager {
    
    @Published var isPresent = false
    
    @Published var title = String()
    
    @Published var message: String? = nil
    
    @Published var cancelAction: AlertAction? = nil
    
    @Published var primaryAction: AlertAction? = nil
    
    static let shared = AlertManager()
    
    private init() {}
    
//    func showAlert(message: String) {
//        showAlert = true
//        alertMessage = message
//    }
    
    func showAlert(title: String,
                   message: String = "",
                   alertCancelAction: AlertAction? = nil,
                   alertPrimaryAction: AlertAction? = nil) {
        self.isPresent = true
        self.title = title
        self.message = message
        self.cancelAction = alertCancelAction
        self.primaryAction = alertPrimaryAction
    }
    
    func hideAlert() {
        self.isPresent = false
        self.title.removeAll()
        self.message?.removeAll()
        self.message = nil
        self.cancelAction = nil
        self.primaryAction = nil
    }
}

struct AlertAction {
    var title: String
    var action: () -> Void
}
