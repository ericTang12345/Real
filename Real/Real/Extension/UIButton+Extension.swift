//
//  UIButton+Extension.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/28.
//

import UIKit

extension UIControl {
    
    func animate() {
        
        UIView.animate(withDuration: 0.1, animations: {
            
            self.transform = self.transform.scaledBy(x: 0.8, y: 0.8)
        
        }, completion: { _ in

            UIView.animate(withDuration: 0.1, animations: {
                
                self.transform = CGAffineTransform.identity
            })
        })
    }
}
