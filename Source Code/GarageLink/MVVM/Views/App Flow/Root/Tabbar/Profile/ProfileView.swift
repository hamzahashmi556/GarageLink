//
//  ProfileView.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var vm = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    if let userRole = vm.userRole {
                        
                        bioSection(bio: vm.bio)
                        
                        if userRole == .mechanic {
                            addressSection(address: vm.address)
                            
                            mechanicDetailsSection()
                        }
                    }
                    
                    Button("Log out", role: .destructive) {
                        AlertManager.shared.showAlert(
                            title: "Logout?",
                            message: "",
                            alertPrimaryAction: AlertAction(title: "Log Out", action: {
                                try! AuthManager.shared.signOut()
                            })
                        )
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    
                    if vm.isLoading {
                        ProgressView()
                    }
                    else {
                        Button(vm.isEditing ? "Done" : "Edit") {
                            if vm.isEditing {
                                vm.update()
                            }
                            vm.isEditing.toggle()
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func bioSection(bio: Bio) -> some View {
        Section("Bio") {
            
            Button {
                vm.isPresentedPicker.toggle()
            } label: {
                CircleImageView(selectedImage: vm.selectedImage, imageURL: bio.profileImage)
            }
            .sheet(isPresented: $vm.isPresentedPicker) {
                ImagePicker(image: $vm.selectedImage)
            }
            .disabled(!vm.isEditing)
            .frame(maxWidth: .infinity, alignment: .center)
            
            editingField(title: "First Name", placeholder: "Enter First Name", text: $vm.bio.firstName)
            
            editingField(title: "Last Name", placeholder: "Enter Last Name", text: $vm.bio.lastName)

            editingField(title: "Phone Number", placeholder: "Enter Phone number", text: $vm.bio.phoneNumber)
            
            HStack {
                Text("Date of Birth")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.gray)
                    .frame(width: 100, alignment: .leading)
                
                Spacer()
                
                DatePicker("", selection: $vm.bio.dob)
                    .font(.body)
                    .foregroundStyle(.white)
            }
        }
    }
    
    @ViewBuilder
    func addressSection(address: Address) -> some View {
        Section("Address") {
            
            editingField(title: "Enter Address", placeholder: "", text: $vm.address.fullAddress)
            
            editingField(title: "Enter City", placeholder: "", text: $vm.address.city)
            
            editingField(title: "Enter State", placeholder: "", text: $vm.address.country)
            
            editingField(title: "Enter Zip Code", placeholder: "", text: $vm.address.zipCode)
        }
    }
    
    @ViewBuilder
    func mechanicDetailsSection() -> some View {
        Section("Mechanic Details") {
            
            VehicleSelection(mechanicDetails: $vm.mechanicDetails)
            
            editingField(title: "Enter Description", placeholder: "", text: $vm.mechanicDetails.description)
            
            editingField(title: "Enter Expertise", placeholder: "", text: $vm.mechanicDetails.description)
            
            editingField(title: "Enter Experience", placeholder: "", text: $vm.mechanicDetails.description)

        }
    }
    
    @ViewBuilder
    func editingField(title: String, placeholder: String, text: Binding<String>) -> some View {
        
        HStack {
            
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.gray)
                .frame(width: 100, alignment: .leading)
            
//            Spacer()
            
            TextField(placeholder, text: text)
                .font(.body)
                .foregroundStyle(.white)
                .disabled(!vm.isEditing)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
