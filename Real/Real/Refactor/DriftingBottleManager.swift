//
//  DriftingBottleManager.swift
//  Real
//
//  Created by 唐紹桓 on 2021/1/6.
//

import Foundation
import UserNotifications

class DriftingBottleManager {
    
    enum FieldKey: String {
        
        case isPost
        
        case isCatch
        
        case catcher
    }
    
    static let shared = DriftingBottleManager()
    
    private init() {}
    
    let firebase = FirebaseManagerNew.shared
    
    // MARK: Notification
    
    func requestData(id: String) {
        
        let query = firebase.getCollection(name: .driftingBottle)
            .whereField(FieldKey.isPost.rawValue, isEqualTo: true)
            .whereField(FieldKey.isCatch.rawValue, isEqualTo: true)
            .whereField(FieldKey.catcher.rawValue, isEqualTo: id)
        
        firebase.filter(query: query, dataType: DriftingBottle.self) { (result) in
            
            switch result {
            
            case .success(let driftingBottles):
                
                for driftingBottle in driftingBottles {
                    
                    guard let arrivaltTime = driftingBottle.arrivalTime else { return }
                    
                    if arrivaltTime.dateValue() > FIRTimestamp().dateValue() {
                            
                        self.calculateTime(driftingBottle: driftingBottle)
                    }
                }
                
            case .failure(let error):
                
                print("DriftingBottleProvider request error:  \(error.localizedDescription)")
            }
        }
    }
    
    // 計算差距秒數
    
    func calculateTime(driftingBottle: DriftingBottle) {
        
        guard let arrivalTime = driftingBottle.arrivalTime?.dateValue() else { return }
        
        let currentDate = FIRTimestamp().dateValue()
        
        let distance = currentDate.distance(to: arrivalTime)
        
        setupNotification(distance: distance, id: driftingBottle.id)
    }
    
    // 設定推播
    
    func setupNotification(distance: TimeInterval, id: String) {
        
        let content = UNMutableNotificationContent()
        
        content.body = "有漂流瓶抵達了，趕緊去看看吧！"

        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: distance, repeats: false)

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            print("成功建立通知...")
        })
    }
}
