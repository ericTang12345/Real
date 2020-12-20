//
//  PostImageTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/14.
//

import UIKit

class PostImageTableViewCell: UITableViewCell {

    @IBOutlet weak var imageCollectionView: UICollectionView! {
        
        didSet {
            
            imageCollectionView.delegate = self
            
            imageCollectionView.dataSource = self
        }
    }
    
    var images: [UIImage] = [] {
        
        didSet {
            
            imageCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
 
extension PostImageTableViewCell: UICollectionViewDelegate {
    
}

extension PostImageTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageCell", for: indexPath) as? PostImageCollectionViewCell else {
            
            return UICollectionViewCell()
        }
        
        cell.setupBorder(width: 0.8, color: .lightGray)
        
        cell.imageView.image = images[indexPath.row]
        
        return cell
    }
}

extension PostImageTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 120, height: 120)
    }
}
