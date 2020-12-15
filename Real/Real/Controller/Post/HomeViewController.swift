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
    
    @IBOutlet weak var tableView: BaseTableView! {
        
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

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.passData = posts[indexPath.section]
        
        performSegue(withIdentifier: segues[0], sender: nil)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts[section].images.isEmpty == true ? 2 : 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sort = self.tableView.sortByCell(posts[indexPath.section])
        
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
        
        case .interaction(let cell):
            
            let cell = tableView.reuse(cell, indexPath: indexPath)
            
            cell.delegate = self
            
            cell.setup(data: post)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        
        case 0: return UITableView.automaticDimension
        
        case 1: return posts[indexPath.section].images.count == 0 ? UITableView.automaticDimension : 120
        
        case 2: return UITableView.automaticDimension
            
        default: return UITableView.automaticDimension
        
        }
    }
}

extension HomeViewController: PostMainTableViewCellDelegate {

    func postReloadView(cell: UITableViewCell) {

        tableView.reloadData()
    }
}

extension HomeViewController: InteractionTableViewCellDelegate {
    
    func goToPostDetails(cell: UITableViewCell) {
        
        performSegue(withIdentifier: segues[0], sender: nil)
    }
    
    func interactionReloadView(cell: UITableViewCell) {

        tableView.reloadData()
    }
}
