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
    
    let firebaseAuth = FirebaseAuthManager()
    
    let group = DispatchGroup()
    
    var userData: User? {
        
        didSet {
            
            NotificationCenter.default.post(name: .userDataUpdated, object: nil)
        }
    }
    
    var isSignin: Bool {
        
        return Auth.auth().currentUser != nil
    }
    
    func showAlert(viewController: UIViewController) -> UIAlertController {
        
        let alert = UIAlertController(title: "尚未登入", message: "完成登入，可以立即啟用喜愛、回應、發文等功能哦！", preferredStyle: .actionSheet)
        
        alert.view.tintColor = .gray
        
        let done = UIAlertAction(title: "立即登入", style: .default) { (_) in
            
            self.firebaseAuth.performSignin(viewController)
        }
        
        alert.addAction(done)
        
        let cancel = UIAlertAction(title: "稍後再說", style: .default)
        
        alert.addAction(cancel)
        
        return alert
    }
    
    func createUser(id: String) {
    
        let doc = firebase.getCollection(name: .user).document(id)
        
        let data = User(id: id)
        
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
    
}

extension UserManager {
    
    // 切換名稱與圖片
    func switchNameAndImage() {
    
        var mainName: String?
        
        var adjName: String?
        
        var urlStr: String?
        
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
        
        group.enter()
        
        self.getRandomImage { (urlString) in
            
            urlStr = urlString
            
            self.group.leave()
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
