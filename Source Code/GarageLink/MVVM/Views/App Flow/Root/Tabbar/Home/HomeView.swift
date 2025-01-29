//
//  HomeView.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section("Mechanics") {
                    ForEach(vm.mechanics.indices, id: \.self) { index in
                        let mechanic = vm.mechanics[index]
                        NavigationLink {
                            MechanicDetailsView(mechanic: mechanic)
                        } label: {
                            MechanicCardView(mechanic: mechanic)
                        }
                    }
                }
            }
        }
    }
}

struct MechanicDetailsView: View {
    
    let mechanic: Mechanic
    
    var body: some View {
        List {
            Section("Bio") {
                CircleImageView(selectedImage: nil, imageURL: mechanic.bio.profileImage, size: 60)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text(mechanic.bio.firstName)
                Text(mechanic.bio.lastName)
                Text(mechanic.bio.phoneNumber)
                Text(mechanic.bio.dob.formatted())
            }
            
            Section("Details") {
                Text(
                    mechanic.details.vehicleTypes
                        .map({$0.rawValue}).joined(separator: ", ")
                )
                .multilineTextAlignment(.center)
                
                Text(mechanic.details.description)
                
                Text(mechanic.details.expertise)
                
                Text(mechanic.details.experience)
            }
            
            Section("Address") {
                Text(mechanic.address.fullAddress)
                Text(mechanic.address.country)
                Text(mechanic.address.city)
                Text(mechanic.address.zipCode)
            }
        }
    }
}
