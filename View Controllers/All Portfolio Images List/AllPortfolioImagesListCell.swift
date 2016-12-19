//
//  AllPortfolioImagesListCell.swift
//  Greenply
//
//  Created by Jitendra on 25/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class AllPortfolioImagesListCell: BaseCollectionViewCell {

	@IBOutlet weak var imagePortfolioList: UIImageView!
 

	override var datasource: AnyObject? {
		didSet {

			let objPortfolio = datasource as! ProfileImage

			imagePortfolioList.setImage(withURL: NSURL(string: objPortfolio.projectImageThumb!)!, placeHolderImageNamed: "PlaceholderSquare", andImageTransition: .CrossDissolve(0.4))
        }
	}
   
}
