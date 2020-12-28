//
//  PostContentTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/1.
//

import UIKit

class PostContentTableViewCell: UITableViewCell {

    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var contentTextView: UITextView! {
        
        didSet {
            
            contentTextView.delegate = self
        }
    }
    
    var tableView: UITableView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension PostContentTableViewCell: AddNewPostContentDelegate {
    
    func getContent() -> String {
        
        return contentTextView.text
    }
}

extension PostContentTableViewCell: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (textView.text.count + text.count - range.length) == 0 {
            
            placeholderLabel.isHidden = false
            
        } else {
            
            placeholderLabel.isHidden = true
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.text.count == 0 {
            
            placeholderLabel.isHidden = true
            
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.count == 0 {
            
            placeholderLabel.isHidden = false
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
    }
}
