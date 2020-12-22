//
//  UserMessageTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/8.
//

import UIKit

class UserMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var createdTimeLabel: UILabel!
    
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

    override func layoutSubviews() {
        
        messageLabel.setup(cornerRadius: 10)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(data: Message, tableView: UITableView) {
        
        messageLabel.text = data.message
        
        messageLabel.sizeToFit()
        
        createdTimeLabel.text = data.createdTime.compareCurrentTime()
    }

}
