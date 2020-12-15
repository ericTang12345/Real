//
//  UICollectionView+Extension.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/15.
//

import UIKit

extension UICollectionViewCell: ReuseableView {}

extension UICollectionView {
    
    func registerCellWithNib(cell: UICollectionViewCell.Type) {
        
        let nib = UINib(nibName: cell.nibName, bundle: nil)
        
        register(nib, forCellWithReuseIdentifier: cell.defaultReuseIdentifier)
    }
    
    func reuse<T: UICollectionViewCell>(_ cell: T.Type, indexPath: IndexPath) -> T {
        
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            
            fatalError()
        }
        
        return cell
    }
    
    func reuse(id: String, indexPath: IndexPath) -> UICollectionViewCell {
        
        return self.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
    }
}
