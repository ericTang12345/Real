//
//  HomeViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/25.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.delegate = self
            
            tableView.dataSource = self
            
            tableView.registerCellWithNib(
                nibName: PostTableViewCell.nibName,
                idienifiter: .idenifiter(.post)
            )
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: .idenifiter(.post),
            for: indexPath
        ) as? PostTableViewCell else {
            
            print("home post cell is nil")
            
            return .emptyCell
        }
    
        return cell
    }
}
