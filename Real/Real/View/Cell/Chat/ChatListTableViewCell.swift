//
//  ChatListTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/20.
//

import UIKit

class ChatListTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var badgeLabel: LabelPadding!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    @IBOutlet weak var lastMessageTimeLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    var chatRoom: ChatRoom?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        
        badgeLabel.setup(cornerRadius: 10.5)
    }
    
    func setup(data: ChatRoom) {
        
        guard let user = userManager.userData else { return }
    
        self.chatRoom = data
    
        readMessage()
        
        nameLabel.text = data.provider == user.id ? data.receiverName : data.providerName
        
        let imageUrl = data.provider == user.id ? data.receiverImage : data.providerImage
        
        userImage.loadImage(urlString: imageUrl)
        
        lastMessageLabel.text = data.lastMessage
        
        lastMessageTimeLabel.text = data.lastMessageTime.dateValue() == FIRTimestamp().dateValue() ? .empty : data.lastMessageTime.compareCurrentTime()
    }
    
    func readMessage() {
        
        guard let chatRoom = chatRoom, let user = userManager.userData else { return }
        
        let collection = firebase.getCollection(name: .chatRoom).document(chatRoom.id).collection("messages")
        
        firebase.read(collection: collection, dataType: Message.self) { (result) in
            
            switch result {
            
            case .success(let data):
                
                var notReadCount = 0
                
                for item in data where item.sender != user.id && item.isRead == false {
                    
                    notReadCount += 1
                }
                
                self.badgeLabel.isHidden = notReadCount == 0 
                
                self.badgeLabel.text = String(notReadCount)
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
}
