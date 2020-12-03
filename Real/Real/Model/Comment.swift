//
//  Comment.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/4.
//

import Firebase

struct Comment: Codable {
    
    let id: String
    
    let content: String
    
    var likeCount: [String]
    
    let createdTime: Timestamp
    
    let author: String // User.id
    
    let postId: String // Post.id
    
    let authorName: String
    
    let authorImage: String
}
