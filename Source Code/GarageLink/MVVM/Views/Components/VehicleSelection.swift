//
//  VehicleSelection.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 08/01/2025.
//

import SwiftUI

struct VehicleSelection: View {
    
    @Binding var mechanicDetails: MechanicDetails
    
    var body: some View {
        ForEach(VehicleType.allCases, id: \.rawValue) { vehicle in
            
            Button {
                updateVehicle(vehicle)
            } label: {
                HStack {
                    
                    if mechanicDetails.vehicleTypes.contains(where: { $0 == vehicle }) {
                        Image(systemName: "checkmark.circle")
                    }
                    else {
                        Image(systemName: "circle")
                    }
                    
                    Text(vehicle.rawValue)
                        .font(.body)
                    
                    Spacer()
                }
                .foregroundStyle(Color.white)
            }
        }
    }
    
    func updateVehicle(_ vehicle: VehicleType) {
        if let index = mechanicDetails.vehicleTypes.firstIndex(where: { $0 == vehicle }) {
            mechanicDetails.vehicleTypes.remove(at: index)
        }
        else {
            mechanicDetails.vehicleTypes.append(vehicle)
        }
    }
}
