//
//  AppDelegate.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/25.
//

import UIKit
import CoreData
import Firebase
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let userDefaults = UserDefaults.standard

    let firebase = FirebaseManager.shared
    
    let firebaseNew = FirebaseManagerNew.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FirebaseApp.configure()

        register(application)
        
        guard let userId = Auth.auth().currentUser?.uid else { return true }
        
        listenUser(id: userId)
        
        listenDriftBottle(id: userId)

//        try? Auth.auth().signOut()

        return true
    }

    // MARK: - Request to firebase get all drifting bottle arrivalt time

    // MARK: Listen User function
    
    func listenUser(id: String) {
        
        let doc = firebase.getCollection(name: .user).document(id)
        
        firebaseNew.listen(ref: .document(doc), dataType: User.self) { (result) in
            
            switch result {
            
            case .success(let users):
                
                if users.count == 1 {
                    
                    UserManager.shared.userData = users[0]
                }
        
            case .failure(let error):
            
                print("AppDelegate.swift function Name listenUser error: \(error.localizedDescription)")
            }
        }
    }
    
    func listenDriftBottle(id: String) {
        
        self.firebase.listen(collectionName: .driftingBottle) {
            
            DriftingBottleManager.shared.requestData(id: id)
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

// MARK: - Push Notification Center Delegate

extension AppDelegate: UNUserNotificationCenterDelegate {

    func register(_ application: UIApplication) {

        UNUserNotificationCenter.current().delegate = self

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .carPlay], completionHandler: { (granted, error) in

            if granted {

                print("允許")

            } else {

                print("不允許")
            }
        })

        // 註冊遠程通知
        application.registerForRemoteNotifications()
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        print("在前景收到通知...")

        completionHandler([.banner, .badge, .sound])
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})

        print("deviceTokenString: \(deviceTokenString)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

        print("error: \(error)")
    }
}
