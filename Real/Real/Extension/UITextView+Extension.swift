//
//  UITextView+Extension.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/21.
//

import UIKit

extension UITextView {
    
    func textCountLines() -> Int {
        // Call self.layoutIfNeeded() if your view uses auto layout
        let myText = self.text! as NSString
        
        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        
        let labelSize = myText.boundingRect(
            with: rect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: self.font!],
            context: nil
        )
        
        return Int(ceil(CGFloat(labelSize.height) / self.font!.lineHeight))
    }
    
    func setup() {
        
        self.setup(cornerRadius: 15)
        
        self.setupBorder(width: 0.8, color: .lightGray)
        
        let padding = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        
        self.textContainerInset = padding
    }
}
