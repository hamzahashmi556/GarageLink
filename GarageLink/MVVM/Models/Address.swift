//
//  Address.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import Foundation
import CoreLocation

struct Address: Codable {
    var city: String
    var country: String
    var fullAddress: String
    var zipCode: String
//    var coordinate: Coordinate
}

//struct Coordinate: Codable {
//    var latitude: Double
//    var longitude: Double
//}
