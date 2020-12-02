//
//  PostDetailsViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/29.
//

import UIKit

class PostDetailsViewController: BaseViewController {
    
    @IBOutlet var keyboardToolView: UIView!
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableViewSetup()
        }
    }
    
    @IBOutlet weak var replyTextField: UITextField!
    
    override var isHideTabBar: Bool { return true }
    
    override var isHideKeyboardAutoToolbar: Bool { return true }
    
    override var isHideKeyboardToolbarPlaceholder: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PostDetailsViewController: UITableViewDelegate {
    
}

extension PostDetailsViewController: UITableViewDataSource {
    
    func tableViewSetup() {
        
        tableView.registerCellWithNib(
            nibName: PostTableViewCell.nibName,
            identifier: .cell(identifier: .post)
        )
        
        tableView.registerCellWithNib(
            nibName: CommentTableViewCell.nibName,
            identifier: .cell(identifier: .comment)
        )
        
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        
        case 0:
            
            guard let cell = tableView.reuseCell(.post, indexPath) as? PostTableViewCell else {
                
                return .emptyCell
            }
            
            cell.contentLabel.numberOfLines = 0
            
            cell.moreButton.isHidden = true
            
            return cell
        
        case 1:
            
            guard let cell = tableView.reuseCell(.comment, indexPath) as? CommentTableViewCell else {
                
                return .emptyCell
            }
            
            return cell
        
        default:
            
            return .emptyCell
        }
    }
}
