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
            
            messageLabel.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
