//
//  FirebaseManager.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/1.
//

import Firebase
import FirebaseFirestoreSwift

enum Result<T> {
    
    case success(T)
    
    case failure(Error)
}

enum CollectionName: String {
    
    case post = "Post"
}

typealias Database = FirebaseManager

class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    private init() {}
    
    // 取得所需的 collection
    
    var collection: ((CollectionName) -> CollectionReference) = shared.getCollection
    
    // 當前 timestamp
    
    static var currentTimeStamp: Timestamp {
        
        return Firebase.Timestamp()
    }
    
    private func getCollection(name: CollectionName) -> CollectionReference {
        
        switch name {
        
        case .post: return Firestore.firestore().collection(name.rawValue)
        
        }
    }
    
    func listen(collectionName: CollectionName, handler: @escaping (Result<QuerySnapshot>) -> Void) {
        
        let collection = getCollection(name: collectionName)
        
        collection.addSnapshotListener { (querySnapshot, error) in
            
            guard let querySnapshot = querySnapshot else {
                
                handler(.failure(error!))
                
                return
            }
            
            handler(.success(querySnapshot))
        }
    }
    
    func read(collectionName: CollectionName, handler: @escaping (Result<QuerySnapshot>) -> Void) {
        
        let collection = getCollection(name: collectionName)
        
        collection.getDocuments { (querySnapshot, error) in
            
            guard let querySnapshot = querySnapshot else {
                
                handler(.failure(error!))
                
                return
            }
            
            handler(.success(querySnapshot))
        }
    }
    
    // 轉換時間戳記
    
    func transformTimestamp(timestamp: Any) -> Date {
        
        guard let timestamp = timestamp as? Timestamp else {
            
            print("轉換時間戳記失敗")
            
            return Date()
        }
        
        return timestamp.dateValue()
    }
}
