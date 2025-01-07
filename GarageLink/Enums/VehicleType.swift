//
//  VehicleType.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//


enum VehicleType: String, Codable, CaseIterable, Hashable, Equatable {
    case bikes = "Bikes"
    case electricBikes = "Electric Bikes"
    case electricCars = "Electric Cars"
    case car = "Normal Cars"
    case SUVs = "SUV"
    case truckAndBus = "Heavy Traffic Vehicles e.g Bus, Trucks"
}