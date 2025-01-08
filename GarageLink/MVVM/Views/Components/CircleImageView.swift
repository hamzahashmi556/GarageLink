//
//  CircleImageView.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 08/01/2025.
//


import Kingfisher
import SwiftUI

struct CircleImageView: View {
    
    let selectedImage: UIImage?
    
    let imageURL: String?
    
    var size: CGFloat = 100
    
    var body: some View {
        if let selectedImage {
            Image(uiImage: selectedImage)
                .resizable()
                .frame(width: size, height: size)
                .aspectRatio(contentMode: .fill)
                .clipShape(.circle)
        }
        else if let imageURL, let url = URL(string: imageURL) {
            KFImage(url)
                .resizable()
                .frame(width: size, height: size)
                .aspectRatio(contentMode: .fill)
                .clipShape(.circle)
        }
        else {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: size, height: size)
                .aspectRatio(contentMode: .fill)
                .clipShape(.circle)
        }
    }
}
