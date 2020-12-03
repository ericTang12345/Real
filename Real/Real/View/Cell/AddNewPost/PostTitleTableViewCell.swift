//
//  PostTitleTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/1.
//

import UIKit

class PostTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var postTypeButton: UIButton!
    
    @IBOutlet weak var authorImageView: UIImageView!
    
    @IBAction func switchType(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        print(sender.isSelected)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension PostTitleTableViewCell: AddNewPostAuthorDelegate {
    
    func getAuthorName() -> String {
        
        return authorNameLabel.text ?? .empty
    }
    
    func getPostType() -> String {
        
        return postTypeButton.currentTitle ?? .empty
    }
    
    func getAuthorImage() -> String {
        
        return ""
    }
    
}
