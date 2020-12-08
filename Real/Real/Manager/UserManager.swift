//
//  UserManager.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/9.
//

import Firebase

class UserManager {
    
    static let shared = UserManager()
    
    private init() {}
    
    let firebase = FirebaseManager.shared
    
    let userDefaults = UserDefaults.standard
    
    var isSignin: Bool {
        
        return Auth.auth().currentUser?.uid != nil
    }
    
    var userID: String? {
        
        if isSignin {
            
            guard let id = userDefaults.value(forKey: "UserID") as? String else {
                
                print("userDefaults key: UserID, value is nil")
                
                return nil
            }
            
            return id
            
        } else {
            
            print("use is not sign in")
            
            return nil
        }
    }
    
    func createUser(id: String) {
        
        userDefaults.setValue(id, forKey: "UserID")
        
        userDefaults.synchronize()
    
        let doc = self.firebase.getCollection(name: .user).document(id)
        
        let data = User(
            id: id,
            randomName: getRandomName(),
            randomImage: getRandomImage(),
            blockadeListUser: [],
            blockadeListPost: [],
            registerTime: FIRTimestamp()
        )
        
        self.firebase.save(to: doc, data: data)
    }
    
    func getRandomName() -> String {
        
        return "選擇困難的 鴛鴦奶茶"
    }
    
    func getRandomImage() -> String {
        
        return "https://www.youtube.com"
    }
}
