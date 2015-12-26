//
//  ViewController.swift
//  TileScrollView
//
//  Created by Illya Bakurov on 12/21/15.
//  Copyright © 2015 IB. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TileScrollViewDataSource, TileScrollViewDelegate {
    
    @IBOutlet var scrollView: TileScrollView! {
        didSet {
            scrollView.tileDataSource = self
            scrollView.tileDelegate = self
        }
    }
    
    let numberOfViews = 20
    var arrayWithViews = [TileScrollViewCell]()
    
    private struct Constants {
        static let sizeOfView = CGSizeMake(90.0, 90.0)
        static let distanceBetweenViews : CGFloat = 15.0
        static let topOffsetForFirstView : CGFloat = 20.0
        static let rightOffsetForLeftView : CGFloat = 20.0
        static let leftOffsetForRightView : CGFloat = 20.0
        static let bottomOffsetForLastView : CGFloat = 20.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting content size to fit our number of views
        scrollView?.contentSize = CGSizeMake(view.frame.width, (CGFloat(numberOfViews) * Constants.sizeOfView.height + CGFloat(numberOfViews) * Constants.distanceBetweenViews + Constants.bottomOffsetForLastView))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        scrollView?.reloadTiles()
    }
    
    //MARK: Tile Scroll View DataSource
    
    func numberOfTiles(scrollView: TileScrollView) -> Int {
        return numberOfViews
    }
    
    func offsetBetweenTiles(scrollView: TileScrollView) -> CGFloat {
        return Constants.distanceBetweenViews
    }
    
    func sizeOfTile(scrollView: TileScrollView) -> CGSize {
        return Constants.sizeOfView
    }
    
    //MARK: Tile Scroll View Delegate
    
    func tileForScrollView(scrollView: TileScrollView, indexPath: Int, direction:ScrollDirection) -> TileScrollViewCell {
        
        let visibleFrame = scrollView.convertRect(scrollView.bounds, fromView: scrollView)
        var frame: CGRect
        if (indexPath % 2 == 0) {
            //Left View
            frame = CGRectMake(visibleFrame.origin.x + visibleFrame.width/2 - Constants.distanceBetweenViews - Constants.sizeOfView.width, CGFloat(indexPath) * Constants.sizeOfView.height + CGFloat(indexPath) * Constants.distanceBetweenViews + Constants.topOffsetForFirstView, Constants.sizeOfView.width, Constants.sizeOfView.height)
        } else {
            //Right View
            frame = CGRectMake(visibleFrame.origin.x + visibleFrame.width/2 + Constants.distanceBetweenViews, CGFloat(indexPath) * Constants.sizeOfView.height + CGFloat(indexPath) * Constants.distanceBetweenViews + Constants.topOffsetForFirstView, Constants.sizeOfView.width, Constants.sizeOfView.height)
        }
        
        if indexPath < arrayWithViews.count {
            return arrayWithViews[indexPath]
        } else {
            let tile = TileScrollViewCell(frame: frame, indexPath: indexPath)
            
            //Simple code to generate random number and then choose colour for the view.
            let colourChooser = rand() % 11
            switch colourChooser {
                case 1,2: tile.backgroundColor = UIColor.greenColor()
                case 3,4: tile.backgroundColor = UIColor.redColor()
                case 5,6: tile.backgroundColor = UIColor.blackColor()
                case 7,8: tile.backgroundColor = UIColor.blueColor()
                case 9,10: tile.backgroundColor = UIColor.lightGrayColor()
                default: tile.backgroundColor = UIColor.yellowColor()
            }
            arrayWithViews.append(tile)
            return tile
        }
    }
    
}