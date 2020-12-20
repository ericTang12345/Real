//
//  LetterTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/19.
//

import UIKit

class LetterTableViewCell: UITableViewCell {

    @IBOutlet weak var contentTextView: UITextView! {
        
        didSet {
            
            contentTextView.delegate = self
            
            contentTextView.text = textViewPlaceholder
            
            contentTextView.textColor = .lightGray
        }
    }
    
    let textViewPlaceholder = "分享今天所遇到的人、事、物吧！"
    
    var tableView: UITableView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(data: DriftingBottle?, tableView: UITableView, status: LetterStatus) {
        
        self.tableView = tableView
        
        switch status {
        
        case .add:
            
            contentTextView.isEditable = true
            
        case .look:
            
            contentTextView.text = data!.content
            
            contentTextView.isEditable = false
        }
    }
}

extension LetterTableViewCell: LetterViewControllerDelegate {
    
    func getContent() -> String {
        
        return contentTextView.text
    }
}

extension LetterTableViewCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.textColor == UIColor.lightGray {

            textView.text = nil

            textView.textColor = .black
        }
    }

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
        
        if textView.text.isEmpty {
            
            textView.textColor = UIColor.lightGray
            
            textView.text = textViewPlaceholder
        }
    }
}
