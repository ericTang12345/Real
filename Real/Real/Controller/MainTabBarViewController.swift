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
        
        button.frame.size = CGSize(width: 60, height: 60)
        
        button.center = CGPoint(
            x: tabBar.center.x,
            y: tabBar.bounds.height/2.5
        )
        
        button.backgroundColor = #colorLiteral(red: 0.9694142938, green: 0.9645970464, blue: 0.9645139575, alpha: 1)
        
        button.layer.masksToBounds = true
        
        button.layer.cornerRadius = 10
        
        tabBar.addSubview(button)
        
    }
}
