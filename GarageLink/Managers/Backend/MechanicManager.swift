//
//  UserManager 2.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreInternal
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
        
        let snapshot = try await ref.getDocuments()
        let documents = snapshot.documents
        let mechanics = documents.compactMap({
            try? $0.data(as: Mechanic.self)
        })
        return mechanics

        
        
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
                
        let documents = snapshot.documents
        
        print(documents.isEmpty ? "No documents found" : "Found \(snapshot.documents.count) documents")
        
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
    
    func storeHash() async throws {
        
        let db = Firestore.firestore()
        
        // Compute the GeoHash for a lat/lng point
        let latitude = 51.5074
        let longitude = 0.12780
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let hash = GFUtils.geoHash(forLocation: location)
        
        // Add the hash and the lat/lng to the document. We will use the hash
        // for queries and the lat/lng for distance comparisons.
        let documentData: [String: Any] = [
            "geohash": hash,
            "lat": latitude,
            "lng": longitude
        ]
        
        let londonRef = db.collection("cities").document("LON")
        try await londonRef.setData(documentData)
    }
    /*
    func get() async throws {
        // Find cities within 50km of London
        let center = CLLocationCoordinate2D(latitude: 51.5074, longitude: 0.1278)
        let radiusInM: Double = 50 * 1000
        
        // Each item in 'bounds' represents a startAt/endAt pair. We have to issue
        // a separate query for each pair. There can be up to 9 pairs of bounds
        // depending on overlap, but in most cases there are 4.
        let queryBounds = GFUtils.queryBounds(forLocation: center,
                                              withRadius: radiusInM)
        let queries = queryBounds.map { bound -> Query in
            return Firestore.firestore().collection("cities")
                .order(by: "geohash")
                .start(at: [bound.startValue])
                .end(at: [bound.endValue])
        }
        
        
        
        // After all callbacks have executed, matchingDocs contains the result. Note that this code
        // executes all queries serially, which may not be optimal for performance.
        do {
            let matchingDocs = try await withThrowingTaskGroup(of: [QueryDocumentSnapshot].self) { group -> [QueryDocumentSnapshot] in
                for query in queries {
                    group.addTask {
                        try await self.fetchMatchingDocs(from: query, center: center, radiusInM: radiusInM)
                    }
                }
                var matchingDocs = [QueryDocumentSnapshot]()
                for try await documents in group {
                    matchingDocs.append(contentsOf: documents)
                }
                return matchingDocs
            }
            
            print("Docs matching geoquery: \(matchingDocs)")
        } catch {
            print("Unable to fetch snapshot data. \(error)")
        }
    }
    
    @Sendable func fetchMatchingDocs(from query: Query,
                                     center: CLLocationCoordinate2D,
                                     radiusInM: Double) async throws -> [QueryDocumentSnapshot] {
        let snapshot = try await query.getDocuments()
        
        let documents = snapshot.documents
        // Collect all the query results together into a single list
        return documents.filter { document in
            let lat = document.data()["lat"] as? Double ?? 0
            let lng = document.data()["lng"] as? Double ?? 0
            let coordinates = CLLocation(latitude: lat, longitude: lng)
            let centerPoint = CLLocation(latitude: center.latitude, longitude: center.longitude)
            
            // We have to filter out a few false positives due to GeoHash accuracy, but
            // most will match
            let distance = GFUtils.distance(from: centerPoint, to: coordinates)
            return distance <= radiusInM
        }
    }
     */
}
