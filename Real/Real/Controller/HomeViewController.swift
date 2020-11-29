//
//  HomeViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/25.
//

import UIKit

class HomeViewController: BaseViewController {
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segues[0] {
            
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
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
        
        return cell
    }
}
