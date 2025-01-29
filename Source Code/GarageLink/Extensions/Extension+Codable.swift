//
//  Extension+Codable.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import Firebase

extension Encodable {
    
    func setDataInFirestore(documentReference ref: DocumentReference) async throws {
        return try await withUnsafeThrowingContinuation { continuation in
            do {
                try ref.setData(from: self, completion: { error in
                    if let error {
                        continuation.resume(throwing: error)
                    }
                    else {
                        continuation.resume()
                    }
                })
            }
            catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
