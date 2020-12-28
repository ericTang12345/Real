//
//  LetterTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/19.
//

import UIKit

class LetterTableViewCell: UITableViewCell {

    @IBOutlet weak var placeholderLabel: UILabel! {
        
        didSet {
            
            placeholderLabel.text = "正因為不知道誰會收到，想講什麼就說什麼吧..."
        }
    }
    
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
    
    func setup(data: DriftingBottle?, tableView: UITableView, status: LetterStatus) {
        
        self.tableView = tableView
        
        switch status {
        
        case .add:
            
            contentTextView.isEditable = true
            
            placeholderLabel.isHidden = false
            
        case .look:
            
            contentTextView.text = data!.content
            
            placeholderLabel.isHidden = true
            
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
