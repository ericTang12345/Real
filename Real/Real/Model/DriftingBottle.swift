//
//  DriftingBottle.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/11.
//

import Foundation

struct DriftingBottle: Codable {
    
    let id: String
    
    let content: String
    
    let provider: String // User.id
    
    let providerName: String // User.name
    
    let providerImage: String // User.image
    
    let isPost: Bool
    
    var catcher: String? // User.id
    
    var arrivalTime: FIRTimestamp?
    
    var createdTime: FIRTimestamp
    
    var isCatch: Bool?
}

extension DriftingBottle {

    init(id: String, content: String, isPost: Bool, catcher: String?) {
        
        self.id = id
        
        self.content = content
        
        self.provider = UserManager.shared.userData!.id
        
        self.providerName = UserManager.shared.userData!.randomName
        
        self.providerImage = UserManager.shared.userData!.randomImage
        
        self.isPost = isPost
        
        self.catcher = catcher
        
        // Setup drifting bottle arrival time

        let second = FIRTimestamp(date: FIRTimestamp().dateValue().addingTimeInterval(30))
        
        self.arrivalTime = isPost == true ? second : nil
        
//        .randomTime(from: 0, day: 0.1)
        
        self.createdTime = FIRTimestamp()
        
        self.isCatch = isPost == true ? false : nil
    }
}
