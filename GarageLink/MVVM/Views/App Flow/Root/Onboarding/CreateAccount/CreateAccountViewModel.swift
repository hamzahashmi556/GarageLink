//
//  CreateAccountViewModel.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import Foundation
import Combine
import UIKit
import Firebase
import CoreLocation

class CreateAccountViewModel: ObservableObject {
    
    @Published var userRole: UserRole = .customer
    
    @Published var selectedImage: UIImage?
    
    @Published var isPresentedPicker = false
    
    @Published var bio = Bio(
        firstName: "",
        lastName: "",
        phoneNumber: "",
        profileImage: ""
    )
    
    @Published var address = Address(
        city: "",
        country: "",
        fullAddress: "",
        zipCode: ""
//        coordinate: Coordinate(latitude: 0, longitude: 0)
    )
    
    @Published var mechanicDetails = MechanicDetails(
        vehicleTypes: [],
        description: "",
        expertise: "",
        experience: ""
    )
        
    @Published var isLoading = false
    
    @Published var location = CLLocation()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        LocationManager.shared.$location
            .receive(on: RunLoop.main)
            .sink { location in
                self.location = location
            }
            .store(in: &cancellables)
        
        LocationManager.shared.$city
            .combineLatest(LocationManager.shared.$country)
            .receive(on: RunLoop.main)
            .sink { (city, country) in
                
                if let city {
                    self.address.city = city
                }
                
                if let country {
                    self.address.country = country
                }
            }
            .store(in: &cancellables)
    }
    
    func create() {
        switch userRole {
        case .customer:
            createCustomer()
        case .mechanic:
            createMechanic()
        }
    }
    
    private func createCustomer() {
        self.isLoading = true
        
        Task { @MainActor in
            do {
                try await UserManager.shared.createCustomer(bio: bio)
            }
            catch {
                AlertManager.shared.showAlert(title: error.localizedDescription)
            }
            self.isLoading = false
        }
    }
    
    private func createMechanic() {
        Task { @MainActor in
            self.isLoading = true
            do {
                try await MechanicManager.shared.create(
                    bio: bio,
                    address: address,
                    details: mechanicDetails,
                    location: location
                )
            }
            catch {
                AlertManager.shared.showAlert(title: error.localizedDescription)
            }
            self.isLoading = false
        }
    }
}
