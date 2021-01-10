//
//  BaseTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/15.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    let firebase = FirebaseManager.shared
    
    let userManager = UserManager.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
