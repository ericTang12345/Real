//
//  ChatRoom.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/20.
//

import Foundation

struct ChatRoom: Codable {
    
    let id: String
    
    let provider: String
    
    let receiver: String
    
    let providerName: String
    
    let receiverName: String
    
    let providerImage: String
    
    let receiverImage: String
    
    let createdTime: FIRTimestamp
    
    let lastMessage: String
    
    let lastMessageTime: FIRTimestamp
}

extension ChatRoom {
    
    init(id: String, receiver: DriftingBottle) {
        
        self.id = id
    
        self.provider = UserManager.shared.userData!.id
        
        self.receiver = receiver.provider
        
        self.providerName = UserManager.shared.userData!.randomName
        
        self.receiverName = receiver.providerName
        
        self.providerImage = UserManager.shared.userData!.randomImage
        
        self.receiverImage = receiver.providerImage
        
        self.createdTime = FIRTimestamp()
        
        self.lastMessage = .empty
        
        self.lastMessageTime = FIRTimestamp()
    }
    
}
