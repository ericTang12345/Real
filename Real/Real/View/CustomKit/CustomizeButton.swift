//
//  CustomizeButton.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/6.
//

import UIKit

@IBDesignable
class CustomizeButton: UIButton {
    
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
    
    @IBInspectable var titleLeftPadding: CGFloat = 0.0 {
        
        didSet {
            
            titleEdgeInsets.left = titleLeftPadding
        }
    }
    
    @IBInspectable var titleRightPadding: CGFloat = 0.0 {
        
        didSet {
            
            titleEdgeInsets.left = titleRightPadding
        }
    }
    
    @IBInspectable var titleTopPadding: CGFloat = 0.0 {
        
        didSet {
            
            titleEdgeInsets.left = titleTopPadding
        }
    }
    
    @IBInspectable var titleBottomPadding: CGFloat = 0.0 {
        
        didSet {
            
            titleEdgeInsets.left = titleBottomPadding
        }
    }
        
    @IBInspectable var imageLeftPadding: CGFloat = 0.0 {
        
        didSet {
            
            imageEdgeInsets.left = imageLeftPadding
        }
    }
    @IBInspectable var imageRightPadding: CGFloat = 0.0 {
        
        didSet {
            
            imageEdgeInsets.right = imageRightPadding
        }
    }
    @IBInspectable var imageTopPadding: CGFloat = 0.0 {
        
        didSet {
            
            imageEdgeInsets.top = imageTopPadding
        }
    }
    
    @IBInspectable var imageBottomPadding: CGFloat = 0.0 {
        
        didSet {
            
            imageEdgeInsets.bottom = imageBottomPadding
        }
    }
}
