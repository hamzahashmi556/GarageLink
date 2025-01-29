//
//  HomeViewModel.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 08/01/2025.
//

import CoreLocation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var isLoading = false
    
    @Published var userRole: UserRole? = nil
    
    @Published var mechanics: [Mechanic] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        LocationManager.shared.$location
            .receive(on: RunLoop.main)
            .sink { location in
                if location.coordinate.latitude != 0 && location.coordinate.longitude != 0 {
                    self.fetchMechanics(location: location)
                }
            }
            .store(in: &cancellables)
        
        UserManager.shared.$userProfile
            .combineLatest(MechanicManager.shared.$mechanic)
            .receive(on: RunLoop.main)
            .sink { (userProfile, mechanic) in
                if let userProfile {
                    self.userRole = .customer
                }
                else if let mechanic {
                    self.userRole = .mechanic
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetchMechanics(location: CLLocation) {
        Task { @MainActor in
            do {
                let mechanics = try await MechanicManager.shared.fetchMechanics(around: location, radiusInM: 5000)
                
                self.mechanics = mechanics
            }
            catch {
                print(#function, error)
            }
        }
    }
}
