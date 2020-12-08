//
//  PostContentTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/1.
//

import UIKit

class PostContentTableViewCell: UITableViewCell {

    @IBOutlet weak var contentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setup(_ tableView: UITableView) {
        
//        NSLayoutConstraint.activate([
//            contentTextView.heightAnchor.constraint(equalToConstant: tableView.frame.size.height)
//        ])
    }
}

extension PostContentTableViewCell: AddNewPostContentDelegate {
    
    func getContent() -> String {
        
        return contentTextView.text
    }
}
