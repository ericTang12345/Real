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
    
    let isPost: Bool
    
    var catcher: String? // User.id
    
    var arrivalTime: FIRTimestamp?
}

extension DriftingBottle {

    init(id: String, content: String, isPost: Bool, catcher: String?) {
        
        self.id = id
        
        self.content = content
        
        self.provider = UserManager.shared.userID
        
        self.isPost = isPost
        
        self.catcher = catcher
        
        // Setup drifting bottle arrival time

        self.arrivalTime = isPost == true ? .randomTime(from: 1, day: 2) : nil
    }
}
