//
//  PostProvider.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/28.
//

import Foundation

protocol ProviderDelegate: AnyObject {
    
}

class PostProvider {
    
    enum PostType: String {
        
        case post = "心情貼文"
        
        case topic = "議題討論"
    }
    
    weak var delegate: ProviderDelegate?
    
    let firebase = FirebaseManagerNew.shared
    
    func getOneTypePost(_ type: PostType, handler: @escaping (Result<[Post]>) -> Void) {

        let query = firebase.getCollection(name: .post).whereField("type", isEqualTo: type.rawValue)
        
        firebase.filter(query: query, dataType: Post.self) { (result) in

            switch result {

            case .success(let posts):

                let posts = posts.sorted { (first, second) -> Bool in
                    
                    first.createdTime.dateValue() > second.createdTime.dateValue()
                }
                
                handler(.success(posts))

            case .failure(let error):

                handler(.failure(error))
            }
        }
    }
}
