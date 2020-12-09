//
//  UILabel+Extension.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/1.
//

import UIKit

extension UILabel {
    
    var textCount: Int {
        
        return countLabelLines()
    }
    
    func countLabelLines() -> Int {
        // Call self.layoutIfNeeded() if your view uses auto layout
        let myText = self.text! as NSString
        
        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        
        let labelSize = myText.boundingRect(
            with: rect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: self.font!],
            context: nil
        )
        
        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
}

class LabelPadding: UILabel {
    
    let padding = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
    
    override func drawText(in rect: CGRect) {
        
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        
        let superContentSize = super.intrinsicContentSize
        
        let width = superContentSize.width + padding.left + padding.right
        
        let heigth = superContentSize.height + padding.top + padding.bottom
        
        return CGSize(width: width, height: heigth)
    }

}
