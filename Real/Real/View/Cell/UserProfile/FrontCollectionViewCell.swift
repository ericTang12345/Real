//
//  FrontCollectionViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/7.
//

import UIKit
import FSPagerView

class FrontCollectionViewCell: FSPagerViewCell {

    @IBOutlet weak var authorImageView: UIImageView!
    
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var createdTimeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupBorder(width: 0.8, color: .lightGray)
        
        self.backgroundColor = .white

    }

}
