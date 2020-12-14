//
//  Post.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/1.
//

import Foundation

struct Post: Codable {
    
    let id: String
    
    let type: String
    
    let images: [String]
    
    let content: String
    
    var likeCount: [String] // [User.id]
    
    let createdTime: FIRTimestamp
    
    let authorId: String // User.id
    
    let authorName: String
    
    let authorImage: String
    
    let tags: [String]
    
    let vote: [String]
    
    let collection: [String] // User.id
}

extension Post {
    
    init(id: String, type: String, images: [String], content: String, tags: [String], vote: [String]) {
        
        self.id = id
        
        self.type = type
        
        self.images = images
        
        self.content = content
        
        self.likeCount = []
        
        self.createdTime = FIRTimestamp()
        
        self.authorId = UserManager.shared.userData!.id
        
        self.authorName = UserManager.shared.userData!.randomName
        
        self.authorImage = UserManager.shared.userData!.randomImage
        
        self.tags = tags
        
        self.vote = vote
        
        self.collection = []
    }
}
