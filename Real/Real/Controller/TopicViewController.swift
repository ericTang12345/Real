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
            
            tableViewSetup()
        }
    }
    
    let firebase = FirebaseManager.shared
    
    var posts: [Post] = []
    
    var passData: Post?
    
    override var segues: [String] {
        
        return ["SeguePostDetails"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebase.listen(collectionName: .post) {
            
            self.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segues[0] {
            
            guard let nextViewController = segue.destination as? PostDetailsViewController else {
                
                return
            }
            
            nextViewController.post = self.passData
        }
    }
    
    func reloadData() {
        
        let filter = Filter(key: "type", value: "議題討論")
        
        firebase.read(collectionName: .post, dataType: Post.self, filter: filter) { [weak self] result in
            
            switch result {
            
            case .success(let posts):
                
                self?.posts = posts.sorted(by: {(first, second) -> Bool in
                    
                    return first.createdTime.dateValue() > second.createdTime.dateValue()
                })
                
                self?.tableView.reloadData()
                
            case .failure(let error):
            
                print(error.localizedDescription)
            }
        }
        
    }
}

extension TopicViewController: PostTableViewCellDelegate {
    
    func goToPostDetails(cell: PostTableViewCell) {
        
        self.passData = cell.post
        
        performSegue(withIdentifier: segues[0], sender: nil)
    }
    
    func reloadView(cell: PostTableViewCell) {
        
        tableView.reloadData()
    }
}

extension TopicViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.passData = posts[indexPath.section]
        
        performSegue(withIdentifier: segues[0], sender: nil)
    }
}

extension TopicViewController: UITableViewDataSource {
    
    func tableViewSetup() {
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.registerCellWithNib(
            nibName: PostTableViewCell.nibName,
            identifier: .cell(identifier: .post)
        )
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.reuseCell(.post, indexPath) as? PostTableViewCell else {
            
            return .emptyCell
        }
        
        cell.delegate = self
        
        cell.setup(data: posts[indexPath.section])
        
        return cell
    }
}
