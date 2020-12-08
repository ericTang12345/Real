//
//  ReceiverTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/8.
//

import UIKit

class ReceiverTableViewCell: UITableViewCell {

    @IBOutlet weak var receiverImageView: UIImageView!
    
    @IBOutlet weak var messageLabel: LabelPadding! {
        
        didSet {
            
            messageLabel.textColor = .white
            
            messageLabel.backgroundColor = .black
            
            messageLabel.layer.cornerRadius = 15
            
            messageLabel.clipsToBounds = true
            
//            messageLabel.setupBorder(width: 0.8, color: .lightGray)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
