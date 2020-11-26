//
//  UITableViewCell+Extension.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/26.
//

import UIKit

extension UITableViewCell {
    
    static let emptyCell = UITableViewCell()
    
    static var nibName: String {
        
        return String(describing: self)
    }
}
