//
//  DashboardHomeDecorIdeasCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class DashboardHomeDecorIdeasCollectionViewCell: BaseCollectionViewCell {

	@IBOutlet weak var collectionViewHomeDecorIdeas: UICollectionView?
	@IBOutlet weak var lblHomeDecorIdeas: UILabel!
	@IBOutlet weak var btnHomeDecorViewAll: UIButton!
    @IBOutlet weak var viewHomeDecor: UIView!
    var didOpen: ((open: Bool)->())!
	 var dataSource: [AnyObject]? {
        willSet {
            setupCollectionView()
        }
        //
		didSet {
            
            viewHomeDecor.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
            viewHomeDecor.layer.cornerRadius = IS_IPAD() ? 15.0 : 8.0
            viewHomeDecor.layer.borderColor = UIColor(red: 224.0/255.0, green: 226.0/255.0, blue: 227.0/255.0, alpha: 1.0).CGColor
            viewHomeDecor.layer.masksToBounds = true
            collectionViewHomeDecorIdeas?.reloadData()
		}
	}
}

extension DashboardHomeDecorIdeasCollectionViewCell: UIScrollViewDelegate {
    
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .Horizontal
        collectionViewHomeDecorIdeas!.collectionViewLayout = layout
    }
    
    
	// MARK: UICollectionViewDataSource methods
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataSource?.count)!
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
   
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(HomeDecorIdeasCollectionViewCell), forIndexPath: indexPath) as! HomeDecorIdeasCollectionViewCell
       //cell.datasource = "Test"
		cell.datasource = dataSource![indexPath.row]
        return cell
	}
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        let ideaListVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(IdeaListingController)) as! IdeaListingController
//        NavigationHelper.helper.contentNavController?.pushViewController(ideaListVC, animated: true)
        
        // change letter
//        let ideaListVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(IdeaListingController)) as! IdeaListingController
//        
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! HomeDecorIdeasCollectionViewCell
        let IdeaDetailsVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(IdeasDetailsController)) as! IdeasDetailsController
        let objIdeaList = cell.datasource
        IdeaDetailsVC.ideaDetailsObj = objIdeaList as! IdeaListing
        NavigationHelper.helper.contentNavController?.pushViewController(IdeaDetailsVC, animated: true)
    
    }
    
	// MARK: UICollectionViewDelegateFlowLayout methods
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		//return CGSizeMake(CGRectGetHeight(self.frame) - 60, CGRectGetHeight(self.frame) - 60)
        return CGSizeMake(IS_IPAD() ? 300 : CGRectGetHeight(self.frame) - 70, IS_IPAD() ? 220 : CGRectGetHeight(self.frame) - 80)
	}
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if didOpen != nil {
            didOpen(open: false)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if didOpen != nil {
            didOpen(open: true)
        }
    }
    
    
}