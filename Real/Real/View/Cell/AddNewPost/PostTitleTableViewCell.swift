//
//  PostTitleTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/1.
//

import UIKit

class PostTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var postTypeButton: UIButton!
    
    @IBOutlet weak var propicImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
