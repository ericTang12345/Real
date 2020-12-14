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
    
    func reloadData() {
        
        let filter = Filter(key: "type", value: "心情貼文")
        
        firebase.read(collectionName: .post, dataType: Post.self, filter: filter) { [weak self] result in
            
            switch result {
            
            case .success(let posts):
                
                self?.posts = posts.sorted { (first, second) -> Bool in
                    
                    return first.createdTime.dateValue() > second.createdTime.dateValue()
                }
                
                self?.tableView.reloadData()
                
            case .failure(let error):
                
                print(error.localizedDescription)
            
            }
        }
    }
}

extension HomeViewController: PostTableViewCellDelegate {
    
    func goToPostDetails(cell: PostTableViewCell) {
        
        self.passData = cell.post
        
        performSegue(withIdentifier: segues[0], sender: nil)
    }

    func reloadView(cell: PostTableViewCell) {
        
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.passData = posts[indexPath.section]
        
        performSegue(withIdentifier: segues[0], sender: nil)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableViewSetup() {
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.registerCellWithNib(
            nibName: PostTableViewCell.nibName,
            identifier: .cell(identifier: .post)
        )
        
        tableView.registerCellWithNib(nibName: PostMainTableViewCell.nibName, identifier: "PostMainCell")
        
        tableView.registerCellWithNib(nibName: InteractionTableViewCell.nibName, identifier: "InteractionCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts[section].images.count == 0 ? 2 : 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch indexPath.row {
        
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostMainCell", for: indexPath) as? PostMainTableViewCell else {
                
                return .emptyCell
            }
            
            return cell
        
        case 1:
            
            if posts[indexPath.section].images.count == 0 {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "InteractionCell", for: indexPath) as? InteractionTableViewCell else {
                    
                    return .emptyCell
                }
                
                return cell
                
            } else {
                
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostImagesCell", for: indexPath) as? PostImageTableViewCell else {
//
//                    return .emptyCell
//                }
//
//                return cell
                
                return.emptyCell
                
            }
        
        case 2:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostMainCell", for: indexPath) as? PostMainTableViewCell else {
                
                return .emptyCell
            }
            
            return cell
        
        default: return .emptyCell
        
        }
        
        
//        guard let cell = tableView.reuseCell(.post, indexPath) as? PostTableViewCell else {
//
//            return .emptyCell
//        }
//
//        cell.delegate = self
//
//        cell.setup(data: posts[indexPath.section])
//
//        return cell
    }
}
