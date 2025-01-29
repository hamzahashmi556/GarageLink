//
//  Extension+View.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 04/01/2025.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func isLoading(_ isLoading: Bool, loadingTitle: String = String()) -> some View {
        ZStack {
            if isLoading {
                self
                ProgressView(loadingTitle)
            }
            else {
                self
            }
        }
    }
    
    @ViewBuilder
    func attachDoneOnKeyboard() -> some View {
        self.toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Button("Done") {
                        UIApplication.shared.endEditing()
                    }
                    .frame(width: 50)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
