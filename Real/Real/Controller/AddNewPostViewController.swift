//
//  AddNewPostViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/1.
//

import UIKit

class AddNewPostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backToRoot(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddNewPostViewController: UITableViewDelegate {
    
}

extension AddNewPostViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        
        case 0:
            
            guard let cell = tableView.reuseCell(.postTitle, indexPath) as? PostTitleTableViewCell else {
                
                return .emptyCell
            }
            
            return cell
            
        case 1:
            
            guard let cell = tableView.reuseCell(.postContent, indexPath) as? PostContentTableViewCell else {
                
                return .emptyCell
            }
            
            cell.setup(tableView)
            
            return cell
            
        default:
            
            return .emptyCell
        }
    }
}
