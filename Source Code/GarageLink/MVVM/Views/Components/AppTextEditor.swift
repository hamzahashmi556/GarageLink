//
//  AppTextField 2.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import SwiftUI

struct AppTextEditor: View {
    
    var titleKey: String
    
    @Binding var text: String
    
    @FocusState private var isFocused
    
    let height: CGFloat = 150
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.systemGray4))
            
            TextEditor(text: $text)
                .focused($isFocused)
                .textEditorStyle(.plain)
                .scrollContentBackground(.hidden)
                .frame(height: height)
                .padding(.horizontal)
        }
        .frame(height: height)
        .onChange(of: isFocused) { oldValue, newValue in
            if self.text == titleKey && newValue {
                self.text.removeAll()
            }
            else if newValue == false && text.isEmpty {
                self.text = titleKey
            }
        }
        .onAppear {
            self.text = titleKey
        }
    }
}
