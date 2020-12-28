//
//  UIVIewController+Extension.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/28.
//

import UIKit

// MARK: - AlertController

struct AlertConfig {
    
    let title: String
    
    let message: String
    
    let placeholder: String
}

extension UIViewController {
    
    static func signinSuccessAlert() -> UIAlertController {
        
        let controller = UIAlertController(title: "登入成功", message: "每次登入成功，便會更換一次隨機名稱", preferredStyle: .alert)
        
        controller.view.tintColor = .darkGray
        
        let done = UIAlertAction(title: "確定", style: .default, handler: nil)
        
        controller.addAction(done)
        
        return controller
    }
    
    // Message alert

    static func alertMessage(title: String, message: String) -> UIAlertController {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        controller.view.tintColor = .darkGray
        
        let done = UIAlertAction(title: "確定", style: .default, handler: nil)
        
        controller.addAction(done)
        
        return controller
    }
    
    // Single textField alert
    
    static func alertTextField(config: AlertConfig, handler: @escaping (String) -> Void) -> UIAlertController {
        
        let controller = UIAlertController(title: config.title, message: config.message, preferredStyle: .alert)
        
        controller.view.tintColor = .darkGray
        
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
    
    static func signinAlert(handler: @escaping () -> Void) -> UIAlertController {
        
        let alert = UIAlertController(title: "尚未登入", message: "完成登入，可以立即啟用喜愛、回應、發文等功能哦！", preferredStyle: .actionSheet)
        
        alert.view.tintColor = .darkGray
        
        let done = UIAlertAction(title: "立即登入", style: .default) { (_) in

            handler()
        }
        
        alert.addAction(done)
        
        let cancel = UIAlertAction(title: "稍後再說", style: .default)
        
        alert.addAction(cancel)
        
        return alert
    }
}

extension UIViewController {
    
    class func loadFromNib() -> Self {
        return self.init(nibName: String(describing: self), bundle: nil)
    }
}
