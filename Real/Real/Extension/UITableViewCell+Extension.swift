//
//  UITableViewCell+Extension.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/26.
//

import UIKit
import Foundation

protocol ReuseableView: class {
    
    static var defaultReuseIdentifier: String { get }
}

extension ReuseableView where Self: UIView {
    
    static var defaultReuseIdentifier: String {
        
        return String(describing: self)
    }
}

enum CellId: String {
    
    case post = "PostCell"
    
    case comment = "CommentCell"
    
    case topic = "TopicCell"
    
    case postTitle = "PostTitleCell"
    
    case postContent = "PostContentCell"
    
    case notificationCell = "NotificationCell"
    
    case vote = "VoteCell"
    
    case userMessage = "UserMessageCell"
    
    case receiverMessage = "ReceiverMessageCell"
    
    case driftingBottle = "DriftingBottleCell"
    
    case chatList = "ChatListCell"
}

extension UITableViewCell: ReuseableView {

    static let emptyCell = UITableViewCell()
}

extension String {
    
    static func cell(identifier: CellId) -> String {
        
        return identifier.rawValue
    }
}
