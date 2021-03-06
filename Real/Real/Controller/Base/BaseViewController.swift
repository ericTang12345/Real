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
    
    var enableHideKeyboardWhenTappedAround: Bool { return false }
    
    var enableKeyboardNotification: Bool { return false }
    
    let firebase = FirebaseManager.shared
    
    let userManager = UserManager.shared
    
    let storage = FirebaseStorageManager.shared
    
    let backgroundView = UIView() // 彈出畫面，背景陰影
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundView()
    
        self.view.setupShadow()
        
        if enableKeyboardNotification {

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
        
        if enableHideKeyboardWhenTappedAround {
            
           hideKeyboardWhenTappedAround()
        }
    }
    
    // MARK: - Background View
    
    func setupBackgroundView() {
        
        backgroundView.frame.origin = CGPoint(x: 0, y: UIScreen.fullSize.height)
        
        backgroundView.frame.size = UIScreen.fullSize
        
        backgroundView.backgroundColor = .init(white: 0, alpha: 0.5)
        
        backgroundView.isHidden = true
        
        self.view.insertSubview(backgroundView, at: 2)
    }
    
    func showBackgroundView(duration: TimeInterval) {
        
        self.backgroundView.isHidden = false
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0, options: .curveEaseIn) {
            
            self.backgroundView.frame.origin.y = 0
            
        } completion: { (_) in }
    }
    
    func dismissBackgroundView(duration: TimeInterval) {
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0, options: .curveEaseIn) {
            
            self.backgroundView.frame.origin.y = UIScreen.fullSize.height
            
        } completion: { (_) in
            
            self.backgroundView.isHidden = true
        }
    }
    
    // MARK: - Keyboard
    
    func hideKeyboardWhenTappedAround() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        
        // 先變回原本尺寸
        self.view.frame.size.height = UIScreen.fullSize.height
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {

            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            // 調整 view 去對應 keyboard size
            self.view.frame.size.height -= keyboardHeight
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        
        self.view.endEditing(true)
        
        self.view.frame.size.height = UIScreen.fullSize.height
    }
}

// MARK: - Sign In Success Delegate

extension BaseViewController: SigninSuccessDelegate {
    
    func siginSuccess() {
        
        present(.signinSuccessAlert(), animated: true, completion: nil)
    }
}
