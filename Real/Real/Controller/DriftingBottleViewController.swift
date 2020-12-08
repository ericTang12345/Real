//
//  DriftingBottleViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/7.
//

import UIKit

class DriftingBottleViewController: BaseViewController {

    @IBOutlet weak var textView: UITextView! {
        
        didSet {
            
            textView.delegate = self
            
            textView.text = textViewPlaceholder
            
            textView.textColor = .lightGray
        }
    }
    
    @IBOutlet weak var letterView: UIView! {
        
        didSet {
            
            letterView.setupShadow()
        }
    }
     
    let textViewPlaceholder = "今天過得還好嗎？不管是開心、不滿，透過寫信傳達出去吧，不管有沒有人會收到。"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
}

extension DriftingBottleViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.textColor == UIColor.lightGray {

            textView.text = nil

            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {

        if textView.text.isEmpty {

            textView.text = textViewPlaceholder

            textView.textColor = .lightGray
        }
    }
}
