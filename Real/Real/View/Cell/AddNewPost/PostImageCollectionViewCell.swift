//
//  PostImageCollectionViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/14.
//

import UIKit

class PostImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView! 
    
    @IBOutlet weak var deleteImageButton: UIButton!
    
    func setup(index: Int, image: UIImage) {
        
        imageView.image = image
        
        deleteImageButton.tag = index
        
        deleteImageButton.setup(cornerRadius: deleteImageButton.height/2)
    }
}
