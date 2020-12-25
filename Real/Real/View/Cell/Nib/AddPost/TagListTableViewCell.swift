//
//  TagListTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/23.
//

import UIKit

class TagListTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var tagList: TagListView!
    
    var tags: [Tag] = [] {
        
        didSet {
            
            tagList.dataSource = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(strs: [String]) {
        
        TagManager().stringToTag(strList: strs) { (tags) in
            
            self.tags = tags
        }
    }
}

extension TagListTableViewCell: TagListViewDataSource {
    
    func numberOfTag(view: TagListView) -> Int {
        
        return tags.count
    }
    
    func dataForTag(view: TagListView, index: Int) -> Tag {
        
        return tags[index]
    }
}
