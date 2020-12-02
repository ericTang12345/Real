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
    
    override var segues: [String] {
        
        return ["SeguePostDetails"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension TopicViewController: PostTableViewCellDelegate {
    
    func reloadView(cell: PostTableViewCell) {
        
        tableView.reloadData()
    }
}

extension TopicViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
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
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.reuseCell(.post, indexPath) as? PostTableViewCell else {
            
            return .emptyCell
        }
        
        cell.delegate = self
        
        return cell
    }
}
