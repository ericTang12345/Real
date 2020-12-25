//
//  HideListViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/25.
//

import UIKit

class HideListViewController: BaseViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.registerNib()
        }
    }
    
    var posts: [Post] = []
    
    var comments: [Comment] = []
    
    var tagListView: TagListView?
    
    var post: Post?
    
    override var segues: [String] { ["SeguePostDetail"] }
    
    override var isHideTabBar: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .userDataUpdated, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SeguePostDetail" {
            
            let nextViewController = segue.destination as? PostDetailsViewController
            
            nextViewController?.post = self.post
        }
    }
    
    @objc func reloadData() {
        
        readPost()
        
        readComment()
    }
    
    func readPost() {
        
        guard let user = userManager.userData else { return }
        
        var posts: [Post] = []
        
        for postId in user.blockadeListPost {
            
            let filter = Filter(key: "id", value: postId)
            
            firebase.read(collectionName: .post, dataType: Post.self, filter: filter) { (result) in
                
                switch result {
            
                case .success(let data):
                    
                    posts.append(data[0])
                    
                    if posts.count == user.blockadeListPost.count {
                        
                        self.posts = posts
                        
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                
                    print("read Post error", error)
                }
            }
        }
    }
    
    func readComment() {
        
        guard let user = userManager.userData else { return }
        
        var comments: [Comment] = []
        
        for commentId in user.blockadeListComment {
            
            let filter = Filter(key: "id", value: commentId)
            
            firebase.read(collectionName: .comment, dataType: Comment.self, filter: filter) { (result) in
                
                switch result {
            
                case .success(let data):
                    
                    comments.append(data[0])
                    
                    if comments.count == user.blockadeListComment.count {
                        
                        self.comments = comments
                        
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                
                    print("read Post error", error)
                }
            }
        }
    }
    
    @IBAction func switchItem(_ sender: UISegmentedControl) {
    
        tableView.separatorStyle = sender.selectedSegmentIndex == 0 ? .none:.singleLine
        
        tableView.reloadData()
    }
}

extension HideListViewController: UITableViewDelegate {
    
}

extension HideListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return segmentedControl.selectedSegmentIndex == 0 ? posts.count : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return segmentedControl.selectedSegmentIndex == 0 ? tableView.sortByCell(posts[section]).count : comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch segmentedControl.selectedSegmentIndex {
        
        case 0:
            
            let sort = tableView.sortByCell(posts[indexPath.section])
            
            let post = posts[indexPath.section]
            
            switch sort[indexPath.row] {
        
            case .main(let cell):
                
                let cell = tableView.reuse(cell, indexPath: indexPath)
                
                cell.setup(data: post)
                
                return cell
                
            case .image(let cell):
                
                let cell = tableView.reuse(cell, indexPath: indexPath)
                
                cell.setup(data: post)
                
                return cell
                
            case .vote(let cell):
                
                let cell = tableView.reuse(cell, indexPath: indexPath)
                
                cell.setup(data: post)
                
                return cell
                
            case .tag(let cell):
                
                let cell = tableView.reuse(cell, indexPath: indexPath)
                
                cell.setup(strs: post.tags)
                
                self.tagListView = cell.tagList
                
                return cell
                
            case .interaction(let cell):
                
                let cell = tableView.reuse(cell, indexPath: indexPath)
                
                cell.setup(data: post, index: indexPath.section)
                
                return cell
            }
            
        case 1:
        
            let cell = tableView.reuse(CommentTableViewCell.self, indexPath: indexPath)
            
            cell.setup(data: comments[indexPath.row])
            
            return cell
            
        default:
            
            return .emptyCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            let sort = tableView.sortByCell(posts[indexPath.section])
            
            let post = posts[indexPath.section]
            
            switch sort[indexPath.row] {

            case .image:
                
                return posts[indexPath.section].images.count == 0 ? UITableView.automaticDimension : 120
                
            case .vote:
                
                return CGFloat((post.votes.count) * 40 + 16)
                
            case .tag:
                
                return (tagListView?.frame.size.height) == nil ? 0 : tagListView!.frame.size.height
                
            default:
                
                return UITableView.automaticDimension
            }
            
        } else {
            
            return UITableView.automaticDimension
        }
    }
}
