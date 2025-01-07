//
//  UserManager 2.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import FirebaseAuth
import FirebaseFirestore
import Firebase
import CoreLocation
import GeoFire
import GeoFireUtils

final class MechanicManager {
    
    static let shared = MechanicManager()
    
    private let ref = Firestore.firestore().collection("mechanics")
    
    private var listener: ListenerRegistration? = nil
    
    @Published var mechanic: Mechanic?
    
    @Published var mechanics: [Mechanic] = []
    
    private init() {
        _ = Auth.auth().addStateDidChangeListener({ auth, user in
            if user == nil {
                self.removeListener()
            }
            else {
                self.fetchListener()
            }
        })
    }
    
    func create(bio: Bio, address: Address, details: MechanicDetails, location: CLLocation) async throws {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let hash = GFUtils.geoHash(forLocation: location.coordinate)
        
        let mechanic = Mechanic(
            bio: bio,
            address: address,
            details: details,
            geoPoint: location.toGeoPoint(),
            geoHash: hash,
            lat: location.coordinate.latitude,
            lng: location.coordinate.longitude
        )
        
        let json = try Firestore.Encoder().encode(mechanic)
        
        print(json)
        
        try await ref.document(uid).setData(json)
        
//        try await mechanic.setDataInFirestore(documentReference: ref.document(uid))
        
        self.mechanic = mechanic
    }
    
    private func fetchListener() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            //            debugPrint(#function, AuthErrorCode(.userNotFound))
            return
        }
        
        self.listener = self.ref.document(uid).addSnapshotListener { document, error in
            if let document = document {
                do {
                    let user = try document.data(as: Mechanic.self)
                    
                    self.mechanic = user
                }
                catch {
                    debugPrint(#function, error)
                }
                self.mechanic = try? document.data(as: Mechanic.self)
            }
        }
    }
    
    private func removeListener() {
        self.listener?.remove()
        self.listener = nil
    }
    
    // MARK: - For Customers
    
    func fetchMechanics(around location: CLLocation, radiusInM radius: Double) async throws -> [Mechanic] {
        
        let center = location.coordinate
        
        let queryBounds = GFUtils.queryBounds(
            forLocation: center,
            withRadius: radius
        )
        
        let queries = queryBounds.map { bound -> Query in
            return ref
                .order(by: "geohash")
                .start(at: [bound.startValue])
                .end(at: [bound.endValue])
        }
        
        do {
            let matchingDocs = try await withThrowingTaskGroup(of: [Mechanic].self) { group -> [Mechanic] in
                for query in queries {
                    group.addTask {
                        try await self.fetchMatchingDocs(from: query, center: center, radiusInMeters: radius)
                    }
                }
                var matchingDocs = [Mechanic]()
                for try await documents in group {
                    matchingDocs.append(contentsOf: documents)
                }
                return matchingDocs
            }
            print("Docs matching geoquery: \(matchingDocs)")
            return matchingDocs

        }
        catch {
            print("Unable to fetch snapshot data. \(error)")
            throw error
        }
    }
    
    @Sendable
    private func fetchMatchingDocs(from query: Query, center: CLLocationCoordinate2D, radiusInMeters: Double) async throws -> [Mechanic] {
        
        let snapshot = try await query.getDocuments()
        
        
        let parsedMechanics = snapshot.documents.compactMap({ try? $0.data(as: Mechanic.self) })
        
        let nearestMechanics = parsedMechanics.filter({ model in
            
            let coordinates = CLLocation(latitude: model.lat, longitude: model.lng)
            
            let centerPoint = CLLocation(latitude: center.latitude, longitude: center.longitude)
            
            let distance = GFUtils.distance(from: centerPoint, to: coordinates)
            
            return distance <= radiusInMeters
        })
        
        return nearestMechanics
        /*
        // Collect all the query results together into a single list
        return snapshot.documents.filter { document in
            let lat = document.data()["lat"] as? Double ?? 0
            let lng = document.data()["lng"] as? Double ?? 0
            let coordinates = CLLocation(latitude: lat, longitude: lng)
            let centerPoint = CLLocation(latitude: center.latitude, longitude: center.longitude)
            
            // We have to filter out a few false positives due to GeoHash accuracy, but
            // most will match
            let distance = GFUtils.distance(from: centerPoint, to: coordinates)
            return distance <= radiusInMeters
        }
        */
    }
    
//    func fetchMechanics(around location: CLLocation, radius: Double) async -> [Mechanic] {
//        
//        let center = location.coordinate
//        
//        // radius in meters
//        let geoHashQueryBounds = GFUtils.queryBounds(forLocation: center, withRadius: radius * 1000)
//        
//        var mechanics: [Mechanic] = []
//        
//        for bound in geoHashQueryBounds {
//            do {
//                let documents = try await ref.order(by: "location.geoHash")
//                    .start(at: [bound.startValue])
//                    .end(at: [bound.endValue])
//                    .getDocuments()
//                    .documents
//                
//                for document in documents {
//                    
//                    do {
//                        let mechanic = try document.data(as: Mechanic.self)
//                        
//                        let geoPoint = mechanic.location
//                        
//                        let geoHash = String(geoPoint.hash)
//                        
//                        let distance = GFUtils.distance(
//                            from: location,
//                            to: CLLocation(
//                                latitude: mechanic.location.latitude,
//                                longitude: mechanic.location.longitude
//                            )
//                        )
//                        
//                        if distance <= radius {
//                            mechanics.append(mechanic)
//                        }
//                        
////                        let geoHash = document.data()["location.geoHash"] as? String ?? ""
//                    }
//                    catch {
//                        
//                    }
//                    let geoHash = document.data()["location.geoHash"] as? String ?? ""
//                    let documentLocation = document.data()["location"] as? GeoPoint
////                    let distance = GFUtils.distance(from: center, to: documentLocation)
//                    
//                    // Filter by exact radius
////                    if distance <= radius {
////                        if let mechanic = try? document.data(as: Mechanic.self) {
////                            mechanics.append(mechanic)
////                        }
////                    }
//                }
//            }
//            catch {
//                print("Error fetching mechanics: \(error.localizedDescription ?? "")")
//            }
//        }
//        
//        return mechanics
//    }
}
