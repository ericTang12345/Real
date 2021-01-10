//
//  TopicViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/30.
//

import UIKit

class TopicViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.registerNib()
        }
    }
    
    var tagListView: TagListView?
    
    var posts: [Post] = []
    
    var passData: Post?
    
    override var segues: [String] { return ["SeguePostDetails"] }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 監聽 post
        firebase.listen(collectionName: .post) {
            
            self.reloadData()
        }
        
        // 監聽 comment
        self.firebase.listen(collectionName: .comment) {
        
            self.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .userDataUpdated, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segues[0] {
            
            guard let nextViewController = segue.destination as? PostDetailsViewController else { return }
            
            nextViewController.post = self.passData
        }
    }
    
    func hidePost() {
        
        guard let user = self.userManager.userData else { return }
        
        posts = posts.filter({ (post) -> Bool in
            
            return !user.blockadeListPost.contains(post.id)
        })
        
        tableView.reloadData()
    }
    
    func hideUser() {
        
        guard let user = self.userManager.userData else { return }
        
        posts = posts.filter({ (post) -> Bool in
            
            return !user.blockadeListUser.contains(post.authorId)
        })
        
        tableView.reloadData()
    }
    
    @objc func reloadData() {
        
        let filter = Filter(key: "type", value: "議題討論")
        
        firebase.read(collectionName: .post, dataType: Post.self, filter: filter) { [weak self] result in
            
            switch result {
            
            case .success(let posts):
                
                self?.posts = posts.sorted(by: {(first, second) -> Bool in
                    
                    return first.createdTime.dateValue() > second.createdTime.dateValue()
                })
                
                self?.hideUser()
                
                self?.hidePost()
                
                self?.tableView.reloadData()
                
            case .failure(let error):
            
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableView Delegate, DataSource

extension TopicViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TopicViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableView.sortByCell(posts[section]).count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let sort = tableView.sortByCell(posts[indexPath.section])
         
        let post = posts[indexPath.section]
        
        switch sort[indexPath.row] {
        
        case .tag: return tagListView?.frame.height ?? 0
        
        case .image: return 120
        
        case .vote: return CGFloat((post.votes.count) * 40 + 16)
        
        default : return UITableView.automaticDimension
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sort = tableView.sortByCell(posts[indexPath.section])
        
        let post = posts[indexPath.section]
        
        switch sort[indexPath.row] {
        
        case .main(let cell):
            
            let cell = tableView.reuse(cell, indexPath: indexPath)
            
            cell.delegate = self
            
            cell.setup(data: post)
            
            return cell
        
        case .tag(let cell):
            
            let cell = tableView.reuse(cell, indexPath: indexPath)
            
            cell.setup(strs: post.tags)
            
            self.tagListView = cell.tagList
            
            return cell
            
        case .image(let cell):
            
            let cell = tableView.reuse(cell, indexPath: indexPath)
            
            cell.delegate = self
            
            cell.setup(data: post)
            
            return cell
        
        case .vote(let cell):
            
            let cell = tableView.reuse(cell, indexPath: indexPath)
        
            cell.delegate = self
            
            cell.setup(data: post)
            
            return cell
        
        case .interaction(let cell):
        
            let cell = tableView.reuse(cell, indexPath: indexPath)
            
            cell.delegate = self
            
            cell.setup(data: post, index: indexPath.section)
            
            return cell
        }
    }
}

// MARK: - Delegate

extension TopicViewController: PostTableViewCellDelegate {
    
    func postEdit(cell: UITableViewCell, viewController: UIViewController) {
        
        present(viewController, animated: true, completion: nil)
    }
    
    func postMoreFunction(cell: UITableViewCell, alert: UIAlertController) {
        
        present(alert, animated: true, completion: nil)
    }
    
    func postReloadView(cell: UITableViewCell) {

        tableView.reloadData()
    }
}

extension TopicViewController: InteractionTableViewCellDelegate {
    
    func signinAlert(cell: UITableViewCell) {
    
        present(.signinAlert(handler: {
            
            let viewController = SigninWithAppleViewController.loadFromNib()
            
            viewController.modalPresentationStyle = .fullScreen
            
            viewController.delegate = self
            
            viewController.loadViewIfNeeded()
            
            self.present(viewController, animated: true, completion: nil)
            
        }), animated: true, completion: nil)
            
    }
    
    func goToPostDetails(cell: UITableViewCell, index: Int) {
        
        self.passData = posts[index]
        
        performSegue(withIdentifier: segues[0], sender: nil)
    }
}

extension TopicViewController: PostImageDelegate {
    
    func imageDidSelect(viewController: UIViewController) {
        
        viewController.modalPresentationStyle = .fullScreen
        
        present(viewController, animated: true, completion: nil)
    }
}
