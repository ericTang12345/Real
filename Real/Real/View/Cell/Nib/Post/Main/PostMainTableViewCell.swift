//
//  PostMainTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/14.
//

import UIKit

protocol PostMainTableViewCellDelegate: AnyObject {
    
    func postReloadView(cell: UITableViewCell)
}

class PostMainTableViewCell: BaseTableViewCell {

    @IBOutlet weak var authorImageView: UIImageView!
    
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var createdTimeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var moreContentButton: UIButton!
    
    weak var delegate: PostMainTableViewCellDelegate?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data: Post) {
        
        authorImageView.loadImage(urlString: data.authorImage)

        authorNameLabel.text = data.authorName

        createdTimeLabel.text = data.createdTime.compareCurrentTime()

        contentLabel.text = data.content

        moreContentButton.isHidden = contentLabel.numberOfLines == 0 ? true : contentLabel.textCount <= 4
    }
    
    @IBAction func showMoreContent(_ sender: UIButton) {
        
        contentLabel.numberOfLines = 0
        
        moreContentButton.isHidden = true
        
        guard let delegate = delegate else { return }
        
        delegate.postReloadView(cell: self)
    }
}
