//
//  String+Extension.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/26.
//

import Foundation

enum CellIdenifiter: String {
    
    case post = "PostCell"
    
}

extension String {

    static let empty = ""
    
    static func idenifiter(_ cellType: CellIdenifiter) -> String {
        
        return cellType.rawValue
    }
}
