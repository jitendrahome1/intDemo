//
//  MeetAnExpertTableViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 29/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MeetAnExpertTableViewCell: BaseTableViewCell {

	@IBOutlet weak var viewMeetAnExpert: UIView!
	@IBOutlet weak var imageMeetAnExpert: UIImageView!
	@IBOutlet weak var labelName: UILabel!
	@IBOutlet weak var labelExperience: UILabel!
	@IBOutlet weak var labelDesignation: UILabel!
	@IBOutlet weak var buttonLike: UIButton!
	@IBOutlet weak var buttonCall: UIButton!
	@IBOutlet weak var buttonFollow: UIButton!
	@IBOutlet weak var labelDistance: UILabel!
	@IBOutlet weak var labelPlace: UILabel!
	var strExperience: String = ""
	var expMutableString: NSMutableAttributedString!
	var desigMutableString: NSMutableAttributedString!

	override var datasource: AnyObject? {
		didSet {
			let objInfluencer = datasource as! Influencer

			labelName.text = objInfluencer.influencerUserName
			buttonLike.setTitle("\(objInfluencer.influencerLikeCount! as Int)", forState: .Normal)
			if let profileImage = objInfluencer.influencerCoverProfle {
				imageMeetAnExpert.setImage(withURL: NSURL(string: profileImage)!, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .CrossDissolve(0.4))
			}
			else {
				imageMeetAnExpert.image = UIImage(named: "DefultProfileImage")
			}

			if let influncerType = objInfluencer.influencerType {
				desigMutableString = NSMutableAttributedString(string: "Profession: \(influncerType)", attributes: [NSFontAttributeName: UIFont(name: "Roboto", size: IS_IPAD() ? 18.0 : 13.0)!])
			}

			// desigMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColorRGB(160, g: 189, b: 65)!, range: NSMakeRange(12, 10))
			labelDesignation.attributedText = desigMutableString
			strExperience = objInfluencer.influencerTotalExperiences!
//			if objInfluencer.influencerTotalExperiences! == "0.00" {
//				strExperience = "0"
//
//			} else {
//
//
//			}
			expMutableString = NSMutableAttributedString(string: "Experience: \(strExperience ) yrs", attributes: [NSFontAttributeName: UIFont(name: "Roboto", size: IS_IPAD() ? 18.0 : 13.0)!])
			expMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColorRGB(160, g: 189, b: 65)!, range: NSMakeRange(12, 4))
			labelExperience.attributedText = expMutableString
			// Distablce
			if let _ = objInfluencer.latitude {

				Helper.sharedClient.distanceBetweenTwoLocations((String(objInfluencer.latitude!)).toDouble(), sourceLongitude: (String(objInfluencer.longitude!)).toDouble()) { (result) in
					self.labelDistance.text = String(result) + "KM"
				}

			}
			labelPlace.text = objInfluencer.influencerAddress

		}
	}

	override func layoutSubviews() {

		imageMeetAnExpert.layer.cornerRadius = IS_IPAD() ? imageMeetAnExpert.frame.size.width / 2: 70.0 / 2
		imageMeetAnExpert.layer.masksToBounds = true
		viewMeetAnExpert.layer.cornerRadius = IS_IPAD() ? 15.0 : 8.0
		viewMeetAnExpert.layer.masksToBounds = true

	}
}

