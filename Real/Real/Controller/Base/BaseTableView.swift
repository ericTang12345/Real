//
//  BaseTableView.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/30.
//

import UIKit

class BaseTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        print("init tableView ")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
