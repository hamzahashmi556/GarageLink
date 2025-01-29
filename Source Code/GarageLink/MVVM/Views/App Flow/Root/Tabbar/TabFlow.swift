//
//  TabFlow.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import SwiftUI

struct TabbarView: View {
    
    @State var selectedTab: Int = 0
    
    var body: some View {
        
        
        TabView {
            HomeView()
                .tag(0)
                .tabItem({
                    Label("Home", systemImage: selectedTab == 0 ? "house.fill" : "house")
                })
            
            ProfileView()
                .tag(1)
                .tabItem({
                    Label("Profile", systemImage: selectedTab == 1 ? "person.fill" : "person")
                })

        }
    }
}
