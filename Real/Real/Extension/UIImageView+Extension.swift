//
//  UIImageView+Extension.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/2.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func loadImage(urlString: String, placeHolder: UIImage? = nil) {
        
        let url = URL(string: urlString)
        
        self.kf.indicatorType = .activity
        
        self.kf.setImage(with: url, placeholder: placeHolder)
    }
}
