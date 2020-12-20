//
//  ChatListTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/20.
//

import UIKit

class ChatListTableViewCell: BaseTableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    @IBOutlet weak var lastMessageTimeLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(data: ChatRoom) {
        
        let user = userManager.userData!
    
        nameLabel.text = data.provider == user.id ? data.receiverName : data.providerName
        
        let imageUrl = data.provider == user.id ? data.receiverImage : data.providerImage
        
        userImage.loadImage(urlString: imageUrl)
        
        lastMessageLabel.text = data.lastMessage
        
        lastMessageTimeLabel.text = data.lastMessageTime.dateValue() == FIRTimestamp().dateValue() ? .empty : data.lastMessageTime.compareCurrentTime()
    }
    
    func readMessage() {
        
    }
}
