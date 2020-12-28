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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FirebaseApp.configure()

        register(application)
//
//        userDefaults.remove(forKey: .userID)
//
//        try? Auth.auth().signOut()
        
        // 檢查完帳號後，開始監聽，只要有任何關於這個 user 的資料變動，都會去更新 UserManager 中的 userData
        check { uid in

            let doc = self.firebase.getCollection(name: .user).document(uid)

            self.firebase.listen(doc: doc) {

                UserManager.shared.getUserData(nil)
            }

            self.firebase.listen(collectionName: .driftingBottle) {

                self.requestDriftingBottle(id: uid)
            }
        }

        return true
    }

    func requestDriftingBottle(id: String) {

        firebase.getCollection(name: .driftingBottle)
            .whereField("isPost", isEqualTo: true)
            .whereField("isCatch", isEqualTo: false)
            .whereField("catcher", isEqualTo: id)
            .getDocuments { (querySnapshot, error) in

            if error != nil { print("error: ", error!.localizedDescription) }

            guard let query = querySnapshot else { return }

            self.firebase.decode(DriftingBottle.self, documents: query.documents) { (result) in

                switch result {

                case .success(let data):

                    for item in data {

                        guard let arrivaltTime = item.arrivalTime else { return }

                        if arrivaltTime.dateValue() > FIRTimestamp().dateValue() {

                            self.calculateTime(driftingBottle: item)
                        }
                    }

                case .failure(let error):

                    print("AppDelegate read drifting bottle", error.localizedDescription)

                }
            }
        }
    }

    func calculateTime(driftingBottle: DriftingBottle) {

        guard let arrivalTime = driftingBottle.arrivalTime else { return }

        dump(driftingBottle)

        let currentDate = FIRTimestamp().dateValue()

        let distance = currentDate.distance(to: arrivalTime.dateValue())

        setNotification(distance: distance, id: driftingBottle.id)

        print("距離:", distance)
    }

    func setNotification(distance: TimeInterval, id: String) {

        let content = UNMutableNotificationContent()

        content.body = "有漂流瓶抵達了，趕緊去看看吧！"

        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: distance, repeats: false)

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            print("成功建立通知...")
        })
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

// MARK: - Check User Function

extension AppDelegate {

    func check(handler: @escaping (String) -> Void) {

        // 檢查現在是否是登入狀態
        if UserManager.shared.isSignin {

            // 登入狀態的話，讀取資料帶進 UserManager
            UserManager.shared.setupUser(id: Auth.auth().currentUser!.uid)

            handler(Auth.auth().currentUser!.uid)

        } else {

            guard let userId = userDefaults.string(forKey: .userID) else {

                // 不是登入狀態就先生成一個預設帳號
                let uid = UUID().uuidString

                // 在 firebase 建立一個預設帳號
                UserManager.shared.createUser(id: uid)

                // 存進 userDefalts 以供使用者如果後續有登入的話 可以知道哪個是預設帳號
                self.userDefaults.set(uid, forKey: .userID)

                handler(uid)

                return
            }

            UserManager.shared.setupUser(id: userId)

            handler(userId)
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
