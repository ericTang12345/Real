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
    
    let image: String
    
    let content: String
    
    var likeCount: [String] // [User.id]
    
    let createdTime: FIRTimestamp
    
    let authorId: String // User.id
    
    let authorName: String
    
    let authorImage: String
    
    let tags: [String]
    
    let vote: [String]
}
