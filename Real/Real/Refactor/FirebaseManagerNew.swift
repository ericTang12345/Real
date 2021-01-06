//
//  FirebaseManager.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/30.
//

import Firebase

enum FirebaseError: String, Error {
    
    case decode = "Firebase decode error"
}

enum FirebaseRef {
    
    case collection(CollectionReference)
    
    case document(DocumentReference)
}

class FirebaseManagerNew {
    
    static let shared = FirebaseManagerNew()
    
    private init() {}
    
    func getCollection(name: CollectionName) -> CollectionReference {
        
        return FIRStore.firestore().collection(name.rawValue)
    }
    
    func listen<T: Codable>(ref: FirebaseRef, dataType: T.Type, handler: @escaping (Result<[T]>) -> Void) {
        
        switch ref {
        
        case .collection(let ref):
            
            ref.addSnapshotListener { (querySnapshot, error) in
                
                guard let docs = querySnapshot?.documents else {
                    
                    handler(.failure(error!))
                    
                    return
                }
                
                self.decode(dataType, docs: docs) { (result) in
                    
                    switch result {
                    
                    case .success(let data):
                        
                        handler(.success(data))
                        
                    case .failure(let error):
                    
                        handler(.failure(error))
                    }
                }
            }
            
        case .document(let ref):
            
            ref.addSnapshotListener { (doc, error) in
                
                guard let data = try? doc?.data(as: dataType) else {
                    
                    handler(.failure(FirebaseError.decode))
                    
                    return
                }
                
                handler(.success([data]))
            }
        }
    }
    
    func read<T: Codable>(ref: FirebaseRef, dataType: T.Type, handler: @escaping (Result<[T]>) -> Void) {
        
        switch ref {
        
        case .collection(let ref):
        
            ref.getDocuments { (querySnapshot, error) in
                
                guard let docs = querySnapshot?.documents else {
                    
                    handler(.failure(error!))
                    
                    return
                }
                
                self.decode(dataType, docs: docs) { (result) in
                    
                    switch result {
                    
                    case .success(let data): handler(.success(data))
                        
                    case .failure(let error): handler(.failure(error))
                        
                    }
                }
            }
            
        case .document(let ref):
            
            ref.getDocument { (documentSnapshot, error) in
                
                guard let data = try? documentSnapshot?.data(as: dataType) else {
                    
                    handler(.failure(FirebaseError.decode))
                    
                    return
                }
                
                handler(.success([data]))
            }
        }
    }
    
    func filter<T: Codable>(query: Query, dataType: T.Type, handler: @escaping (Result<[T]>) -> Void) {
        
        query.getDocuments { (querySnapshot, error) in
            
            guard let docs = querySnapshot?.documents else {
                
                handler(.failure(error!))
                
                return
            }
            
            self.decode(dataType, docs: docs) { (result) in
                
                switch result {
                
                case .success(let data): handler(.success(data))
                
                case .failure(let error): handler(.failure(error))
                    
                }
            }
        }
    }
    
    func decode<T: Codable>(_ dataType: T.Type, docs: [QueryDocumentSnapshot], handler: @escaping (Result<[T]>) -> Void) {
        
        var datas: [T] = []
        
        for doc in docs {
            
            guard let data = try? doc.data(as: dataType) else {
                
                handler(.failure(FirebaseError.decode))
                
                return
            }
            
            datas.append(data)
        }
        
        handler(.success(datas))
    }
}
