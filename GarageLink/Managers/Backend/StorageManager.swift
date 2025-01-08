//
//  StorageManager.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 08/01/2025.
//


import FirebaseStorage
import UIKit

final class StorageManager {
    
    static let shared = StorageManager()
    
    private init() {}
    
    let ref = Storage.storage().reference()
    
    func uploadImage(image: UIImage) async throws -> URL {
        
        guard let data = image.jpegData(compressionQuality: 0.5) else {
            throw StorageErrorCode.objectNotFound
        }
        
        let ref = self.ref.child("images/\(UUID().uuidString).jpg")
        
        _ = try await ref.putDataAsync(data)
        
        let imageURL = try await ref.downloadURL()
        
        return imageURL
    }
}
