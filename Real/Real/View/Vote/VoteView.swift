//
//  VoteView.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/26.
//

import UIKit

protocol VoteViewDataSource: AnyObject {
    
    func numberOfVoteItem(view: VoteView) -> Int
    
    func titleForVoteItem(view: VoteView, index: Int) -> String
}

class VoteView: UIView {
    
    weak var dataSource: VoteViewDataSource? {
        
        didSet {
            
            setup()
        }
    }
    
    private let spacing = 10
    
    private let height = 35
    
    func setup() {
        
        self.backgroundColor = .white
        
        guard let count = dataSource?.numberOfVoteItem(view: self) else {
            
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: CGFloat(count * height + (count + 1) * spacing))
        ])
        
        updateConstraints()
        
        createVoteItem()
    }
    
    func createVoteItem() {
        
        guard let count = dataSource?.numberOfVoteItem(view: self) else {
            
            return
        }
        
        for index in 0..<count {
            
            let button = UIButton()
            
            button.frame.size.width = self.frame.size.width
            
            button.frame.size.height = CGFloat(height)
            
            button.frame.origin.x = self.frame.origin.x
            
            button.frame.origin.y = CGFloat(spacing * (index+1) + height * index)
            
            button.tag = index
            
            button.setTitleColor(.black, for: .normal)
            
            guard let title = dataSource?.titleForVoteItem(view: self, index: index) else {
                
                return
            }
            
            button.setTitle(title, for: .normal)
            
            button.setupBorder(width: 0.5, color: .lightGray)
            
            self.addSubview(button)
        }
    }
}
