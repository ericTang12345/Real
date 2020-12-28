//
//  CommentTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/27.
//

import UIKit

protocol CommentTableViewCellDelegate: AnyObject {
    
    func hideComment(cell: UITableViewCell, alert: UIAlertController)
}

class CommentTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var propicImageView: UIImageView!
    
    @IBOutlet weak var randomNameLabel: UILabel!
    
    @IBOutlet weak var createdTimeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    weak var delegate: CommentTableViewCellDelegate?
    
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
        
        enableLognPress(sender: self, select: #selector(moreFunction))
        
        propicImageView.loadImage(urlString: data.authorImage, placeHolder: #imageLiteral(resourceName: "animal"))
        
        randomNameLabel.text = data.authorName
        
        createdTimeLabel.text = data.createdTime.compareCurrentTime()
        
        contentLabel.text = data.content
        
        likeCountLabel.text = data.likeCount.count == 0 ? .empty: String(data.likeCount.count)
        
        guard let user = userManager.userData else {
            
            print("CommentTableViewCell no user data")
            
            return
        }
        
        likeButton.isSelected = data.likeCount.contains(user.id)
    }
    
    func hideComment() {
        
        guard let user = self.userManager.userData, let comment = comment else { return }
        
        let doc = self.firebase.getCollection(name: .user).document(user.id)
        
        doc.updateData([
            
            "blockadeListComment": FIRFieldValue.arrayUnion([comment.id])
        ])
    }
    
    @objc func moreFunction() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.view.tintColor = .darkGray
        
        let hideComment = UIAlertAction(title: "隱藏留言", style: .default) { (_) in
            
            self.hideComment()
        }
        
        alert.addAction(hideComment)
        
        let cancel = UIAlertAction(title: "返回", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        delegate?.hideComment(cell: self, alert: alert)
    }
    
    @IBAction func likeComment(_ sender: UIButton) {
        
        guard let user = userManager.userData else {
            
            print(" CommentTableViewCell no user data")
            
            return
        }
        
        sender.isSelected = !sender.isSelected
        
        guard let comment = self.comment else { return }
        
        let collection = firebase.getCollection(name: .comment).document(comment.id)
        
        if comment.likeCount.contains(user.id) {
            
            collection.updateData([
                "likeCount": FIRFieldValue.arrayRemove([user.id])
            ])
            
        } else {
            
            collection.updateData([
                "likeCount": FIRFieldValue.arrayUnion([user.id])
            ])
        }
    }
}
