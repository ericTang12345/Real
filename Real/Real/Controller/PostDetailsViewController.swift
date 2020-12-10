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
            
            tableViewSetup()
        }
    }
    
    @IBOutlet weak var replyTextField: UITextField! {
        
        didSet {
        
            replyTextField.inputAccessoryView = keyboardToolView
        }
    }
    
    let firebase = FirebaseManager.shared
    
    let userManager = UserManager.shared
    
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
        
        let comment = Comment(id: document.documentID,
                              content: content,
                              likeCount: [],
                              createdTime: firebase.currentTimestamp,
                              author: userManager.userID,
                              postId: postId,
                              authorName: "weakself",
                              authorImage: "")
        
        firebase.save(to: document, data: comment)
        
        keyboardToolView.endEditing(true)
    }
}

extension PostDetailsViewController: UITableViewDelegate {
    
}

extension PostDetailsViewController: UITableViewDataSource {
    
    func tableViewSetup() {
        
        tableView.registerCellWithNib(
            nibName: PostTableViewCell.nibName,
            identifier: .cell(identifier: .post)
        )
        
        tableView.registerCellWithNib(
            nibName: CommentTableViewCell.nibName,
            identifier: .cell(identifier: .comment)
        )
        
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 1 : comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        
        case 0:
            
            guard let cell = tableView.reuseCell(.post, indexPath) as? PostTableViewCell else {
                
                return .emptyCell
            }
            
            cell.contentLabel.numberOfLines = 0
            
            cell.moreButton.isHidden = true
            
            guard let post = self.post else {
                
                return .emptyCell
            }
            
            cell.delegate = self
            
            cell.setup(data: post)
            
            return cell
        
        case 1:
            
            guard let cell = tableView.reuseCell(.comment, indexPath) as? CommentTableViewCell else {
                
                return .emptyCell
            }
            
            cell.setup(data: comments[indexPath.row])
            
            return cell
        
        default:
            
            return .emptyCell
        }
    }
}

extension PostDetailsViewController: PostTableViewCellDelegate {
    
    func reloadView(cell: PostTableViewCell) {
        
        tableView.reloadData()
    }
    
    func goToPostDetails(cell: PostTableViewCell) {}
}
