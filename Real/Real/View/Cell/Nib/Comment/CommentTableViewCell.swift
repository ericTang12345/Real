//
//  CommentTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/27.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var propicImageView: UIImageView!
    
    @IBOutlet weak var randomNameLabel: UILabel!
    
    @IBOutlet weak var createdTimeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    let firebase = FirebaseManager.shared
    
    var comment: Comment?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(data: Comment) {
        
        self.comment = data
        
        propicImageView.loadImage(urlString: data.authorImage, placeHolder: #imageLiteral(resourceName: "animal"))
        
        randomNameLabel.text = data.authorName
        
        createdTimeLabel.text = data.createdTime.compareCurrentTime()
        
        contentLabel.text = data.content
        
        likeCountLabel.text = data.likeCount.count == 0 ? .empty: String(data.likeCount.count)
        
    }
    
    @IBAction func likeComment(_ sender: UIButton) {
        
        sender.isSelected = !isSelected
        
        guard let comment = self.comment else { return }
        
        var likeCount = comment.likeCount
        
        likeCount.append("new_user_id")
        
        firebase.update(collectionName: .comment, documentId: comment.id, key: "likeCount", value: likeCount)
    }
}
