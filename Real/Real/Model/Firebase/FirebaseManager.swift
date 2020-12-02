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

//typealias Database = FirebaseManager

class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    private init() {}
    
    private func getCollection(name: CollectionName) -> CollectionReference {
        
        switch name {
        
        case .post: return Firestore.firestore().collection(name.rawValue)
        
        }
    }
    
    func listen(collectionName: CollectionName, handler: @escaping () -> Void) {
        
        let collection = getCollection(name: collectionName)
        
        collection.addSnapshotListener { (_, _) in
  
            handler()
        }
    }
    
    func read<T: Codable>(collectionName: CollectionName, dataType: T.Type, handler: @escaping (Result<[T]>) -> Void) {
        
        let collection = getCollection(name: collectionName)
        
        collection.getDocuments { (querySnapshot, error) in
            
            guard let querySnapshot = querySnapshot else {
                
                handler(.failure(error!))
                
                return
            }
            
            self.decode(dataType, documents: querySnapshot.documents) { (result) in
                
                switch result {
                
                case .success(let data): handler(.success(data))
                    
                case .failure(let error): handler(.failure(error))
                
                }
            }
        }
    }
    
    func decode<T: Codable>(_ datatype: T.Type, documents: [QueryDocumentSnapshot], handler: @escaping (Result<[T]>) -> Void) {
        
        let datas: [T] = documents.map { (document) -> T in
            
            do {
                
                return try document.data(as: datatype)!
                
            } catch {
                
                handler(.failure(error))
                
                fatalError(error.localizedDescription)
            }
        }
        
        handler(.success(datas))
    }
}
