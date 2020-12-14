//
//  InteractionTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/14.
//

import UIKit

class InteractionTableViewCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UIButton!
    
    @IBOutlet weak var bookmarkButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var commentCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func bookmark(_ sender: UIButton) {
    
    }
    
    @IBAction func comment(_ sender: UIButton) {
    
    }
    
    @IBAction func like(_ sender: UIButton) {
    
    }
}
