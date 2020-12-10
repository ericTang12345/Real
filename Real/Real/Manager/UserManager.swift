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
    
    let group = DispatchGroup()
    
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
    
        let doc = self.firebase.getCollection(name: .user).document(id)
        
        let data = User(
            id: id,
            randomName: "",
            randomImage: "",
            blockadeListUser: [],
            blockadeListPost: [],
            registerTime: FIRTimestamp()
        )
        
        self.firebase.save(to: doc, data: data)
        
        // update random name and image
    }
}

// MARK: - update random user profile everyday

extension UserManager {
    
    func randomGet(list: [String]) -> String {
        
        if list.count != 0 {
            
            let random = Int.random(in: 0...list.count-1)
            
            return list[random]
            
        } else {
            
            return .empty + "403"
        }
    }
    
    // MARK: - Name
    
    func switchNameAndImage(id: String) {
    
        var mainName: String?
        
        var adjName: String?
        
        group.enter()
        
        self.getRandomMainName { name in
            
            mainName = name
            
            self.group.leave()
        }
        
        group.enter()
        
        self.getRandomAdjName { name in
            
            adjName = name
            
            self.group.leave()
        }
        
        group.notify(queue: .main) {
            
            guard let main = mainName, let adj = adjName else {
                
                print("main name or adj name is nil")
                
                return
            }
            
            let fullName = adj + " " + main
            
            let doc = self.firebase.getCollection(name: .user).document(id)
            
            doc.updateData(["randomName": fullName])
        }
    }
    
    func getRandomMainName(handler: @escaping (String) -> Void) {
        
        firebase.read(collectionName: .randomMainName, dataType: RandomMainName.self) { (result) in
            
            switch result {
            
            case .success(let data) :
                
                let list = data.map { return $0.name }
                
                handler(self.randomGet(list: list))
            
            case .failure(let error):
                
                print("read random main name fail in userManager", error.localizedDescription)
            }
        }
    }
    
    func getRandomAdjName(handler: @escaping (String) -> Void) {
        
        firebase.read(collectionName: .randomAdjName, dataType: RandomAdjName.self) { (result) in
            
            switch result {
            
            case .success(let data):
                
                let list = data.map { return $0.name }
                
                handler(self.randomGet(list: list))
            
            case .failure(let error):
            
                print("read random adj name fail in userManager", error.localizedDescription)
            }
        }
    }
    
    // MARK: - Image
    
    func getRandomImage() {
        
        firebase.read(collectionName: .randomImage, dataType: RandomImage.self) { (result) in
            
            switch result {
            
            case .success(let data):
            
                let list = data.map { return $0.url }
                
                let urlStr = self.randomGet(list: list)

                print(urlStr)
            
            case .failure(let error):
                
                print("read random image fail", error.localizedDescription)
            }
        }
    }
}
