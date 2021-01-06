//
//  HomeViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/25.
//

import UIKit
import FirebaseFirestoreSwift
import Firebase

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.registerNib()
        }
    }
    
    var posts: [Post] = []
    
    var passData: Post?
    
    var tagListView: TagListView?
    
    override var segues: [String] { return ["SeguePostDetails"] }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PostProvider().getOneTypePost(.post) { (result) in
            
            switch result {
            
            case .success(let posts):
                
                print("Posts:", posts)
                
            case .failure(let error):
                
                print("error:", error)
            }
        }
        
        self.firebase.listen(collectionName: .post) {
            
            self.reloadData()
        }
        
        self.firebase.listen(collectionName: .comment) {
        
            self.reloadData()
        }
    
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .userDataUpdated, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segues[0] {
            
            guard let nextViewController = segue.destination as? PostDetailsViewController else {
                
                return
            }
            
            nextViewController.post = self.passData
        }
    }
    
    @objc func reloadData() {
        
        let filter = Filter(key: "type", value: "心情貼文")
        
        firebase.read(collectionName: .post, dataType: Post.self, filter: filter) { [weak self] result in
        
            switch result {
            
            case .success(let data):
                
                self?.posts = data.sorted { (first, second) -> Bool in
                    
                    return first.createdTime.dateValue() > second.createdTime.dateValue()
                }
                
                self?.hidePost()
                
                self?.tableView.reloadData()
                
            case .failure(let error):
                
                print(error.localizedDescription)
            
            }
        }
    }
    
    func hidePost() {
        
        guard let user = self.userManager.userData else { return }
        
        posts = posts.filter({ (post) -> Bool in
            
            return !user.blockadeListPost.contains(post.id)
        })
        
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableView.sortByCell(posts[section]).count
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
            
            cell.setup(strs: posts[indexPath.section].tags)
            
            self.tagListView = cell.tagList
            
            return cell
         
        case .image(let cell):
            
            let cell = tableView.reuse(cell, indexPath: indexPath)
            
            cell.delegate = self
            
            cell.setup(data: post)
                    
            return cell
            
        case .vote: return .emptyCell // 心情貼文不會有投票
        
        case .interaction(let cell):
            
            let cell = tableView.reuse(cell, indexPath: indexPath)
            
            cell.delegate = self
            
            cell.setup(data: post, index: indexPath.section)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let sort = tableView.sortByCell(posts[indexPath.section])
        
        switch sort[indexPath.row] {
    
        case .tag: return (tagListView?.frame.size.height) == nil ? 0 : tagListView!.frame.size.height
            
        case .image: return posts[indexPath.section].images.count == 0 ? UITableView.automaticDimension : 120
            
        default: return UITableView.automaticDimension
        
        }
    }
}

extension HomeViewController: PostTableViewCellDelegate {
    
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

extension HomeViewController: InteractionTableViewCellDelegate {
    
    func signinAlert(cell: UITableViewCell) {
            
        present(.signinAlert(handler: {
            
            let viewController = SigninWithAppleViewController.loadFromNib()
            
            viewController.modalPresentationStyle = .fullScreen
            
            viewController.loadViewIfNeeded()
            
            viewController.delegate = self
            
            self.present(viewController, animated: true, completion: nil)
            
        }), animated: true, completion: nil)
    }
    
    func goToPostDetails(cell: UITableViewCell, index: Int) {
        
        self.passData = posts[index]
        
        performSegue(withIdentifier: segues[0], sender: nil)
    }
}

extension HomeViewController: PostImageDelegate {
    
    func imageDidSelect(viewController: UIViewController) {
        
        viewController.modalPresentationStyle = .fullScreen
        
        present(viewController, animated: true, completion: nil)
    }
}
 
