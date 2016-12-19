//
//  MyPinnedDetailsCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 13/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MyPinnedDetailsCollectionViewCell: BaseCollectionViewCell {

	@IBOutlet weak var imageMyPinnedDetails: UIImageView!
	@IBOutlet weak var imageProfile: UIImageView!
	@IBOutlet weak var labelStyle: UILabel!
	@IBOutlet weak var labelRoom: UILabel!
	@IBOutlet weak var buttonLikes: UIButton!
	@IBOutlet weak var buttonViews: UIButton!

	override var datasource: AnyObject? {
		didSet {

			let ideaListObj = datasource as! IdeaListing
			buttonLikes.setTitle("\(ideaListObj.likeCount! as Int)", forState: .Normal)
			buttonViews.setTitle("\(ideaListObj.viewCount! as Int)", forState: .Normal)
			labelStyle.text = "Style: " + ideaListObj.styleValue!
			labelRoom.text = "Room: " + ideaListObj.roomValue!
			imageMyPinnedDetails.setImage(withURL: NSURL(string: ideaListObj.ideaImageThumb!)!, placeHolderImageNamed: "PlaceholderRectangle", andImageTransition: .CrossDissolve(0.4))
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		imageProfile.layoutIfNeeded()
		imageProfile.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
		imageProfile.layer.borderColor = UIColor.whiteColor().CGColor
		imageProfile.layer.cornerRadius = imageProfile.frame.size.height / 2
		imageProfile.layer.masksToBounds = true
	}
}
