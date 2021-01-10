//
//  PrivacyPolicyViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/29.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {
    
    enum ContentType {
        
        case privacy
            
        case ucla
        
    }
    
    @IBOutlet weak var textView: UITextView!
    
    var enPrivacyPolicy = ""
    
    var zhPrivacyPolicy = ""
    
    var eula = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPrivacyPolicys()
    }
    
    func getPrivacyPolicys() {
        
        guard let zhPrivacyPolicy = Bundle.main.infoDictionary?["Privacy Policy zh-tw"] as? String,
              let enPrivacyPolicy = Bundle.main.infoDictionary?["Privacy Policy en-us"] as? String,
              let eula = Bundle.main.infoDictionary?["EULA"] as? String
        else {
            return
        }
        
        self.zhPrivacyPolicy = zhPrivacyPolicy
        
        self.enPrivacyPolicy = enPrivacyPolicy
        
        self.eula = eula
        
        textView.text = zhPrivacyPolicy
    }

    @IBAction func switchLanguage(_ sender: UISegmentedControl) {
        
        textView.text = sender.selectedSegmentIndex == 0 ? zhPrivacyPolicy : eula
    }
}
