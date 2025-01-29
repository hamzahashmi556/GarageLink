//
//  MechanicCardView.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 08/01/2025.
//

import SwiftUI

struct MechanicCardView: View {
    
    let mechanic: Mechanic
    
    var body: some View {
        
        HStack(spacing: 15) {
            
            CircleImageView(selectedImage: nil, imageURL: mechanic.bio.profileImage, size: 60)
            
            VStack(alignment: .leading) {
                Text("\(mechanic.bio.firstName) \(mechanic.bio.lastName)")
                    .font(.headline)
                
                Text("Contact: \(mechanic.bio.phoneNumber)")
                
                Text("Vehicles: \(mechanic.details.vehicleTypes.map({ $0.rawValue }).joined(separator: ", "))")
            }
        }
    }
}
