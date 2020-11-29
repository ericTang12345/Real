//
//  UIView+Extension.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/27.
//

import UIKit

extension UIView {
    
    static var nibName: String {
        
        return String(describing: self)
    }
    
    func setup(cornerRadius: CGFloat) {
        
        self.layer.cornerRadius = cornerRadius
        
        self.layer.masksToBounds = true
    }
    
    func setupBorder(width: CGFloat, color: UIColor) {
        
        self.layer.borderWidth = width
        
        self.layer.borderColor = color.cgColor
    }
    
    func loadFormNib(_ nibName: String) {
        
        let nib = UINib(nibName: nibName, bundle: nil)
        
        guard let views = nib.instantiate(withOwner: nil, options: nil) as? [UIView],
              let contentView = views.first
        else {
            
            print("error: Bundle load Nib name error ")
            
            return
        }
    
        self.addSubview(contentView)
    }
}
