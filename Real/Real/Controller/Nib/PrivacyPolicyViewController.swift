//
//  PrivacyPolicyViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/29.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var enContent = ""
    
    var zhContent = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPrivacyPolicys()
    }
    
    func getPrivacyPolicys() {
        
        guard let zhPrivacyPolicy = Bundle.main.infoDictionary?["Privacy Policy zh-tw"] as? String,
              let enPrivacyPolicy = Bundle.main.infoDictionary?["Privacy Policy en-us"] as? String
        else {
            return
        }
        
        zhContent = zhPrivacyPolicy
        
        enContent = enPrivacyPolicy
        
        textView.text = zhContent
    }

    @IBAction func switchLanguage(_ sender: UISegmentedControl) {
        
        textView.text = sender.selectedSegmentIndex == 0 ? zhContent : enContent
    }
}
