//
//  UINib+Extension.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/13.
//

import UIKit

extension UINib {
    
    class func initialize(nibName: String) -> UINib {
        return self.init(nibName: nibName, bundle: nil)
    }
}
