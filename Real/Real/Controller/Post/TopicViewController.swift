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
//
//extension TopicViewController: PostTableViewCellDelegate {
//
//    func goToPostDetails(cell: PostTableViewCell) {
//
//        self.passData = cell.post
//
//        performSegue(withIdentifier: segues[0], sender: nil)
//    }
//
//    func reloadView(cell: PostTableViewCell) {
//
//        tableView.reloadData()
//    }
//}

extension TopicViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            self.passData = posts[indexPath.section]
            
            performSegue(withIdentifier: segues[0], sender: nil)
            
        } else {
            
            let cell = tableView.cellForRow(at: indexPath)
            
            let checkMark = UIImage(systemName: "checkmark.circle")?.withRenderingMode(.alwaysOriginal)
            
            let circle = UIImage(systemName: "circle")?.withRenderingMode(.alwaysOriginal)
            
            let cellImage = cell?.imageView?.image
            
            cell?.imageView?.image = cellImage == checkMark ? circle : checkMark
            
        }
    }
}

extension TopicViewController: UITableViewDataSource {
    
    func tableViewSetup() {
        
//        tableView.registerCellWithNib(
//            nibName: PostTableViewCell.nibName,
//            identifier: .cell(identifier: .post)
//        )
  
//        tableView.registerCellWithNib(cell: <#T##UITableViewCell.Type#>)
        
//        tableView.registerCellWithNib(nibName: PostMainTableViewCell.nibName, identifier: "PostMainCell")
//
//        tableView.registerCellWithNib(nibName: InteractionTableViewCell.nibName, identifier: "InteractionCell")
//
//        tableView.registerCellWithNib(nibName: PostImageTableViewCellNib.nibName, identifier: "PostImageCellNib")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 2
        
        let post = posts[section]
        
        if post.vote.isEmpty { count += 1 }
        
        if post.images.isEmpty { count += 1 }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        switch indexPath.row {
//
//        case 0:
//
//            guard let cell = tableView.reuseCell(.post, indexPath) as? PostTableViewCell else {
//
//                return .emptyCell
//            }
//
//            cell.delegate = self
//
//            cell.setup(data: posts[indexPath.section])
//
//            return cell
//
//        default:
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "VoteCell", for: indexPath)
//
//            cell.textLabel?.text = posts[indexPath.section].vote[indexPath.row]
//
//            return cell
//        }
        
        return UITableViewCell()
    }
}

extension TopicViewController: PostMainTableViewCellDelegate {

    func postReloadView(cell: UITableViewCell) {

        tableView.reloadData()
    }
}

extension TopicViewController: InteractionTableViewCellDelegate {
    
    func goToPostDetails(cell: UITableViewCell) {
        
        performSegue(withIdentifier: segues[0], sender: nil)
    }
    
    func interactionReloadView(cell: UITableViewCell) {

        tableView.reloadData()
    }
}