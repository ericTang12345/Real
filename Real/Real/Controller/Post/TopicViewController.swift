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
    
    var posts: [Post] = []
    
    var passData: Post?
    
    override var segues: [String] { return ["SeguePostDetails"] }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebase.listen(collectionName: .post) {
            
            self.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segues[0] {
            
            guard let nextViewController = segue.destination as? PostDetailsViewController else { return }
            
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
        
        let vote = posts[indexPath.section].vote
        
        switch sort[indexPath.row] {
        
        case .image: return 120
        
        case .vote: return CGFloat((vote.count) * 40 + 16)
        
        default : return UITableView.automaticDimension
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        
        case .interaction(let cell):
        
            let cell = tableView.reuse(cell, indexPath: indexPath)
            
            cell.delegate = self
            
            cell.setup(data: post, index: indexPath.section)
            
            return cell
        }
    }
}

extension TopicViewController: PostTableViewCellDelegate {

    func postReloadView(cell: UITableViewCell) {

        tableView.reloadData()
    }
}

extension TopicViewController: InteractionTableViewCellDelegate {
    
    func goToPostDetails(cell: UITableViewCell, index: Int) {
        
        self.passData = posts[index]
        
        performSegue(withIdentifier: segues[0], sender: nil)
    }
}
