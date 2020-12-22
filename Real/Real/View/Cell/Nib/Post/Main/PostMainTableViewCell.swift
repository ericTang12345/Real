//
//  PostMainTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/14.
//

import UIKit

protocol PostTableViewCellDelegate: AnyObject {
    
    func postReloadView(cell: UITableViewCell)
    
    func postEditFunction(cell: UITableViewCell, alert: UIAlertController)
    
    func postMoreFunction(cell: UITableViewCell, alert: UIAlertController)
}

class PostMainTableViewCell: BaseTableViewCell {

    @IBOutlet weak var authorImageView: UIImageView!
    
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var createdTimeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var moreContentButton: UIButton!
    
    @IBOutlet weak var moreFunctionButton: UIButton!
    
    weak var delegate: PostTableViewCellDelegate?
    
    var post: Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(data: Post) {
        
        self.post = data
        
        authorImageView.loadImage(urlString: data.authorImage)

        authorNameLabel.text = data.authorName

        createdTimeLabel.text = data.createdTime.compareCurrentTime()

        contentLabel.text = data.content

        moreContentButton.isHidden = contentLabel.numberOfLines == 0 ? true : contentLabel.textCount <= 4
    }
    
    func hideUser() {
        
    }
    
    func hidePost() {
        
    }
    
    @IBAction func showMoreContent(_ sender: UIButton) {
        
        contentLabel.numberOfLines = 0
        
        moreContentButton.isHidden = true
        
        guard let delegate = delegate else { return }
        
        delegate.postReloadView(cell: self)
    }
    
    @IBAction func moreFunction(_ sender: UIButton) {
        
        guard let delegate = delegate, let user = userManager.userData, let post = post else { return }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.view.tintColor = .gray
        
        // 如果這篇 post 不是使用者 po 的
        
        if post.authorId != user.id {
            
            let hidePost = UIAlertAction(title: "隱藏貼文", style: .default) { (_) in
                
                guard let user = self.userManager.userData, let post = self.post else { return }
                
                let doc = self.firebase.getCollection(name: .user).document(user.id)
                
                doc.updateData([
                    "blockadeListPost": FIRFieldValue.arrayUnion([post.id])
                ])
            }
            
            alert.addAction(hidePost)
            
            let hideUser = UIAlertAction(title: "封鎖這名使用者", style: .destructive) { (_) in
                
                guard let user = self.userManager.userData, let post = self.post else { return }
                
                let doc = self.firebase.getCollection(name: .user).document(user.id)
                
                doc.updateData([
                    "blockadeListUser": FIRFieldValue.arrayUnion([post.authorId])
                ])
            }
            
            alert.addAction(hideUser)
            
            let cancel = UIAlertAction(title: "返回", style: .cancel)
            
            alert.addAction(cancel)
            
            delegate.postMoreFunction(cell: self, alert: alert)
            
        // 如果是使用者 po 的
            
        } else {
            
            let editPost = UIAlertAction(title: "編輯貼文", style: .default) { (_) in
                
            }
            
            alert.addAction(editPost)
            
            let deletePost = UIAlertAction(title: "刪除貼文", style: .destructive) { (_) in
                
            }
            
            alert.addAction(deletePost)
            
            let cancel = UIAlertAction(title: "返回", style: .cancel)
            
            alert.addAction(cancel)
            
            delegate.postEditFunction(cell: self, alert: alert)
        }
    }
}
