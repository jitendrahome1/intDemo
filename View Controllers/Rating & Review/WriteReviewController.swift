//
//  WriteReviewController.swift
//  Greenply
//
//  Created by Shatadru Datta on 01/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class WriteReviewController: BaseTableViewController, FloatRatingViewDelegate {

	@IBOutlet weak var buttonServiceTaken: UIButton!
	@IBOutlet weak var buttonServiceNotTaken: UIButton!
	@IBOutlet weak var viewRating: FloatRatingView!
	let checkedImage = UIImage(named: "WriteReviewRadioBtnSelect")
	let unCheckedImage = UIImage(named: "WriteReviewRadioBtnDeselect")
	@IBOutlet weak var viewBGProfile: UIView!
	@IBOutlet weak var labelName: UILabel!
	@IBOutlet weak var labelExperience: UILabel!
	@IBOutlet weak var labelProfession: UILabel!
	@IBOutlet weak var labelInfluencerType: UILabel!
	@IBOutlet weak var imageProfile: UIImageView!
	@IBOutlet weak var viewRate: UIView!
	var objInfluencerList: Influencer!
	@IBOutlet weak var textRateTitle: UITextField!
	@IBOutlet weak var textWriteReview: JAPlaceholderTextView!
	@IBOutlet weak var labelReviewDesc: UILabel!

	@IBOutlet weak var buttonFlowUnFlow: UIButton!
	@IBOutlet weak var labelDistance: UILabel!

	@IBOutlet weak var labelCity: UILabel!
	var rateValue: Float!
	var expMutableString: NSMutableAttributedString!
	var desigMutableString: NSMutableAttributedString!
	var serviceTaken: Int!
	var influncerID: Int?

	@IBOutlet weak var buttonLikeCount: UIButton!
	override func viewDidLoad() {

		super.viewDidLoad()
		viewRating.delegate = self
		self.getInflunceDetails()
		self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
		// self.backgroundImageView.image = UIImage(named: "")
		self.backgroundImageView.image = UIImage(named: "BackgroundImage")

		viewBGProfile.layer.borderWidth = 0.9;
		viewBGProfile.layer.borderColor = UIColorRGB(208.0, g: 225.0, b: 206.0)?.CGColor

        if let influncerType = self.objInfluencerList.influencerType{
        	desigMutableString = NSMutableAttributedString(string: "Profession: \(influncerType)", attributes: [NSFontAttributeName: UIFont(name: "Roboto", size: IS_IPAD() ? 18.0 : 13.0)!])
        }
	
		//desigMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColorRGB(160, g: 189, b: 65)!, range: NSMakeRange(12, 10))
		labelProfession.attributedText = desigMutableString

		expMutableString = NSMutableAttributedString(string: "Experience: \(objInfluencerList.influencerTotalExperiences!)", attributes: [NSFontAttributeName: UIFont(name: "Roboto", size: IS_IPAD() ? 18.0 : 13.0)!])
		//expMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColorRGB(160, g: 189, b: 65)!, range: NSMakeRange(12, 4))
		labelExperience.attributedText = expMutableString

	}

	func getInflunceDetails() {

		if let _ = self.objInfluencerList {
            self.labelName.text = self.objInfluencerList.influencerUserName!
			influncerID = self.objInfluencerList.influencerID
			self.buttonLikeCount.setTitle("\(self.objInfluencerList.influencerLikeCount!)", forState: .Normal)
			if self.objInfluencerList.isFollowStatus == true {

				self.buttonFlowUnFlow.setTitle("Unfollow", forState: .Normal)
			} else {
				self.buttonFlowUnFlow.setTitle("Follow", forState: .Normal)
			}
			labelCity.text = self.objInfluencerList.influencerAddress!
			Helper.sharedClient.distanceBetweenTwoLocations((String(self.objInfluencerList.latitude!)).toDouble(), sourceLongitude: (String(self.objInfluencerList.longitude!)).toDouble()) { (result) in
				self.labelDistance.text = String(result) + "KM"
			}
            if let profilePic = self.objInfluencerList.influencerCoverProfle {
                self.imageProfile.setImage(withURL: NSURL(string: profilePic)!, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .CrossDissolve(0.4))
            } else {
                self.imageProfile.image = UIImage(named: "DefultProfileImage")
            }
		}
        
	}
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		imageProfile.layoutIfNeeded()
		imageProfile.layer.cornerRadius = imageProfile.frame.height / 2
		imageProfile.contentMode = UIViewContentMode.ScaleAspectFill
		imageProfile.layer.masksToBounds = true
	}

	override func viewWillAppear(animated: Bool) {

		super.viewWillAppear(animated)
		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: false, isHideMenuButton: false)
		NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = "Rate & Review"
		buttonServiceTaken.setImage(checkedImage, forState: .Normal)
		serviceTaken = 0
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func actionServiceTaken(sender: AnyObject) {
		self.unCheckAll()
		buttonServiceTaken.setImage(checkedImage, forState: .Normal)
		serviceTaken = 0

	}

	@IBAction func actionServiceNotTaken(sender: AnyObject) {
		self.unCheckAll()
		buttonServiceNotTaken.setImage(checkedImage, forState: .Normal)
		serviceTaken = 1
	}

	func unCheckAll() {
		buttonServiceTaken.setImage(unCheckedImage, forState: .Normal)
		buttonServiceNotTaken.setImage(unCheckedImage, forState: .Normal)
	}
	// MARK:- Action

	@IBAction func actionRateSubmit(sender: AnyObject) {
		debugPrint("RateVlue==>\(rateValue)")
		// call API
		self.view.endEditing(true)
		if let pRateValue = rateValue {
			if textWriteReview.text == "" {
				Toast.show(withMessage: SELECT_COMMENT)
			} else {
				rateValue = pRateValue
				self.updateRatingView()
			}
		}
		else {
			Toast.show(withMessage: SELECT_RATE)

		}

	}

}

extension WriteReviewController {

	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		switch indexPath.row {
		case 0:
			return IS_IPAD() ? 150 : 130
		case 1:
			return IS_IPAD() ? 120 : 96
		case 2, 3:
			return IS_IPAD() ? 60 : 48
		case 4:
			return IS_IPAD() ? 265 : 215

		case 5:
			return IS_IPAD() ? 140 : 100
		default:
			return 0
		}
	}
}

// FloatRatingViewDelegate Delegate
extension WriteReviewController {
	func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float)
	{
		rateValue = rating

	}
	func floatRatingView(ratingView: FloatRatingView, isUpdating rating: Float)
	{

		rateValue = rating
	}
}

//MARK: Api Calling
extension WriteReviewController {
	func updateRatingView() {
		// MARK:- For This Time we are passed hard coded value in userID, letter we ill change. when we get userID.
		APIHandler.handler.writeReview(influncerID!, rated_by: Globals.sharedClient.userID!, rating: rateValue, description: textWriteReview.text, title: self.textRateTitle.text, service_taken: serviceTaken, success: { (response) in
			debugPrint("Response Reting:==>\(response)")
			self.navigationController?.popViewControllerAnimated(true)
		}) { (error) in
		}
	}
}

