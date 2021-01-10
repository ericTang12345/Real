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
    
    @IBOutlet weak var isReceiveSwitch: UISwitch! {
        
        didSet {
            
            if !userManager.isSignin {
                
                isReceiveSwitch.isOn = false
                
            } else {
                
                isReceiveSwitch.isOn = true
            }
        }
    }
    
    let firebase = FirebaseManager.shared
    
    let userManager = UserManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebase.listen(collectionName: .user) {
            
            self.reloadView()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: .userDataUpdated, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func reloadView() {
        
        guard let user = userManager.userData else {
            
            userNameLabel.text = "訪客"
            
            return
        }
        
        userNameLabel.text = user.randomName
        
        userImageView.loadImage(urlString: user.randomImage)
        
        isReceiveSwitch.isOn = user.isReceiveDriftingBottle
        
        tableView.reloadData()
    }
    
    @IBAction func signInWithApple(_ sender: CustomizeButton) {
        
    }
    
    @IBAction func switchReceiveStatus(_ sender: UISwitch) {
        
        if !userManager.isSignin {
            
            present(.signinAlert(handler: {
                
                let viewController = SigninWithAppleViewController.loadFromNib()
                
                viewController.modalPresentationStyle = .fullScreen
                
                viewController.delegate = self
                
                viewController.loadViewIfNeeded()
                
                self.present(viewController, animated: true, completion: nil)
                
            }), animated: true, completion: nil)
            
            sender.isOn = false
            
            return
        }
        
        guard let user = userManager.userData else { return }
        
        firebase.update(
            collectionName: .user,
            documentId: user.id,
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

extension UserProfileTableViewController: SigninSuccessDelegate {
    
    func siginSuccess() {
        
        present(.signinSuccessAlert(), animated: true, completion: nil)
    }
}
