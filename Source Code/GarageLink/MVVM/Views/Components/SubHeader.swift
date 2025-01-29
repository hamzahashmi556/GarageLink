//
//  SubHeader.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import SwiftUI

struct SubHeader: View {
    
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
    }
}
