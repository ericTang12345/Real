//
//  ImageDetailsViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/22.
//

import UIKit

class ImageDetailsViewController: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    
    var image: UIImage? {
        
        didSet {
            
            mainImageView.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
}
