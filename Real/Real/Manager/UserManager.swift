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
    
    var userData: User? {
        
        didSet {
            
            NotificationCenter.default.post(name: .userDataUpdated, object: nil)
        }
    }
    
    var isSignin: Bool {
        
        return Auth.auth().currentUser != nil
    }
    
    func createUser(id: String) {
        
        let doc = firebase.getCollection(name: .user).document(id)
        
        var data = User(id: id)
        
        data.isReceiveDriftingBottle = isSignin
        
        firebase.save(to: doc, data: data)
        
        userData = data
        
        switchNameAndImage()
    }
    
    func getUserData(_ handler: (() -> Void)?) {
        
        guard let user = userData else { return }
        
        let doc = firebase.getCollection(name: .user).document(user.id)
        
        firebase.readSingle(doc, dataType: User.self) { [weak self] result in
            
            switch result {
            
            case .success(let user):
                
                self?.userData = user
                
                NotificationCenter.default.post(name: .userDataUpdated, object: nil)
                
            case .failure(let error):
                
                print("get user data fail", error.localizedDescription)
            }
        }
    }
    
    func setupUser(id: String) {
        
        let doc = firebase.getCollection(name: .user).document(id)
        
        firebase.readSingle(doc, dataType: User.self) { (result) in
            
            switch result {
            
            case .success(let user):
                
                self.userData = user
            
            case .failure(let error):
            
                print("App delegate setup user data", error.localizedDescription)
            }
        }
    }
}

extension UserManager {
    
    // 切換名稱與圖片
    func switchNameAndImage() {
    
        let group = DispatchGroup()
        
        var mainName: String?
        
        var adjName: String?
        
        var urlStr: String?
        
        group.enter()
        
        self.getRandomMainName { name in
            
            mainName = name
            
            group.leave()
        }
        
        group.enter()
        
        self.getRandomAdjName { name in
            
            adjName = name
            
            group.leave()
        }
        
        group.enter()
        
        self.getRandomImage { (urlString) in
            
            urlStr = urlString
            
            group.leave()
        }
        
        group.notify(queue: .main) {
            
            guard let main = mainName,
                  let adj = adjName,
                  let url = urlStr
            else {

                print("main name or adj name is nil")
                
                return
            }
            
            let fullName = adj + " " + main
            
            guard let user = self.userData else { return }
            
            let doc = self.firebase.getCollection(name: .user).document(user.id)
            
            doc.updateData(["randomName": fullName, "randomImage": url])
            
            self.getUserData(nil)
        }
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
    
    // 取隨機名詞
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
    
    // 取隨機形容詞
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
    
    // 取隨機圖片
    func getRandomImage(handler: @escaping (String) -> Void) {
        
        firebase.read(collectionName: .randomImage, dataType: RandomImage.self) { (result) in
            
            switch result {
            
            case .success(let data):
            
                let list = data.map { return $0.url }
                
                handler(self.randomGet(list: list))
                
            case .failure(let error):
                
                print("read random image fail in userManager", error.localizedDescription)
            }
        }
    }
}
