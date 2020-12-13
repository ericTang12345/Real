//
//  PostTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/26.
//

import UIKit

protocol PostTableViewCellDelegate: AnyObject {
    
    func reloadView(cell: PostTableViewCell)
    
    func goToPostDetails(cell: PostTableViewCell)
}

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!

    @IBOutlet weak var bookmarkButton: UIButton!
    
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var headPhotoImageView: UIImageView!
    
    @IBOutlet weak var randomNameLabel: UILabel!
    
    @IBOutlet weak var createdTimeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var commentCountLabel: UILabel!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    weak var delegate: PostTableViewCellDelegate?
    
    let firebase = FirebaseManager.shared
    
    let userManager = UserManager.shared
    
    var post: Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(data: Post) {
        
        self.post = data
        
        headPhotoImageView.loadImage(urlString: data.authorImage, placeHolder: #imageLiteral(resourceName: "animal"))
        
        randomNameLabel.text = data.authorName
        
        createdTimeLabel.text = data.createdTime.compareCurrentTime()
        
        contentLabel.text = data.content
        
        likeCountLabel.text = data.likeCount.count == 0 ? "0" : String(data.likeCount.count)
    
        getCommentCount(postId: data.id)
        
        // 查看更多
        
        moreButton.isHidden = contentLabel.numberOfLines == 0 ? true : contentLabel.textCount <= 4
        
        likeButton.isSelected = data.likeCount.contains(userManager.userID)
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
    }
    
    @IBAction func addComment(_ sender: UIButton) {
        
        guard let delegate = delegate else { return }
        
        delegate.goToPostDetails(cell: self)
    }
    
    @IBAction func likePost(_ sender: UIButton) {
        
        // Data
        
        guard let post = post, let delegate = delegate else {
            
            print("post or delegate is nil in PostTableViewCell")
            
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
        
        // View
        
        sender.isSelected = !sender.isSelected
        
        delegate.reloadView(cell: self)
    }
    
    @IBAction func moreContent(_ sender: UIButton) {
        
        contentLabel.numberOfLines = 0
        
        moreButton.isHidden = true
        
        guard let delegate = delegate else { return }
        
        delegate.reloadView(cell: self)
    }
}
