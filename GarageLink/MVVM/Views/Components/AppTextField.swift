//
//  AppTextField.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import SwiftUI

struct AppTextField: View {
    
    let titleKey: LocalizedStringKey
    
    var isSecureField: Bool
    
    @Binding var text: String
    
    init(_ titleKey: LocalizedStringKey, text: Binding<String>, isSecureField: Bool = false) {
        self.titleKey = titleKey
        self.isSecureField = isSecureField
        self._text = text
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.systemGray4))
            
            VStack {
                if isSecureField {
                    SecureField(titleKey, text: $text)
                }
                else {
                    TextField(titleKey, text: $text)
                }
            }
            .frame(height: 50)
            .padding(.horizontal)
        }
        .frame(height: 50)
    }
}
