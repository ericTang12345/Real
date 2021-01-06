//
//  PostMainTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/14.
//

import UIKit

protocol PostTableViewCellDelegate: AnyObject {
    
    func postReloadView(cell: UITableViewCell)
    
    func postEdit(cell: UITableViewCell, viewController: UIViewController)
    
    func postMoreFunction(cell: UITableViewCell, alert: UIAlertController)
}

class PostMainTableViewCell: BaseTableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet weak var authorImageView: UIImageView!
    
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var createdTimeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var moreContentButton: UIButton!
    
    @IBOutlet weak var moreFunctionButton: UIButton!
    
    // MARK: - variables
    
    weak var delegate: PostTableViewCellDelegate?
    
    var post: Post?
    
    // MARK: - override function
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - function
    
    func setup(data: Post) {
        
        self.post = data
        
        authorImageView.loadImage(urlString: data.authorImage)

        authorNameLabel.text = data.authorName

        createdTimeLabel.text = data.createdTime.compareCurrentTime()

        contentLabel.text = data.content

        moreContentButton.isHidden = contentLabel.numberOfLines == 0 ? true : contentLabel.textCount <= 4
    }
    
    func hidePost() {
        
        guard let user = self.userManager.userData, let post = self.post else { return }
        
        let doc = self.firebase.getCollection(name: .user).document(user.id)
        
        doc.updateData([
            
            "blockadeListPost": FIRFieldValue.arrayUnion([post.id])
        ])
    }
    
    // MARK: - IBAction function
    
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
                
                self.hidePost()
            }
            
            alert.addAction(hidePost)
            
            let report = UIAlertAction(title: "檢舉為不當內容", style: .destructive) { (_) in
                
                self.hidePost()
            }
            
            alert.addAction(report)
            
            let cancel = UIAlertAction(title: "返回", style: .cancel)
            
            alert.addAction(cancel)
            
            delegate.postMoreFunction(cell: self, alert: alert)
            
        // 如果是使用者 po 的
            
        } else {
            
            let editPost = UIAlertAction(title: "編輯貼文", style: .default) { (_) in
                
                guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostEditViewController") as? PostEditViewController else {
                    return
                }
                
                viewController.post = post
                
                viewController.modalPresentationStyle = .popover
                
                delegate.postEdit(cell: self, viewController: viewController)
            }
            
            alert.addAction(editPost)
            
            let deletePost = UIAlertAction(title: "刪除貼文", style: .destructive) { (_) in
                
                self.firebase.getCollection(name: .post).document(post.id).delete()
            }
            
            alert.addAction(deletePost)
            
            let cancel = UIAlertAction(title: "返回", style: .cancel)
            
            alert.addAction(cancel)
            
            delegate.postMoreFunction(cell: self, alert: alert)
        }
    }
}
