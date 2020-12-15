//
//  BaseTableView.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/15.
//

import UIKit

class BaseTableView: UITableView {

    enum CellType {
        
        case main(PostMainTableViewCell.Type)
        
        case image(PostImageTableViewCellNib.Type)
        
//        case vote()
        
        case interaction(InteractionTableViewCell.Type)
        
    }
    
    func registerNib() {
        
        self.registerCellWithNib(cell: PostMainTableViewCell.self)
        
        self.registerCellWithNib(cell: InteractionTableViewCell.self)
        
        self.registerCellWithNib(cell: PostImageTableViewCell.self)
        
        self.registerCellWithNib(cell: PostImageTableViewCellNib.self)
    }
    
    func sortByCell(_ post: Post) -> [CellType] {
        
        var cellType: [CellType] = [.main(PostMainTableViewCell.self)]
        
//        if !post.tags.isEmpty {
//
//            cellType.append(.tag)
//        }
        
        if !post.images.isEmpty {
            
            cellType.append(.image(PostImageTableViewCellNib.self))
        }
        
//        if !post.vote.isEmpty {
//
//            cellType.append(.vote)
//        }
        
        cellType.append(.interaction(InteractionTableViewCell.self))
        
        return cellType
    }
}
