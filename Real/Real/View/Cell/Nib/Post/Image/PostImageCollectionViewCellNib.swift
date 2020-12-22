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
            
            imageDetailViewController = ImageDetailsViewController(nibName: String(describing: ImageDetailsViewController.self), bundle: nil)
        }
    }
    
    weak var delegate: PostImageDelegate?
    
    var imageDetailViewController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @objc func isSelect() {
        
        guard let delegate = delegate, let viewController = imageDetailViewController else { return }
        
        delegate.imageDidSelect(viewController: viewController)
    }

}
