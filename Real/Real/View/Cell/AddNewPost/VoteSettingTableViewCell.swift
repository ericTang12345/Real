//
//  VoteSettingTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/14.
//

import UIKit

class VoteSettingTableViewCell: UITableViewCell {

    @IBOutlet weak var settingLabel: UILabel!
    
    @IBOutlet weak var settingButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(_ setting: VoteSetting) {
        
        settingLabel.text =
            """
            投票時間：\(setting.voteTime) 天
            回應字數：\(setting.textCount) 字
            """
    }

}
