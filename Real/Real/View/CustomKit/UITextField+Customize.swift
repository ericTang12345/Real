//
//  UITextField+Customize.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/29.
//

import UIKit

@IBDesignable
class CustomizeTextField: UITextField {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        
        didSet {
            
            self.layer.cornerRadius = cornerRadius
            
            self.layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        
        didSet {
            
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        
        didSet {
            
            self.layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var leftPadding: CGFloat = 0.0 {
        
        didSet {
            
            padding.left = leftPadding
        }
    }
    
    @IBInspectable var bottomPadding: CGFloat = 0.0 {
        
        didSet {
            
            padding.bottom = bottomPadding
        }
    }
    
    @IBInspectable var rightPadding: CGFloat = 0.0 {
        
        didSet {
            
            padding.right = rightPadding
        }
    }
    
    @IBInspectable var topPadding: CGFloat = 0.0 {
        
        didSet {
            
            padding.top = topPadding
        }
    }
    
    var padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.inset(by: padding)
    }
}
