//
//  User.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/1.
//

import Foundation

struct User: Codable {
    
    let id: String
    
    let randomName: String
    
    let randomImage: String
    
    let collections: [String] // Post.id
    
    let blockadeListUser: [String] // User.id
    
    let blockadeListPost: [String] // Post.id
    
    let registerTime: String
}
