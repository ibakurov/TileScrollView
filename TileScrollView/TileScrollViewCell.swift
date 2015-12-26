//
//  TileScrollViewCell.swift
//  TileScrollView
//
//  Created by Illya Bakurov on 12/21/15.
//  Copyright © 2015 IB. All rights reserved.
//

import UIKit

class TileScrollViewCell: UIView {
    
    var indexPath: Int = 0
    
    init(frame: CGRect, indexPath: Int) {
        self.indexPath = indexPath
        super.init(frame: frame)
        self.layer.cornerRadius = frame.height/2 //To make views circular
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}