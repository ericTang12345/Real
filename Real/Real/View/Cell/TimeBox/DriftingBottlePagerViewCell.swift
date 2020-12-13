//
//  DriftingBottlePagerViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/13.
//

import FSPagerView

class DriftingBottlePagerViewCell: FSPagerViewCell {

    @IBOutlet weak var createdTimeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(data: DriftingBottle) {
        
        self.setupBorder(width: 0.8, color: .lightGray)
        
        createdTimeLabel.text = data.createdTime.timeStampToStringDetail()
        
        contentLabel.text = data.content
    }
}
