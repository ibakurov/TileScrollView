//
//  TileScrollView.swift
//  TileScrollView
//
//  Created by Illya Bakurov on 12/21/15.
//  Copyright © 2015 IB. All rights reserved.
//

import UIKit

//MARK: - Data Source
protocol TileScrollViewDataSource {
    func numberOfTiles(scrollView: TileScrollView) -> Int
    func offsetBetweenTiles(scrollView: TileScrollView) -> CGFloat
    func sizeOfTile(scrollView: TileScrollView) -> CGSize
}

//MARK: - Delegate
protocol TileScrollViewDelegate {
    func tileForScrollView(scrollView: TileScrollView, indexPath:Int, direction:ScrollDirection) -> TileScrollViewCell
}

//MARK: - Direction enum
enum ScrollDirection {
    case ScrollDirectionNone
    case ScrollDirectionRight
    case ScrollDirectionLeft
    case ScrollDirectionUp
    case ScrollDirectionDown
    case ScrollDirectionRightDown
    case ScrollDirectionRightUp
    case ScrollDirectionLeftDown
    case ScrollDirectionLeftUp
}

//MARK: - Class
class TileScrollView: UIScrollView, UIScrollViewDelegate {
    
    //MARK: - Properties
    var tileDataSource: TileScrollViewDataSource?
    var tileDelegate: TileScrollViewDelegate?
    
    private var numberOfTiles: Int {
        if let number = tileDataSource?.numberOfTiles(self) {
            return number
        } else {
            return 0
        }
    }
    
    private var offsetBetweenTiles: CGFloat {
        if let offset = tileDataSource?.offsetBetweenTiles(self) {
            return offset
        } else {
            return 20
        }
    }
    
    private var sizeOfTile: CGSize {
        if let size = tileDataSource?.sizeOfTile(self) {
            return size
        } else {
            return CGSize.zero
        }
    }
    
    private var queueOfTiles: [TileScrollViewCell]
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        self.queueOfTiles = [TileScrollViewCell]()
        super.init(frame: frame)
        initializeData()
    }

    required init?(coder aDecoder: NSCoder) {
        self.queueOfTiles = [TileScrollViewCell]()
        super.init(coder: aDecoder)
        initializeData()
    }
    
    func initializeData() {
        delegate = self
    }
    
    func reloadTiles() {
        maintainTiles(self)
    }
    
    //MARK: - Scrolling Processing
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        maintainTiles(self)
    }
    
    func checkAndRemoveUnvisible() {
        //Check for all views which dissaeppeared from the scrollView and remove them
        for myView in queueOfTiles {
            if (!CGRectContainsPoint(self.bounds, CGPointMake(myView.frame.origin.x, myView.frame.origin.y + myView.frame.height)) && !CGRectContainsPoint(self.bounds, CGPointMake(myView.frame.origin.x, myView.frame.origin.y))) {
                myView.removeFromSuperview()
            }
        }
    }
    
    func maintainTiles(scrollView: TileScrollView) {
        
        //Checking and Removing all views which are not visible any more
        checkAndRemoveUnvisible()
        
        //Getting the number of views which will actually fit in the screen, so not to add those which are not visible
        let visibleFrame = self.convertRect(self.bounds, fromView: self)
        let first = Int(visibleFrame.origin.y / (sizeOfTile.height + offsetBetweenTiles))
        let last = Int((visibleFrame.origin.y + visibleFrame.height) / (sizeOfTile.height + offsetBetweenTiles))
        
        //Adds the views which will be visible on the screen and to array
        for i in (first > 0 ? first : 0) ... (last < numberOfTiles ? last : numberOfTiles - 1) {
            
            var tileToAdd: TileScrollViewCell?
            let direction = identifyDirection(scrollView.contentOffset)
            lastContentOffsetX = scrollView.contentOffset.x
            lastContentOffsetY = scrollView.contentOffset.y
            //Getting Tile from DataSource
            if let tile = tileDelegate?.tileForScrollView(self, indexPath: i, direction:direction) {
                tileToAdd = tile
            }
            
            //Adding it to the array and subview
            if let tile = tileToAdd {
                queueOfTiles.append(tile)
                self.addSubview(tile)
            }
        }
    }
    
    //MARK: - Identifying Direction of the Scrolling
    
    private var lastContentOffsetX: CGFloat = 0
    private var lastContentOffsetY: CGFloat = 0

    func identifyDirection(contentOffset: CGPoint) -> ScrollDirection {
        if (lastContentOffsetX < contentOffset.x && lastContentOffsetY < contentOffset.y) {
            return .ScrollDirectionRightDown
        } else if (lastContentOffsetX < contentOffset.x && lastContentOffsetY > contentOffset.y) {
            return .ScrollDirectionRightUp
        } else if (lastContentOffsetX > contentOffset.x && lastContentOffsetY < contentOffset.y) {
            return .ScrollDirectionLeftDown
        } else if (lastContentOffsetX > contentOffset.x && lastContentOffsetY > contentOffset.y) {
            return .ScrollDirectionLeftUp
        } else if (lastContentOffsetX < contentOffset.x) {
            return .ScrollDirectionRight
        } else if (lastContentOffsetX > contentOffset.x) {
            return .ScrollDirectionLeft
        } else if (lastContentOffsetY < contentOffset.y) {
            return .ScrollDirectionDown
        } else if (lastContentOffsetY > contentOffset.y) {
            return .ScrollDirectionUp
        }
        return .ScrollDirectionNone
    }
}