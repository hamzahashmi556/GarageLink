//
//  HomeView.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import SwiftUI
import CoreLocation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var isLoading = false
    
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
    }
    
    private func fetchMechanics(location: CLLocation) {
        Task { @MainActor in
            do {
                let mechanics = try await MechanicManager.shared.fetchMechanics(around: location, radiusInM: 500)
                print("Mechanics fetched: \(mechanics.count)")
                mechanics.forEach({print("\n\($0)")})
            }
            catch {
                print(#function, error)
            }
        }
    }
    
}

struct HomeView: View {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some View {
        List {
            Section {
                ForEach(vm.mechanics.indices, id: \.self) { index in
                    let mechanic = vm.mechanics[index]
                    Text("\(mechanic.bio.firstName)  \(mechanic.bio.lastName)")
                }
            }
        }
    }
}
