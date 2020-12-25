//
//  PostImageTableViewCellNib.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/15.
//

import UIKit

class PostImageTableViewCellNib: BaseTableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.registerCellWithNib(cell: PostImageCollectionViewCellNib.self)
            
            collectionView.delegate = self

            collectionView.dataSource = self
        }
    }
     
    weak var delegate: PostImageDelegate?
    
    var images: [String] = [] {
        
        didSet {
            
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(data: Post) {
        
        images = data.images
    }
}

extension PostImageTableViewCellNib: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension PostImageTableViewCellNib: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell = collectionView.reuse(PostImageCollectionViewCellNib.self, indexPath: indexPath)
        
        cell.imageView.loadImage(urlString: images[indexPath.row])
        
        cell.delegate = self.delegate
        
        return cell
    }
}
