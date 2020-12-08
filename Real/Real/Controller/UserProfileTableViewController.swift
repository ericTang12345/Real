//
//  UserProfileTableViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/8.
//

import UIKit

class UserProfileTableViewController: UITableViewController {

    let authManager = FirebaseAuthManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func signInWithApple(_ sender: CustomizeButton) {
        
        authManager.performSignin(self)
    }
}
