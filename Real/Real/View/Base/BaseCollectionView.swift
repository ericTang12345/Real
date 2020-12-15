//
//  BaseCollectionView.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/15.
//

import UIKit

class BaseCollectionView: UICollectionView {

    func registerNib() {
        
        registerCellWithNib(cell: PostImageCollectionViewCellNib.self)
        
    }
}
