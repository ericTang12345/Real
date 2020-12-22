//
//  AppDelegate.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/25.
//

import UIKit
import CoreData
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let userDefaults = UserDefaults.standard
    
    let userManegare = UserManager.shared
    
    let firebase = FirebaseManager.shared
    
    let firbaseAuth = FirebaseAuthManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
//        try? Auth.auth().signOut()
        
        check { uid in
            
            let doc = self.firebase.getCollection(name: .user).document(uid)
            
            self.firebase.listen(doc: doc) {
                
                self.userManegare.getUserData(nil)
            }
        }
        
        return true
    }
    
    func check(handler: @escaping (String) -> Void) {
        
        // 登入成功
        if Auth.auth().currentUser != nil {
            
            let user = Auth.auth().currentUser!
            
            // 讀取 user 資料，檢查是否已經有建過資料
            
            firbaseAuth.readUser(userId: user.uid) { (isHaveData) in
                
                if isHaveData {
                    
                    // 重新設置 userManager
                    self.firbaseAuth.setupUser(id: user.uid)
                
                    handler(user.uid)
                    
                } else {
                    
                    // 如果沒有資料，建立一個新的 userData
                    self.userManegare.createUser(id: user.uid)
                    
                    handler(user.uid)
                }
            }
            
        } else {
            
            print("user is not sign in")
            
            let uid = UUID().uuidString
            
            self.userManegare.createUser(id: uid)
            
            userDefaults.set(uid, forKey: .userID)
            
            handler(uid)
        }
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Real")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
