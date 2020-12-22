//
//  Timestamp+Extension.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/2.
//

import Firebase

extension Timestamp {
    
    func compareCurrentTime() -> String {
        
        let timeDate = self.dateValue()
        
        let currentDate = Date()
        
        let timeInterval = currentDate.timeIntervalSince(timeDate)
        
        var temp: Double = 0
        
        var result: String = ""
        
        if timeInterval/60 < 1 {
            
            result = "剛剛"
            
        } else if timeInterval/60 < 60 {
            
            temp = timeInterval/60
            
            result = "\(Int(temp)) 分鐘前"
            
        } else if timeInterval/60/60 < 24 {
            
            temp = timeInterval/60/60
            
            result = "\(Int(temp)) 小時前"
            
        } else if timeInterval/(24 * 60 * 60) < 30 {
            
            temp = timeInterval / (24 * 60 * 60)
            
            result = "\(Int(temp)) 天前"
            
        } else if timeInterval/(30 * 24 * 60 * 60)  < 12 {
            
            temp = timeInterval/(30 * 24 * 60 * 60)
            
            result = "\(Int(temp)) 個月前"
            
        } else {
            
            temp = timeInterval/(12 * 30 * 24 * 60 * 60)
            
            result = "\(Int(temp)) 年前"
            
        }
        
        return result
    }
    
    func timeStampToStringDetail() -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy 年 MM 月 dd 日 HH 點"
        
        return dateFormatter.string(from: self.dateValue())
    }
    
    static func randomTime(from first: Double, day end: Double) -> Timestamp {
        
        let startDay = first * 24.0 * 60.0 * 60.0
        
        print("start day: ", startDay)
        
        let overDay = end * 24.0 * 60.0 * 60.0
        
        print("over day: ", overDay)
        
        let randomTime = Double.random(in: startDay ..< overDay)
        
        let randomTimeStamp = TimeInterval(randomTime)
        
        let currentDate = Timestamp().dateValue()
        
        let newDate = currentDate.addingTimeInterval(randomTimeStamp)
        
        return Timestamp(date: newDate)
    }
}
