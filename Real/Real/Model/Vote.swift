//
//  Vote.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/21.
//

import Foundation

struct Vote: Codable {
    
    let id: Int
    
    let docId: String
    
    let title: String
    
    let voter: [String]
}

extension Vote {
    
    init(id: Int, docId: String, title: String) {
        
        self.id = id
        
        self.docId = docId
        
        self.title = title
        
        self.voter = []
    }
}
