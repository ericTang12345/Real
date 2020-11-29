//
//  KeyboardToolView.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/29.
//

import UIKit

class KeyboardToolView: UIView {

    @IBOutlet weak var textField: CustomizeTextField!
    
    @IBOutlet weak var prefixLabel: UILabel!
    
    @IBOutlet weak var randomTitleLabel: UILabel! 
    
    @IBOutlet weak var replyButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func customInit() {
        
        loadFormNib(KeyboardToolView.nibName)
    }
    

}
