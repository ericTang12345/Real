//
//  Post.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/1.
//

import UIKit

struct Post {
    
    let id: String
    
    let title: String
    
    let image: String
    
    let content: String
    
    let likeCount: [String] // User.id
    
    let createTime: String
    
    let author: String // User.id
    
    let authorCurrentName: String
    
    let authorCurrentImage: String
    
}
