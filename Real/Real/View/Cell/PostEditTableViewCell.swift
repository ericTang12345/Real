//
//  PostEditTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/23.
//

import UIKit

class PostEditTableViewCell: UITableViewCell {

    @IBOutlet weak var contentTextView: UITextView! {
        
        didSet {
            
            contentTextView.text = nil
            
            contentTextView.delegate = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var tableView: UITableView?
    
    func setup(text: String, tableView: UITableView) {
        
        self.tableView = tableView
        
        contentTextView.text = text
    }
}

extension PostEditTableViewCell: textViewContentDelegate {
    
    func getContent() -> String {
        
        return contentTextView.text
    }
}

extension PostEditTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let size = textView.bounds.size

        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))

        if size.height != newSize.height {

            UIView.setAnimationsEnabled(false)

            tableView?.beginUpdates()

            tableView?.endUpdates()

            UIView.setAnimationsEnabled(true)

            if let thisIndexPath = tableView?.indexPath(for: self) {

                tableView?.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}
