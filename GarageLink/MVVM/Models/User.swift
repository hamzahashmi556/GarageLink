//
//  User.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import Foundation

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

