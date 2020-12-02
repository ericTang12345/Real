//
//  CommentTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/27.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var propicImageView: UIImageView!
    
    @IBOutlet weak var ranodmTitleLabel: UILabel!
    
    @IBOutlet weak var createdTimeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton! {
        
        didSet {
            
            likeButton.addTarget(self, action: #selector(like), for: .touchUpInside)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        
    }
    
    @objc func like() {
        
        self.likeButton.isSelected = !self.likeButton.isSelected
    }
    
}
