//
//  RateTableViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 01/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class RateTableViewCell: BaseTableViewCell {

	@IBOutlet weak var viewRate: FloatRatingView!
	@IBOutlet weak var labelDesc: UILabel!
	@IBOutlet weak var labelDate: UILabel!
	@IBOutlet weak var labelName: UILabel!
	@IBOutlet weak var labelExperience: UILabel!
    @IBOutlet weak var labelProfesion: UILabel!
	@IBOutlet weak var viewBGProfile: UIView!
	@IBOutlet weak var labelCommentBy: UILabel!
	@IBOutlet weak var buttonRate: UIButton!
	@IBOutlet weak var buttonCall: UIButton!
	@IBOutlet weak var buttonFollow: UIButton!
	@IBOutlet weak var imgProfile: UIImageView!
	@IBOutlet weak var labelPlace: UILabel!
	@IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelService: UILabel!
    
    @IBOutlet weak var labelRateTitle: UILabel!
    var expMutableString: NSMutableAttributedString!
    var desigMutableString: NSMutableAttributedString!

	override var datasource: AnyObject? {
		didSet {
            let objRatings = self.datasource as! Ratings
			//if labelDesc != nil && labelDate != nil && labelCommentBy != nil && labelExperience != nil {
			
				labelDesc.text = objRatings.comment
				let date = NSDate.dateFromTimeInterval(Double(objRatings.createdAt!)).getFormattedStringWithFormat()
				labelDate.text = date
				labelCommentBy.text = objRatings.name!
                labelRateTitle.text = objRatings.title!
				viewRate.rating = Float(objRatings.rating!)
                labelService.text = objRatings.serviceTaken!
				viewRate.editable = false
                
			//}
		}
	}

	var dataSource: JSON? {
		didSet {

			if imgProfile != nil {
				debugPrint(self.dataSource)
                imgProfile.layoutIfNeeded()
				imgProfile.layer.cornerRadius = imgProfile.frame.height / 2
				imgProfile.contentMode = UIViewContentMode.ScaleAspectFill;
				imgProfile.layer.masksToBounds = true

				viewBGProfile.layer.borderWidth = 0.9;
				viewBGProfile.layer.borderColor = UIColorRGB(208.0, g: 225.0, b: 206.0)?.CGColor

				if dataSource != nil {
					labelPlace.text = self.dataSource!["address"].stringValue
					labelDistance.text = "0 KM"
					labelName.text = self.dataSource!["name"].stringValue
                    
                    desigMutableString = NSMutableAttributedString(string: "Profession: Architecht", attributes: [NSFontAttributeName:UIFont(name: "Roboto", size: IS_IPAD() ? 18.0 : 12.0)!])
                    desigMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColorRGB(160, g: 189, b: 65)!, range: NSMakeRange(12, 10))
                    labelProfesion.attributedText = desigMutableString
    
                    expMutableString = NSMutableAttributedString(string: "Experience: \(self.dataSource!["experience"].stringValue)", attributes: [NSFontAttributeName:UIFont(name: "Roboto", size: IS_IPAD() ? 18.0 : 13.0)!])
                    expMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColorRGB(160, g: 189, b: 65)!, range: NSMakeRange(12, self.dataSource!["experience"].stringValue.characters.count))
                    labelExperience.attributedText = expMutableString
				}
			}
		}
	}
}

