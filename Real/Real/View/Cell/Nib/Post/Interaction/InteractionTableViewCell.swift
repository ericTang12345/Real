//
//  InteractionTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/14.
//

import UIKit

protocol InteractionTableViewCellDelegate: AnyObject {
    
    func goToPostDetails(cell: UITableViewCell, index: Int)
}

class InteractionTableViewCell: BaseTableViewCell {

    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var bookmarkButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var commentCountLabel: UILabel!
    
    var post: Post?
    
    weak var delegate: InteractionTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(data: Post, index: Int) {
        
        self.post = data
        
        getCommentCount(postId: data.id)
        
        likeCountLabel.text = data.likeCount.count == 0 ? "0" : String(data.likeCount.count)
        
        likeButton.isSelected = data.likeCount.contains(userManager.userID)
        
        bookmarkButton.isSelected = data.collection.contains(userManager.userID)
        
        commentButton.tag = index
    }
    
    func getCommentCount(postId: String) {
        
        // Comment count
        
        let filter = Filter(key: "postId", value: postId)
        
        firebase.read(collectionName: .comment, dataType: Comment.self, filter: filter) { [weak self] result in
            
            switch result {
            
            case .success(let comments):
                
                guard let strongSelf = self else { return }
                
                strongSelf.commentCountLabel.text = String(comments.count)
            
            case .failure(let error):
                
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func bookmark(_ sender: UIButton) {
    
        sender.isSelected = !sender.isSelected
        
        guard let post = post else {
            
            print("post or delegate is nil in InteractionTableViewCell")
            
            return
        }
        
        let collection = firebase.getCollection(name: .post).document(post.id)
        
        if post.collection.contains(userManager.userID) {
            
            collection.updateData([
                "collection": FIRFieldValue.arrayRemove([userManager.userID])
            ])
            
        } else {
            
            collection.updateData([
                "collection": FIRFieldValue.arrayUnion([userManager.userID])
            ])
        }
    }
    
    @IBAction func comment(_ sender: UIButton) {
        
        guard let delegate = delegate else { return }
        
        delegate.goToPostDetails(cell: self, index: sender.tag)
    }
    
    @IBAction func like(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        guard let post = post else {
            
            print("post or delegate is nil in InteractionTableViewCell")
            
            return
        }
        
        let collection = firebase.getCollection(name: .post).document(post.id)
        
        if post.likeCount.contains(userManager.userID) {
            
            collection.updateData([
                "likeCount": FIRFieldValue.arrayRemove([userManager.userID])
            ])
            
        } else {

            collection.updateData([
                "likeCount": FIRFieldValue.arrayUnion([userManager.userID])
            ])
        }
    }
}
