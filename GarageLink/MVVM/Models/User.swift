//
//  User.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import Foundation
import CoreLocation

struct Mechanic: Codable {
    var bio: Bio
    var address: Address
    var details: MechanicDetails
}

struct MechanicDetails: Codable {
    var vehicleTypes: [VehicleType]
    var description: String
    var expertise: String
    var experience: String
    var images: [String]
}

struct Appuser: Codable {
    var bio: Bio
}

struct Bio: Codable {
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var dob: Date = Date()
    var profileImage: String
}

struct Address: Codable {
    var city: String
    var country: String
    var fullAddress: String
    var zipCode: String
    var coordinate: Coordinate
}

struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
}

enum VehicleType: String, Codable, CaseIterable, Hashable, Equatable {
    case bikes = "Bikes"
    case electricBikes = "Electric Bikes"
    case electricCars = "Electric Cars"
    case car = "Normal Cars"
    case SUVs = "SUV"
    case truckAndBus = "Heavy Traffic Vehicles e.g Bus, Trucks"
}
