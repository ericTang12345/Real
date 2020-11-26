//
//  UITableView+Extension.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/26.
//

import UIKit

extension UITableView {
    
    func registerCellWithNib(nibName: String, idienifiter: String) {
        
        let nib = UINib(nibName: nibName, bundle: nil)
        
        register(nib, forCellReuseIdentifier: idienifiter)
    }
}
