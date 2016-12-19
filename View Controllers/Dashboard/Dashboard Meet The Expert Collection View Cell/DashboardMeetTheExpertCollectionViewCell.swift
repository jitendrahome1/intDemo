//
//  DashboardMeetTheExpertCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class DashboardMeetTheExpertCollectionViewCell: BaseCollectionViewCell {

	@IBOutlet weak var collectionViewMeetTheExpert: UICollectionView?
	@IBOutlet weak var lblMeetTheExpert: UILabel!
	@IBOutlet weak var viewMeethTheExpert: UIView!

	var dataSource: [AnyObject]? {
		didSet {
			viewMeethTheExpert.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
			viewMeethTheExpert.layer.cornerRadius = IS_IPAD() ? 15.0 : 8.0
			viewMeethTheExpert.layer.borderColor = UIColor(red: 224.0 / 255.0, green: 226.0 / 255.0, blue: 227.0 / 255.0, alpha: 1.0).CGColor
			viewMeethTheExpert.layer.masksToBounds = true
			setupCollectionView()
		}
	}
}

extension DashboardMeetTheExpertCollectionViewCell {

	func setupCollectionView() {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 0, left: IS_IPAD() ? 20 : 0, bottom: 0, right: IS_IPAD() ? 20 : 0)
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = IS_IPAD() ? 70 : 0 // iPhone 15
		layout.scrollDirection = .Horizontal
		collectionViewMeetTheExpert!.collectionViewLayout = layout
	}

	// MARK: UICollectionViewDataSource methods
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 3
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(MeetTheExpertCollectionViewCell), forIndexPath: indexPath) as! MeetTheExpertCollectionViewCell
		cell.datasource = self.dataSource![indexPath.row]
		return cell
	}

	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

		let meetAnExpertVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(MeetAnExpertViewController)) as! MeetAnExpertViewController
        switch indexPath.item {
        case 0:
            meetAnExpertVC.solutionType = "Carpenters"
        case 1:
            meetAnExpertVC.solutionType = "Interior%Decorators"
        case 2:
            meetAnExpertVC.solutionType = "Architect"
        default:
            debugPrint("No Code")
        }
		NavigationHelper.helper.contentNavController!.pushViewController(meetAnExpertVC, animated: true)
	}

	// MARK: UICollectionViewDelegateFlowLayout methods
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSizeMake(IS_IPAD() ? 190 : (CGRectGetWidth(self.frame) - 16) / 3, IS_IPAD() ? 210 : CGRectGetHeight(self.frame) - 65) // 100,115
        
        
        
	}
}