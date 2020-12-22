//
//  Message.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/15.
//

import Foundation

struct Message: Codable {
    
    let sender: String // user.id
    
    let message: String
    
    let createdTime: FIRTimestamp
    
    let isRead: Bool
}

extension Message {
    
    init(id: String, message: String) {
        
        self.sender = id
        
        self.message = message
        
        self.createdTime = FIRTimestamp()
        
        self.isRead = false
    }
}
