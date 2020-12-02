//
//  PostTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/26.
//

import UIKit

protocol PostTableViewCellDelegate: AnyObject {
    
    func reloadView(cell: PostTableViewCell)
}

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moreButton: UIButton! {
        
        didSet {
            
            moreButton.addTarget(self, action: #selector(moreContent), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var likeButton: UIButton! {
        
        didSet {
            
            likeButton.addTarget(self, action: #selector(like), for: .touchUpInside)
        }
    }

    @IBOutlet weak var bookmarkButton: UIButton! {
        
        didSet {
            
            bookmarkButton.addTarget(self, action: #selector(bookmark), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var voteView: VoteView! {
        
        didSet {
            
            voteView.dataSource = self
        }
    }
    
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var headPhotoImageView: UIImageView!
    
    @IBOutlet weak var randomTitleLabel: UILabel!
    
    @IBOutlet weak var createdTimeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    weak var delegate: PostTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(data: Post) {
        
        headPhotoImageView.loadImage(urlString: "https://firebasestorage.googleapis.com/v0/b/real-630a6.appspot.com/o/Eric_Test%2F1023123123?alt=media&token=995a35aa-b718-4557-9796-2ab77e1d42b0"
)
        
        randomTitleLabel.text = data.authorCurrentName
        
        createdTimeLabel.text = data.createdTime.compareCurrentTime()
        
        contentLabel.text = data.content
        
        if contentLabel.numberOfLines == 0 {
            
            moreButton.isHidden = true
            
        } else {
            
            moreButton.isHidden = contentLabel.textCount <= 4
        }
    }
    
    @objc func like() {
        
        self.likeButton.isSelected = !self.likeButton.isSelected
    }
    
    @objc func bookmark() {
        
        self.bookmarkButton.isSelected = !self.bookmarkButton.isSelected
    }
        
    @objc func moreContent() {
        
        contentLabel.numberOfLines = 0
        
        moreButton.isHidden = true
        
        delegate?.reloadView(cell: self)
    }
}

extension PostTableViewCell: VoteViewDataSource {
    
    func numberOfVoteItem(view: VoteView) -> Int {
        
        return 5
    }
    
    func titleForVoteItem(view: VoteView, index: Int) -> String {
        
        return "test no.\(index)"
    }
}
