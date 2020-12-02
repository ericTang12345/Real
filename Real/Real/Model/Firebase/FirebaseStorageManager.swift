//
//  FirebaseStorageManager.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/2.
//

import Firebase

enum StorageFolder: String {
    
    case user = "User"
    
    case post = "Post"
}

class FirebaseStorageManager {
    
    static let shared = FirebaseStorageManager()
    
    private init() {}
    
    func uploadImage(image: UIImage , folder: StorageFolder, id: String?, handler: @escaping (Result<String>) -> Void) {
        
        let storageRef = Storage.storage().reference().child(folder.rawValue).child(id ?? NSUUID().uuidString)
        
        guard let data = image.pngData() else { return }
        
        storageRef.putData(data, metadata: nil) { (data, error) in
            
            if error != nil {
                
                handler(.failure(error!))
                
                print("Storage reference putData error: \(error!.localizedDescription)")
                
                return
            }
            
            storageRef.downloadURL { (url, error) in
                
                if error != nil {
                    
                    handler(.failure(error!))
                    
                    print("Storage reference download error: \(error!.localizedDescription)")
                    
                    return
                }
                
                guard let url = url else {
                    
                    handler(.failure(error!))
                    
                    print("Storage reference download url error: \(error!.localizedDescription)")
                    
                    return
                }
            
                handler(.success(url.absoluteString))
            }
        }
    }
}
