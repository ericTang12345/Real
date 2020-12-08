//
//  NotificationTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/7.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setup(data: MockData) {
        
        titleLabel.text = data.title
        
        contentLabel.text = data.content
    }
}
