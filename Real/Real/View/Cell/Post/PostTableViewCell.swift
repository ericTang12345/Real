//
//  PostTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/26.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var headPhotoImageView: UIImageView!
    
    @IBOutlet weak var randomTitleLabel: UILabel!
    
    @IBOutlet weak var createdTimeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var voteListStackView: UIStackView!
    
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var bookmarkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        
    }
}
