//
//  Post.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/1.
//

import UIKit
import Firebase

struct Post: Codable {
    
    let id: String
    
    let title: String
    
    let image: String
    
    let content: String
    
    let likeCount: [String] // User.id
    
    let createdTime: Timestamp
    
    let authorId: String // User.id
    
    let authorCurrentName: String
    
    let authorCurrentImage: String
    
    let tags: [String]
    
}
