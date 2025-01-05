//
//  CreateAccountScreen.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import SwiftUI

struct CreateAccountView: View {
        
    @StateObject private var vm = CreateAccountViewModel()
        
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(spacing: 20) {
                    
                    
                    Picker("", selection: $vm.userRole) {
                        Text("Customer")
                            .tag(UserRole.customer)
                        
                        Text("Mechanic")
                            .tag(UserRole.mechanic)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("Bio")
                            .font(.title)
                            .bold()
                        
                        AppTextField("Enter your first name", text: $vm.bio.firstName)
                                                
                        AppTextField("Enter your last name", text: $vm.bio.lastName)
                        
                        DatePicker.init("Date of Birth", selection: $vm.bio.dob, displayedComponents: [.date])
                        
                        AppTextField("Enter Phone Number", text: $vm.bio.phoneNumber)
                            .keyboardType(.phonePad)
                    }
                    
                    
                    if vm.userRole == .mechanic {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Text("Mechanic Details")
                                .font(.title)
                                .bold()
                            
                            Text("Select Vehicles you can work on")
                            
                            ForEach(VehicleType.allCases, id: \.rawValue) { vehicle in
                                
                                Button {
                                    vm.updateVehicle(vehicle)
                                } label: {
                                    HStack {
                                        
                                        if vm.mechanicDetails.vehicleTypes.contains(where: { $0 == vehicle }) {
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
                            
                            AppTextEditor(titleKey: "Enter Description", text: $vm.mechanicDetails.description)
                            
                            AppTextEditor(titleKey:"Enter Your Expertise", text: $vm.mechanicDetails.expertise)
                            
                            AppTextField("Enter Your Experience", text: $vm.mechanicDetails.experience)
                                .keyboardType(.numberPad)
                        }

                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Address")
                                .font(.title)
                                .bold()

                            AppTextField("Enter Your City", text: $vm.address.city)
                            
                            AppTextField("Enter Your Country", text: $vm.address.country)
                            
                            AppTextField("Enter Your Address", text: $vm.address.fullAddress)
                            
                            AppTextField("Enter Your Zipcode", text: $vm.address.zipCode)

                        }
                    }
                    
                    AppButton(title: "Continue", isLoading: vm.isLoading) {
                        vm.create()
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(UIColor.systemGray6))
                }
                .padding()
            }
            .navigationTitle("Create Account")
            .scrollDismissesKeyboard(.interactively)
            .attachDoneOnKeyboard()
        }
    }
}
