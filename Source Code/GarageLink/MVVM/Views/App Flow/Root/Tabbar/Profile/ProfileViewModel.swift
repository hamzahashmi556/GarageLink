//
//  ProfileViewModel.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 08/01/2025.
//

import UIKit
import Combine
import CoreLocation

class ProfileViewModel: ObservableObject {
    
    @Published var isLoading = false
    
    @Published var isEditing = false
    
    @Published var selectedImage: UIImage? = nil
    
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
    )
    
    @Published var mechanicDetails = MechanicDetails(
        vehicleTypes: [],
        description: "",
        expertise: "",
        experience: ""
    )
    
    @Published var location = CLLocation()
    
    @Published var userRole: UserRole?
    
    @Published var isPresentedPicker = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        UserManager.shared.$userProfile
            .combineLatest(MechanicManager.shared.$mechanic)
            .receive(on: RunLoop.main)
            .sink { (userProfile, mechanic) in
                if let userProfile {
                    self.bio = userProfile.bio
                    self.userRole = .customer
                }
                else if let mechanic {
                    self.bio = mechanic.bio
                    self.address = mechanic.address
                    self.mechanicDetails = mechanic.details
                    self.userRole = .mechanic
                }
            }
            .store(in: &cancellables)
        
        LocationManager.shared.$location
            .receive(on: RunLoop.main)
            .sink { location in
                self.location = location
            }
            .store(in: &cancellables)
    }
    
    func update() {
        self.isLoading = true
        
        Task { @MainActor in
        
            do {
                
                var url = String()
                
                if let selectedImage {
                    url = try await StorageManager.shared.uploadImage(image: selectedImage).absoluteString
                }
                
                bio.profileImage = url
                
                if userRole == .customer {
                    try await UserManager.shared.createCustomer(
                        bio: bio
                    )
                }
                else if userRole == .mechanic {
                    try await MechanicManager.shared.create(
                        bio: bio,
                        address: address,
                        details: mechanicDetails,
                        location: location
                    )
                }
            }
            catch {
                AlertManager.shared.showAlert(title: "Error", message: error.localizedDescription)
            }
            self.isLoading = false
        }
    }
}
