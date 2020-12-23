//
//  InteractionTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/14.
//

import UIKit

protocol InteractionTableViewCellDelegate: AnyObject {
    
    func goToPostDetails(cell: UITableViewCell, index: Int)
    
    func signinAlert(cell: UITableViewCell)
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
        
        commentButton.tag = index
        
        getCommentCount(postId: data.id)
        
        likeCountLabel.text = data.likeCount.count == 0 ? "0" : String(data.likeCount.count)
        
        guard let user = userManager.userData else { return }
        
        likeButton.isSelected = data.likeCount.contains(user.id)
        
        bookmarkButton.isSelected = data.collection.contains(user.id)
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
        
        guard let post = post, let user = userManager.userData else {
            
            print("post or delegate is nil in InteractionTableViewCell")
            
            return
        }
        
        let collection = firebase.getCollection(name: .post).document(post.id)
        
        if post.collection.contains(user.id) {
            
            collection.updateData([
                
                "collection": FIRFieldValue.arrayRemove([user.id])
            ])
            
        } else {
            
            collection.updateData([
                
                "collection": FIRFieldValue.arrayUnion([user.id])
            ])
        }
    }
    
    @IBAction func comment(_ sender: UIButton) {
        
        guard let delegate = delegate else { return }
        
        delegate.goToPostDetails(cell: self, index: sender.tag)
    }
    
    @IBAction func like(_ sender: UIButton) {
        
        // 檢查 delegate
        
        guard let delegate = delegate else { return }
        
        // 檢查是否登入
        
        if !userManager.isSignin {
            
            delegate.signinAlert(cell: self)
            
            return
        }
        
        // 檢查貼文、使用者資料
        
        guard let post = post, let user = userManager.userData else {
            
            print("post or delegate is nil in InteractionTableViewCell")
            
            return
        }
        
        // 狀態更新
        
        sender.isSelected = !sender.isSelected
        
        let collection = firebase.getCollection(name: .post).document(post.id)
        
        if post.likeCount.contains(user.id) {
            
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
