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
    
    static var micronView: UIView {
        
        let view = UIView()
        
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        return view
    }
    
    func setup(cornerRadius: CGFloat) {
        
        self.layer.cornerRadius = cornerRadius
        
        self.layer.masksToBounds = true
    }
    
    func setupBorder(width: CGFloat, color: UIColor) {
        
        self.layer.borderWidth = width
        
        self.layer.borderColor = color.cgColor
    }
    
    func setupShadow() {
        
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        self.layer.shadowOpacity = 0.5

        self.layer.shadowRadius = 2
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
    }
    
    enum MoveType {
        
        case horizontally
            
        case vertical
    }
    
    func animation(moveType: MoveType, to position: CGFloat ) {
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            
            switch moveType {
            
            case .horizontally:
                
                self.frame.origin.x = position
                
            case .vertical:
                
                self.frame.origin.y = position
            
            }
        } completion: { (_) in }
    }
    
    func shake() {
      
        let animation = CABasicAnimation(keyPath: "position")
        
        animation.duration = 0.07
        
        animation.repeatCount = 3
        
        animation.autoreverses = true
        
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")
    }
}
