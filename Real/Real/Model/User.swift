//
//  User.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/1.
//

import Foundation

struct User: Codable {
    
    var id: String
    
    let randomName: String
    
    let randomImage: String
    
//    let collections: [String] // Post.id
    
//    let blockadeListUser: [String] // User.id
    
    let blockadeListComment: [String] // Comment.id
    
    let blockadeListPost: [String] // Post.id
    
    let registerTime: FIRTimestamp
    
    var isReceiveDriftingBottle: Bool
}

extension User {
    
    init(id: String) {
        
        self.id = id
        
        self.randomName = .empty
        
        self.randomImage = .empty
        
        self.blockadeListComment = []
        
        self.blockadeListPost = []
        
        self.registerTime = FIRTimestamp()
        
        self.isReceiveDriftingBottle = true
    }
}
