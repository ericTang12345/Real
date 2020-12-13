//
//  TimeBoxViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/8.
//

import UIKit
import FSPagerView

class TimeBoxViewController: BaseViewController {

    @IBOutlet weak var pagerView: FSPagerView! {
        
        didSet {
            
            self.pagerView.register(UINib(nibName: "FrontCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
            
            pagerView.scrollDirection = .horizontal
            
            pagerView.setupShadow()
            
            pagerView.delegate = self
            
            pagerView.dataSource = self
            
            pagerView.transformer = FSPagerViewTransformer(type: .overlap)
            
            pagerView.itemSize = CGSize(
                width: pagerView.frame.width * 0.75,
                height: pagerView.frame.size.height * 0.9
            )
        }
    }
    
    override var isHideTabBar: Bool {
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension TimeBoxViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 5
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as? FrontCollectionViewCell else {
            
            print("cell is empty")
            
            return FSPagerViewCell()
        }
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
        print("selected index: \(index)")
    }
}
