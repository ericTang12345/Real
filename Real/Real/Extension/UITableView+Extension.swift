//
//  UITableView+Extension.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/26.
//

import UIKit

extension UITableView {
    
    func registerCellWithNib(nibName: String, identifier: String) {
        
        let nib = UINib(nibName: nibName, bundle: nil)
        
        register(nib, forCellReuseIdentifier: identifier)
    }
    
    func reuseCell(_ identifier: CellId, _ indexPath: IndexPath) -> UITableViewCell {
        
        return self.dequeueReusableCell(withIdentifier: identifier.rawValue, for: indexPath)
    }
    
}
