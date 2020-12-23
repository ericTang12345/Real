//
//  FirebaseManager.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/1.
//

import Firebase
import FirebaseFirestoreSwift

typealias FIRFieldValue = Firebase.FieldValue

typealias FIRTimestamp = Timestamp

typealias FIRDocRef = Firebase.DocumentReference

typealias FIRStore = Firebase.Firestore

//typealias Res<T:Codable> = ((Result<[T]>) -> Void)

//protocol Response {
//
//    associatedtype Decoder
//
//    func decode(_ dataType: Decoder)
//}
//
//class Eric: Response {
//
//    typealias Decoder = Codable
//
//    func decode(_ dataType: Decoder) {
//        print(dataType)
//    }
//}

enum Result<T> {
    
    case success(T)
    
    case failure(Error)
}

enum CollectionName: String {
    
    case post = "Post"
    
    case user = "User"
    
    case comment = "Comment"
    
    case tag = "Tag"
    
    case chatRoom = "ChatRoom"
    
    case randomAdjName = "RandomAdjName"
    
    case randomMainName = "RandomMainName"
    
    case driftingBottle = "DriftingBottle"
    
    case randomImage = "RandomImage"
}

enum FirebaseError: String, Error {
    
    case decode = "Firebase decode error"
}

struct Filter {
    
    let key: String
    
    let value: Any
}

class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    private init() {}
    
    var currentTimestamp: Timestamp {
        
        return Firebase.Timestamp()
    }

    func getCollection(name: CollectionName) -> CollectionReference {
        
        return Firestore.firestore().collection(name.rawValue)
    }
    
    func listen(collectionName: CollectionName, handler: @escaping () -> Void) {
        
        let collection = getCollection(name: collectionName)
        
        collection.addSnapshotListener { _, _ in
            
            handler()
        }
    }
    
    func listen(doc: DocumentReference, handler: @escaping () -> Void) {
        
        doc.addSnapshotListener { _, _ in
            
            handler()
        }
    }
    
    func listen(collection: CollectionReference, handler: @escaping () -> Void) {
        
        collection.addSnapshotListener { _, _ in
            
            handler()
        }
    }
    
    func read<T: Codable>(collection: CollectionReference, dataType: T.Type, handler: @escaping (Result<[T]>) -> Void) {
        
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
    
    // 過濾單一條件
    
    func read<T: Codable>(collectionName: CollectionName, dataType: T.Type, filter: Filter, handler: @escaping (Result<[T]>) -> Void) {
        
        let collection = getCollection(name: collectionName)
        
        collection.whereField(filter.key, isEqualTo: filter.value).getDocuments { (querySnapshot, error) in
            
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
    
    func readSingle<T: Codable>(_ doc: DocumentReference, dataType: T.Type, handler: @escaping (Result<T>) -> Void) {
        
        doc.getDocument { (documentSnapshot, error) in
            
            guard let docSnapshot = documentSnapshot else {
                
                handler(.failure(error!))
                
                return
            }
            
            guard let data = try? docSnapshot.data(as: dataType) else {
                
                handler(.failure(FirebaseError.decode))
                
                return
            }
            
            handler(.success(data))
        }
    }
    
    func decode<T: Codable>(_ dataType: T.Type, documents: [QueryDocumentSnapshot], handler: @escaping (Result<[T]>) -> Void) {
        
        var datas: [T] = []
        
        for document in documents {
            
            guard let data = try? document.data(as: dataType) else {
                
                handler(.failure(FirebaseError.decode))
                
                return
            }
            
            datas.append(data)
        }
        
        handler(.success(datas))
    }
    
    func save<T: Codable>(to document: DocumentReference, data dataType: T) {
        
        let encoder = Firestore.Encoder()
        
        do {
            
            let data = try encoder.encode(dataType)
            
            document.setData(data)
            
        } catch {
            
            print("Firebase save data error: ", error.localizedDescription)
        }
    }
    
    func update(collectionName: CollectionName, documentId: String, key: String, value: Any) {
        
        let document = getCollection(name: collectionName).document(documentId)
        
        document.updateData([key: value])
    }
}
