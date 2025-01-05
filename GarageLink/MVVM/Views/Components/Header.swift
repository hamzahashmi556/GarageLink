//
//  Header.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import SwiftUI

struct Header: View {
    
    let title: String
    
    var body: some View {
        Text(title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}
