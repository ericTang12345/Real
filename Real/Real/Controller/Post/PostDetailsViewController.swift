//
//  PostDetailsViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/29.
//

import UIKit

class PostDetailsViewController: BaseViewController {
    
    @IBOutlet var keyboardToolView: UIView!
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.registerNib()
        }
    }
    
    @IBOutlet weak var commentTextView: UITextView! {
        
        didSet {
            
            commentTextView.delegate = self
        }
    }
    
    @IBOutlet weak var placeholderLabel: UILabel!
    
    var comments: [Comment] = []
    
    var post: Post?
    
    override var isHideTabBar: Bool { return true }
    
    override var isEnableHideKeyboardWhenTappedAround: Bool { true }
    
    override var isEnableKeyboardNotification: Bool { true }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebase.listen(collectionName: .post) {
            
            self.reloadPostData()
        }
        
        firebase.listen(collectionName: .comment) {
            
            self.reloadCommentData()
        }
    }
    
    func reloadPostData() {
        
        guard let id = post?.id else {
            
            print("reloadPostData error: post.id is nil")
            
            return
        }
        
        let filter = Filter(key: "id", value: id)
        
        firebase.read(collectionName: .post, dataType: Post.self, filter: filter) { [weak self] result in
            
            switch result {
            
            case .success(let data):
                
                self?.post = data[0]
            
                self?.tableView.reloadData()
                
            case .failure(let error):
                
                print("postDetails reloadPostData fail", error.localizedDescription)
            }
        }
    }
    
    func reloadCommentData() {
        
        guard let id = post?.id else {
            
            print("reloadCommentData error: post.id is nil")
            
            return
        }
        
        let filter = Filter(key: "postId", value: id)
        
        firebase.read(collectionName: .comment, dataType: Comment.self, filter: filter) { [weak self] result in
            
            switch result {
            
            case .success(let comments):
                
                self?.comments = comments.sorted(by: { (first, second) -> Bool in
                    
                    return first.createdTime.dateValue() > second.createdTime.dateValue()
                })
                
                self?.tableView.reloadData()
                
            case .failure(let error):
                
                print("postDetails reloadCommentData fail", error.localizedDescription)
            }
        }
    }
    
    @IBAction func reply(_ sender: UIButton) {
        
        guard let postId = post?.id, let content = commentTextView.text, let user = userManager.userData else { return }
        
        let document = firebase.getCollection(name: .comment).document()
        
        let comment = Comment(id: document.documentID, content: content, author: user.id, postId: postId)
        
        firebase.save(to: document, data: comment)
        
        keyboardToolView.endEditing(true)
    }
}

extension PostDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let post = post else { return 0 }
        
        return section == 0 ? tableView.sortByCell(post).count : comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let post = self.post else { return .emptyCell }
        
        let sort = tableView.sortByCell(post)
        
        if indexPath.section == 0 {
        
            switch sort[indexPath.row] {
            
            case .main(let cell):
                
                let cell = tableView.reuse(cell, indexPath: indexPath)
                
                cell.setup(data: post)
                
                cell.contentLabel.numberOfLines = 0
                
                cell.moreContentButton.isHidden = true
                
                return cell
                
            case .image(let cell):
                
                let cell = tableView.reuse(cell, indexPath: indexPath)
                
                cell.setup(data: post)
                
                return cell
                
            case .vote(let cell):
            
                let cell = tableView.reuse(cell, indexPath: indexPath)
                
                cell.setup(data: post)
                
                return cell
                
            case .interaction(let cell):
                
                let cell = tableView.reuse(cell, indexPath: indexPath)
                
                cell.setup(data: post, index: indexPath.section)
                
                cell.delegate = self
                
                return cell
            }
        } else {
            
            let cell = tableView.reuse(CommentTableViewCell.self, indexPath: indexPath)
            
            cell.setup(data: comments[indexPath.row])
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let post = post else { return 0 }
        
        let sort = tableView.sortByCell(post)
        
        switch indexPath.section {
        
        case 0:
            
            switch sort[indexPath.row] {
            
            case .image: return post.images.count == 0 ? UITableView.automaticDimension : 120
            
            case .vote: return CGFloat((post.votes.count) * 40 + 16)
                
            default: return UITableView.automaticDimension
                
            }
        
        default: return UITableView.automaticDimension
        
        }
    }
}

extension PostDetailsViewController: InteractionTableViewCellDelegate {
    
    func signinAlert(cell: UITableViewCell) {
        
        let alert = userManager.showAlert(viewController: self)
            
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToPostDetails(cell: UITableViewCell, index: Int) {
        
    }
}

extension PostDetailsViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (textView.text.count + text.count - range.length) == 0 {
            
            placeholderLabel.isHidden = false
            
        } else {
            
            placeholderLabel.isHidden = true
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        placeholderLabel.isHidden = true
        
        textView.text = nil
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.count == 0 {
            
            placeholderLabel.isHidden = false
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.textCountLines() <= 10 {
            
            NSLayoutConstraint.activate([
                textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
            ])
            
            textView.isScrollEnabled = false
            
        } else {
            
            NSLayoutConstraint.activate([
                textView.heightAnchor.constraint(equalToConstant: 200)
            ])
            
            textView.isScrollEnabled = true
        }
    }
}
