//
//  UIView+Extension.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/27.
//

import UIKit

extension UIView {
    
    func setupCornerRadius(cornerRadius: CGFloat) {
        
        self.layer.cornerRadius = cornerRadius
        
        self.layer.masksToBounds = true
    }
    
}
