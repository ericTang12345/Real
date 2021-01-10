//
//  TagManager.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/24.
//

import Foundation

class TagManager {
    
    let firebase = FirebaseManager.shared
    
    func readTagDatat(handler: @escaping ([Tag]) -> Void) {
        
        firebase.read(collectionName: .tag, dataType: Tag.self) { (result) in
            
            switch result {
            
            case .success(let data):
                
                handler(data)
                
            case .failure(let error):
            
                print("read tag data error:", error)
            }
        }
    }
    
    func stringToTag(strList: [String], handler: @escaping ([Tag]) -> Void ) {
        
        var tags: [Tag] = []
        
        readTagDatat { (data) in
            
            for str in strList {
                
                for tag in data where tag.id == str {
                
                    tags.append(tag)
                    
                    if tags.count == strList.count {
                        
                        handler(tags)
                    }
                }
            }
        }
        
    }
}
