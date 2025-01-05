//
//  AppButton.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 04/01/2025.
//

import SwiftUI

struct AppButton: View {
    
    var title: String
    
    var font: Font = .callout
    
    var foregroundColor: Color = .white
    
    var backgroundColor = Color(UIColor.systemBlue)
    
    var cornerRadius: CGFloat = 10
    
    var isLoading: Bool
    
    var action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                
                if isLoading {
                    ProgressView()
                }
                else {
                    Text(title)
                        .font(font)
                        .foregroundColor(foregroundColor)
                }
            }
            .frame(height: 50)
        }
        .disabled(isLoading)
    }
}
