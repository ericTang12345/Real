//
//  UITableView+Extension.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/26.
//

import UIKit
import Foundation

extension UITableView {
    
    func registerCellWithNib(cell: UITableViewCell.Type) {
        
        let nib = UINib(nibName: cell.nibName, bundle: nil)
        
        register(nib, forCellReuseIdentifier: cell.defaultReuseIdentifier)
    }
    
    func reuse<T: UITableViewCell>(_ cell: T.Type, indexPath: IndexPath) -> T {
        
        guard let cell = self.dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            
            fatalError()
        }
        
        return cell
    }
    
    func reuse(id: String, indexPath: IndexPath) -> UITableViewCell {
        
        return self.dequeueReusableCell(withIdentifier: id, for: indexPath)
    }
    
    func reuseCell(_ identifier: CellId, _ indexPath: IndexPath) -> UITableViewCell {
        
        return self.dequeueReusableCell(withIdentifier: identifier.rawValue, for: indexPath)
    }
    
}
