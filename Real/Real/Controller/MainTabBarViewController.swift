//
//  MainTabBarViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/26.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    func setup() {
        
        button.setImage(#imageLiteral(resourceName: "Add"), for: .normal)
        
        button.frame.size = CGSize(width: 40, height: 40)
        
        button.center = CGPoint(
            x: tabBar.center.x,
            y: tabBar.bounds.height/1.5
        )
        
        button.backgroundColor = .clear
        
        button.layer.masksToBounds = true
        
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(presentAddNewPostPage), for: .touchUpInside)
        
        tabBar.addSubview(button)
    }
    
    @objc func presentAddNewPostPage() {
        
        performSegue(withIdentifier: "SegueAddNewPost", sender: nil)
    }
}
