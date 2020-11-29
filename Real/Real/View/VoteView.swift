//
//  VoteView.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/26.
//

import UIKit

protocol VoteViewDataSource: AnyObject {
    
    func numberofButton() -> Int
    
    func titleforButton(index: Int) -> String
}

class VoteView: UIView {
  
}
