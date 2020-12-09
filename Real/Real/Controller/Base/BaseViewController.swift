//
//  BaseViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/30.
//

import UIKit

struct AlertConfig {
    
    let title: String
    
    let message: String
    
    let placeholder: String
}

class BaseViewController: UIViewController {
    
    var segues: [String] {
        
        return []
    }
    
    var isHideTabBar: Bool {
        
        return false
    }
    
    var isHideNavigationBar: Bool {
        
        return false
    }
    
    var isHideBackButton: Bool {
        
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    func hideKeyboardWhenTappedAround() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)

    }

    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }
}

extension UIViewController {
    
    static func alertTextField(config: AlertConfig, handler: @escaping (String) -> Void) -> UIAlertController {
        
        let controller = UIAlertController(title: config.title, message: config.message, preferredStyle: .alert)
        
        let done = UIAlertAction(title: "確定", style: .default) { _ in
            
            guard let text = controller.textFields?[0].text else {
                
                return
            }
            
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
