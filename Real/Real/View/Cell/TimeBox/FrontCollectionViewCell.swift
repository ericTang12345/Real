//
//  FrontCollectionViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/7.
//

import FSPagerView

class FrontCollectionViewCell: FSPagerViewCell {

    @IBOutlet weak var authorImageView: UIImageView!
    
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var createdTimeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var commentCountLabel: UILabel!
    
    @IBOutlet weak var emptyView: UIView!
    
    let firebase = FirebaseManager.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(data: Post) {
        
        emptyView.setupBorder(width: 0.8, color: .lightGray)
        
        self.authorImageView.loadImage(urlString: data.authorImage)
        
        self.authorNameLabel.text = data.authorName
        
        self.contentLabel.text = data.content
        
        self.createdTimeLabel.text = data.createdTime.timeStampToStringDetail()
        
        likeCountLabel.text = String(data.likeCount.count)
        
        getCommentCount(postId: data.id)
    }

    func getCommentCount(postId: String) {
        
        // Comment count
        
        let filter = Filter(key: "postId", value: postId)
        
        firebase.read(collectionName: .comment, dataType: Comment.self, filter: filter) { [weak self] result in
            
            switch result {
            
            case .success(let comments):
                
                guard let strongSelf = self else { return }
                
                strongSelf.commentCountLabel.text = String(comments.count)
            
            case .failure(let error):
                
                print(error.localizedDescription)
            }
        }
    }
}
