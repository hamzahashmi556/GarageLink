//
//  Mechanic.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import Foundation
import FirebaseFirestoreInternal

struct Mechanic: Codable {
    var bio: Bio
    var address: Address
    var details: MechanicDetails
    var geoPoint: GeoPoint
    var geoHash: String
    var lat: Double
    var lng: Double
}

struct MechanicDetails: Codable {
    var vehicleTypes: [VehicleType]
    var description: String
    var expertise: String
    var experience: String
//    var images: [String]
}
