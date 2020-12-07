//
//  DriftingBottleViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/7.
//

import UIKit

class DriftingBottleViewController: UIViewController {

    @IBOutlet weak var textView: UITextView! {
        
        didSet {
            
            textView.delegate = self
        }
    }
    
    @IBOutlet weak var letterView: UIView! {
        
        didSet {
            
            letterView.setupShadow()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showLetterView()
    }
    
    func showLetterView() {
        
        let time: TimeInterval = 0.4
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            
            guard let tabBarHeight = self.tabBarController?.tabBar.frame.size.height else { return }
            
            self.letterView.animation(
                moveType: .vertical,
                to: UIScreen.main.fullSize.height - self.letterView.frame.size.height - tabBarHeight
            )
        }
    }
}

extension DriftingBottleViewController: UITextViewDelegate {

}
