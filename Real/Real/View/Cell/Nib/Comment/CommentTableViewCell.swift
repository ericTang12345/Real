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
    
    func hideUser() {
        
        guard let user = self.userManager.userData, let comment = self.comment else { return }
        
        let doc = self.firebase.getCollection(name: .user).document(user.id)
        
        doc.updateData([
            
            "blockadeListUser": FIRFieldValue.arrayUnion([comment.author])
        ])
    }
    
    func removeComment() {
        
        guard let comment = self.comment else { return }
        
        let doc = self.firebase.getCollection(name: .comment)
        
        doc.document(comment.id).delete()
    }
    
    @objc func moreFunction() {
        
        guard let user = userManager.userData, let comment = comment else { return }
        
        if comment.author == user.id {
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.view.tintColor = .darkGray
            
            let removeComment = UIAlertAction(title: "刪除留言", style: .destructive) { (_) in
                
                self.removeComment()
            }
            
            alert.addAction(removeComment)
            
            let cencel = UIAlertAction(title: "返回", style: .cancel, handler: nil)
            
            alert.addAction(cencel)
            
            delegate?.hideComment(cell: self, alert: alert)
            
        } else {
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.view.tintColor = .darkGray
            
            let hideComment = UIAlertAction(title: "隱藏留言", style: .default) { (_) in
                
                self.hideComment()
            }
            
            alert.addAction(hideComment)
            
            let report = UIAlertAction(title: "檢舉為不當內容", style: .destructive) { (_) in
                
                self.hideComment()
            }
            
            alert.addAction(report)
            
            let hideUser = UIAlertAction(title: "封鎖、隱藏這名使用者所有相關內容", style: .destructive) { (_) in
                
                self.hideUser()
            }
            
            alert.addAction(hideUser)
            
            let cancel = UIAlertAction(title: "返回", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            
            delegate?.hideComment(cell: self, alert: alert)
        }
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
