//
//  BaseViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/30.
//

import UIKit

class BaseViewController: UIViewController {
    
    var segues: [String] { return [] }
    
    var isHideTabBar: Bool { return false }
    
    var isHideNavigationBar: Bool { return false }
    
    var isHideBackButton: Bool { return false }
    
    var isEnableHideKeyboardWhenTappedAround: Bool { return false }
    
    var isEnableKeyboardNotification: Bool { return false }
    
    let firebase = FirebaseManager.shared
    
    let userManager = UserManager.shared
    
    let storage = FirebaseStorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEnableKeyboardNotification {

            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        UIApplication.shared.sendAction(
            #selector(UIApplication.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
        
        self.tabBarController?.tabBar.isHidden = isHideTabBar
        
        self.navigationController?.isNavigationBarHidden = isHideNavigationBar
        
        self.navigationItem.hidesBackButton = isHideBackButton
        
        if isEnableHideKeyboardWhenTappedAround {
            
           hideKeyboardWhenTappedAround()
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {

            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            if self.view.frame.size.height == (UIScreen.fullSize.height - keyboardHeight) {
                
            } else {
                
                self.view.frame.size.height -= keyboardHeight
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        
        self.view.endEditing(true)
        
        self.view.frame.size.height = UIScreen.fullSize.height
    }
}

// MARK: - AlertController

struct AlertConfig {
    
    let title: String
    
    let message: String
    
    let placeholder: String
}

extension UIViewController {
    
    // Message alert

    static func alertMessage(title: String, message: String) -> UIAlertController {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let done = UIAlertAction(title: "確定", style: .default, handler: nil)
        
        controller.addAction(done)
        
        return controller
    }
    
    // Single textField alert
    
    static func alertTextField(config: AlertConfig, handler: @escaping (String) -> Void) -> UIAlertController {
        
        let controller = UIAlertController(title: config.title, message: config.message, preferredStyle: .alert)
        
        let done = UIAlertAction(title: "確定", style: .default) { _ in
            
            guard let text = controller.textFields?[0].text else { return }
            
            handler(text)
        }
        
        controller.addAction(done)
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        controller.addAction(cancel)
        
        controller.addTextField { (textField) in
            
            textField.placeholder = config.placeholder
        }
        
        return controller
    }
}
