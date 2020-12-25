//
//  TagListView.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/23.
//

import UIKit

protocol TagListViewDataSource: AnyObject {
    
    func numberOfTag(view: TagListView) -> Int
    
    func dataForTag(view: TagListView, index: Int) -> Tag
}

protocol TagListViewDelegate: AnyObject {
    
    func buttonDidTap(view: TagListView, tag: Tag)
}

class TagListView: UIView {
    
    var tags: [Tag] = []
    
    weak var dataSource: TagListViewDataSource? {
        
        didSet {
            
            setup()
        }
    }
    
    weak var delegate: TagListViewDelegate?

    func delete() {
        
        for subView in self.subviews {
            
            subView.removeFromSuperview()
        }
    }
    
    func setup() {
        
        guard let dataSource = dataSource else { return }
        
        delete()
        
        let count = dataSource.numberOfTag(view: self)
        
        var xPoint: CGFloat = 4
        
        var yPoing: CGFloat = 10.0
        
        for num in 0..<count {
            
            let button = UIButton()
            
            let data = dataSource.dataForTag(view: self, index: num)
            
            button.contentEdgeInsets = .init(top: 4, left: 3, bottom: 4, right: 3)
            
            button.setTitle(data.title, for: .normal)
            
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            
            button.backgroundColor = .hexStringToUIColor(hex: data.color)
            
//            button.tintColor = .hexStringToUIColor(hex: data.color)
            
            let size = getSizeFromString(string: data.title, withFont: (button.titleLabel?.font)!)
            
            button.frame.size.width = size.width + 16 + 8
            
            button.frame.size.height = size.height + 6
            
            button.tag = num
            
            button.addTarget(self, action: #selector(buttonDidTap(sender:)), for: .touchUpInside)
            
            if (xPoint + size.width + 16 + 8 + 6) >= self.frame.width {
                
//                print("換行啦")
                
                xPoint = 4
                
                yPoing += (size.height + 16)
                
//                print(self.frame.height)
            }
            
            button.frame.origin.x = xPoint
            
            button.frame.origin.y = yPoing
        
            button.setup(cornerRadius: 10)
            
            xPoint += (size.width + 16 + 8 + 6)
            
//            print("x, y", xPoint, yPoing)
            
            self.addSubview(button)
        }
        
        self.frame.size.height = CGFloat(yPoing + 22 + 16)
        
//        print(self.frame.size.height)
    }
    
    func getSizeFromString(string: String, withFont font: UIFont) -> CGSize {

        return NSString(string: string).size(withAttributes: [NSAttributedString.Key.font: font])
    }
    
    @objc func buttonDidTap(sender: UIButton) {
        
        guard let delegate = delegate, let dataSource = dataSource else { return }
        
        let tag = dataSource.dataForTag(view: self, index: sender.tag)
        
        delegate.buttonDidTap(view: self, tag: tag)
    }
}
