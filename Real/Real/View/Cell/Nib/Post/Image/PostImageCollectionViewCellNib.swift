//
//  PostImageCollectionViewCellNib.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/15.
//

import UIKit

protocol PostImageDelegate: AnyObject {
    
    func imageDidSelect(viewController: UIViewController)
}

class PostImageCollectionViewCellNib: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView! {
        
        didSet {
            
            imageView.enableTapAction(sender: self, selector: #selector(isSelect))
        }
    }
    
    weak var delegate: PostImageDelegate?
    
    var imageDetailViewController: ImageDetailsViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @objc func isSelect() {
        
        let viewController = ImageDetailsViewController(nibName: String(describing: ImageDetailsViewController.self), bundle: nil)
        
        viewController.loadViewIfNeeded()
        
        viewController.mainImageView.image = imageView.image
        
        guard let delegate = delegate else { return }
        
        delegate.imageDidSelect(viewController: viewController)
    }
}
