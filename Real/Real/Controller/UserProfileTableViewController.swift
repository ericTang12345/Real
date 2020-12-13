//
//  UserProfileTableViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/8.
//

import UIKit

class UserProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var isReceiveSwitch: UISwitch!
    
    let firebase = FirebaseManager.shared
    
    let userManager = UserManager.shared
    
    let authManager = FirebaseAuthManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: .userDataUpdated, object: nil)
    }
    
    @objc func reloadView() {
        
        userNameLabel.text = userManager.userData?.randomName
        
        userImageView.loadImage(urlString: userManager.userData?.randomImage ?? .empty)
        
        isReceiveSwitch.isOn = userManager.userData?.isReceiveDriftingBottle ?? true
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func signInWithApple(_ sender: CustomizeButton) {
        
        authManager.performSignin(self)
    }
    
    @IBAction func switchReceiveStatus(_ sender: UISwitch) {
        
        firebase.update(
            collectionName: .user,
            documentId: userManager.userID,
            key: "isReceiveDriftingBottle",
            value: sender.isOn
        )
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            userManager.switchNameAndImage()
        }
    }
}
