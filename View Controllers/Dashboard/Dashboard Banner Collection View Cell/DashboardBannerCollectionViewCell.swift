//
//  DashboardBannerCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class DashboardBannerCollectionViewCell: BaseCollectionViewCell {

	@IBOutlet weak var collectionViewBanner: UICollectionView?
	@IBOutlet weak var imageView: UIImageView?

	override var datasource: AnyObject? {
		didSet {
			if datasource != nil {
				imageView?.setImage(withURL: NSURL(string: (datasource as? String)!)!, placeHolderImageNamed: "PlaceholderRectangle", andImageTransition: .CrossDissolve(0.4))
			}
		}
	}
}

extension DashboardBannerCollectionViewCell {

	// MARK: UICollectionViewDataSource methods
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 1
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(BannerCollectionViewCell), forIndexPath: indexPath) as! BannerCollectionViewCell
		return cell
	}

	// MARK: UICollectionViewDelegateFlowLayout methods
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSizeMake(SCREEN_WIDTH, CGRectGetHeight(self.frame))
	}
}