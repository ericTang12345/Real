//
//  Comment.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/4.
//

import Foundation

struct Comment: Codable {
    
    let id: String
    
    let content: String
    
    var likeCount: [String]
    
    let createdTime: FIRTimestamp
    
    let author: String // User.id
    
    let postId: String // Post.id
    
    let authorName: String
    
    let authorImage: String
}

extension Comment {
    
    init(id: String, content: String, author: String, postId: String) {
        
        self.id = id
        
        self.content = content
        
        self.likeCount = []
        
        self.createdTime = FIRTimestamp()
        
        self.author = UserManager.shared.userData!.id
        
        self.postId = postId
        
        self.authorName = UserManager.shared.userData!.randomName
        
        self.authorImage = UserManager.shared.userData!.randomImage
    }
}
