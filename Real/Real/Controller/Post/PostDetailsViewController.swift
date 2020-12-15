//
//  PostDetailsViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/29.
//

import UIKit

class PostDetailsViewController: BaseViewController {
    
    @IBOutlet var keyboardToolView: UIView!
    
    @IBOutlet weak var tableView: BaseTableView! {
        
        didSet {
            
            tableView.registerNib()
        }
    }
    
    @IBOutlet weak var replyTextField: UITextField! {
        
        didSet {
        
            replyTextField.inputAccessoryView = keyboardToolView
        }
    }
    
    var comments: [Comment] = []
    
    var post: Post?
    
    override var isHideTabBar: Bool { return true }
    
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
        
        guard let postId = post?.id,
              let content = replyTextField.text
        else {
            return
        }
        
        let document = firebase.getCollection(name: .comment).document()
        
        let comment = Comment(id: document.documentID, content: content, postId: postId)
        
        firebase.save(to: document, data: comment)
        
        keyboardToolView.endEditing(true)
    }
}

extension PostDetailsViewController: UITableViewDelegate {
    
}

extension PostDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        
        case 0:
            
            return 2
            
        case 1:
            
            return comments.count
            
        default:
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let post = self.post else { return .emptyCell }
        
        switch indexPath.section {
        
        case 0:
            
            let cell = tableView.reuse(PostMainTableViewCell.self, indexPath: indexPath)
            
            cell.setup(data: post)
            
            return cell
            
        case 1:
        
            let cell = tableView.reuse(CommentTableViewCell.self, indexPath: indexPath)
            
            cell.setup(data: comments[indexPath.row])
            
            return cell

        default:
            
            return .emptyCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        
        case 0:
            
            switch indexPath.row {
            
            case 1: return post?.images.count == 0 ? UITableView.automaticDimension : 150
                
            default: return UITableView.automaticDimension
                
            }
        
        default: return UITableView.automaticDimension
        
        }
    }
}

extension PostDetailsViewController: PostMainTableViewCellDelegate {

    func postReloadView(cell: UITableViewCell) {

        tableView.reloadData()
    }
}

extension PostDetailsViewController: InteractionTableViewCellDelegate {
    
    func goToPostDetails(cell: UITableViewCell) {
        
        performSegue(withIdentifier: segues[0], sender: nil)
    }
    
    func interactionReloadView(cell: UITableViewCell) {

        tableView.reloadData()
    }
}

//extension PostDetailsViewController: PostTableViewCellDelegate {
//
//    func reloadView(cell: PostTableViewCell) {
//
//        tableView.reloadData()
//    }
//
//    func goToPostDetails(cell: PostTableViewCell) {}
//}
