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
    
    var images: [String]
    
    let content: String
    
    var likeCount: [String] // [User.id]
    
    let createdTime: FIRTimestamp
    
    let authorId: String // User.id
    
    let authorName: String
    
    let authorImage: String
    
    let tags: [String]
    
    let votes: [String]
    
    let collection: [String] // User.id
}

extension Post {
    
    init(id: String, type: String, images: [String] = [], content: String, tags: [Tag] = [], votes: [String] = []) {
        
        self.id = id
        
        self.type = type
        
        self.images = images
        
        self.content = content
        
        self.likeCount = []
        
        self.createdTime = FIRTimestamp()
        
        self.authorId = UserManager.shared.userData!.id
        
        self.authorName = UserManager.shared.userData!.randomName
        
        self.authorImage = UserManager.shared.userData!.randomImage
        
        self.tags = tags.map { return $0.id }
        
        self.votes = votes
        
        self.collection = []
    }
}
