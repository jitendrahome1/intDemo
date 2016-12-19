//
//  IdeasDetailsController.swift
//  Greenply
//
//  Created by Shatadru Datta on 31/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

enum eIdeaDetails {
	case eIdeaDetailsTitle
	case ePinnedDetailsTitle
}

class IdeasDetailsController: BaseTableViewController {

	var eIdeaTitleStatus: eIdeaDetails = .eIdeaDetailsTitle
	@IBOutlet weak var imgLike: UIImageView!
	@IBOutlet weak var imgPinned: UIImageView!
	@IBOutlet weak var imageBannerIdeasDetails: UIImageView!
	@IBOutlet weak var imageProfileIdeasDetails: UIImageView!
	@IBOutlet weak var labelIdeasName: UILabel!
	@IBOutlet weak var labelIdeasDescription: UILabel!
	@IBOutlet weak var labelIdeasProjType: UILabel!
	@IBOutlet weak var labelIdeasLocation: UILabel!
	@IBOutlet weak var labelDesignType: UILabel!
	@IBOutlet weak var labelRoomType: UILabel!
    var isCommentBtnShowHide: Bool = true
	var arrComments = [AnyObject]()
	var ideaDetailsObj: IdeaListing!
	var textComment: String!
	var commentDesc: String!

	@IBOutlet weak var buttonReportAbus: UIButton!
	@IBOutlet weak var imgReportAbus: UIImageView!
	@IBOutlet weak var imageBottomLayer: UIImageView!
	@IBOutlet weak var labelLikes: UILabel!
	@IBOutlet weak var labelViews: UILabel!

	@IBOutlet weak var buttonFollow: UIButton!

	@IBOutlet weak var labelCommentsDesc: UILabel!
	@IBOutlet weak var labelCommentsName: UILabel!
	@IBOutlet weak var labelCommentsDate: UILabel!
	@IBOutlet weak var buttonCommentsViews: UIButton!
	@IBOutlet weak var buttonAlert: UIButton!
	@IBOutlet weak var labelAboutProject: UILabel!

	var commentBtn: UIButton!

	@IBOutlet var viewContents: [UIView]!

	override func viewDidLoad() {
		super.viewDidLoad()
        
		// buttonFollow.addTarget(self, action: #selector(self.actionFollow(_:)), forControlEvents: .TouchUpInside)
		self.tableView.backgroundView = nil
		self.tableView.backgroundColor = UIColorRGB(233.0, g: 235.0, b: 236.0)

		for (index, view) in viewContents.enumerate() {

			view.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
			view.layer.borderColor = UIColorRGB(224.0, g: 226.0, b: 227.0)?.CGColor

			if index == 0 || index == 4 || index == 5 || index == 6 {
				view.layer.cornerRadius = IS_IPAD() ? 10.0 : 5.0
				view.layer.masksToBounds = true
			} else {
				view.layer.masksToBounds = false
			}
		}

		// imageProfileIdeasDetails.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
		// imageProfileIdeasDetails.layer.borderColor = UIColorRGB(149.0, g: 204.0, b: 68.0)?.CGColor
		imageProfileIdeasDetails.layer.cornerRadius = IS_IPAD() ? imageProfileIdeasDetails.frame.size.width / 2: 50 / 2
		imageProfileIdeasDetails.layer.masksToBounds = true

		buttonFollow.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
		buttonFollow.layer.borderColor = UIColorRGB(149.0, g: 204.0, b: 68.0)?.CGColor
		buttonFollow.layer.cornerRadius = IS_IPAD() ? 20.0 : 10.0
		buttonFollow.layer.masksToBounds = true

	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
		if eIdeaTitleStatus == .eIdeaDetailsTitle {
			NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_Idea_Details
			labelAboutProject.text = "About Idea"
		}
		else if eIdeaTitleStatus == .ePinnedDetailsTitle {
			NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_PINNED_Details
			labelAboutProject.text = "About Pinned"
		}

		NavigationHelper.helper.tabBarViewController!.hideTabBar()
        if isCommentBtnShowHide == true{
        self.setCommentButton()
        }
		
		self.getIdeaDetailsWithIdeaID(forIdeaID: ideaDetailsObj.IdeaID)
		self.loadIdeaDetails()

	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
        if isCommentBtnShowHide == true{
		commentBtn.removeFromSuperview()
        }
	}

	@IBAction func alertAction(sender: UIButton) {
		if arrComments.count > 0 {
            let objComments = self.arrComments[0] as! Comments
			if objComments.commentReportAbus == true {
				self.buttonAlert.userInteractionEnabled = false
			} else {
				self.buttonAlert.userInteractionEnabled = true
				self.reportAbusWith(forReportID: objComments.commentID!, abuseType: kReportAbusComment)
			}
		}

	}
	override func viewDidLayoutSubviews() {

		self.viewWillLayoutSubviews()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func actionIdeaImageCover(sender: UIButton) {
		let imageFullVC = otherStoryboard.instantiateViewControllerWithIdentifier(String(ImageViewController)) as! ImageViewController
		imageFullVC.objIdeaDetails = ideaDetailsObj
		NavigationHelper.helper.contentNavController?.pushViewController(imageFullVC, animated: true)
	}
	// MARK:- Action
	@IBAction func actionComments(sender: AnyObject) {
        
        if self.arrComments.count > 0 {
            self.buttonCommentsViews.userInteractionEnabled = true
            let commentsVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(AllCommentsViewController)) as! AllCommentsViewController
            commentsVC.arrAllCommentsList = arrComments
            commentsVC.ideaID = self.ideaDetailsObj.IdeaID
            NavigationHelper.helper.contentNavController?.pushViewController(commentsVC, animated: true)
        }else{
        self.buttonCommentsViews.userInteractionEnabled = false
        }
		
	}
	func loadIdeaDetails()
	{
		labelRoomType.text = ideaDetailsObj.roomValue
		labelDesignType.text = ideaDetailsObj.styleValue
		labelIdeasDescription.text = ideaDetailsObj.ideaDescription

		labelLikes.text = "\(ideaDetailsObj.likeCount! as Int)"
		labelViews.text = "\(ideaDetailsObj.viewCount! as Int)"
		labelIdeasName.text = ideaDetailsObj.ideaName
		imageBannerIdeasDetails.setImage(withURL: NSURL(string: ideaDetailsObj.ideaImageMedium!)!, placeHolderImageNamed: "PlaceholderRectangle", andImageTransition: .CrossDissolve(0.4))

	}

	@IBAction func actionFollow(sender: UIButton) {
		Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
			if isLogin == true {
				self.setFollowAndUnFollowStaus()
			}
		}
	}

	// MARK:- Share
	@IBAction func share(sender: UIButton) {
		Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
			if isLogin == true {
				// call APi
			}
		}

	}

	// MARK:- Pinned
	@IBAction func Pinned(sender: UIButton) {

		Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
			if isLogin == true {
				if let pinnedStatus = self.ideaDetailsObj.isPinnedStatus {
					self.setIdeaPinnedStatus(pinnedStatus)
				}

			}
		}

	}
// Action Report Abus

	@IBAction func actionReportAbus(sender: UIButton) {
		// call report abus api
		if self.ideaDetailsObj.isReportAbusStatus == true {
			self.buttonReportAbus.userInteractionEnabled = false
		}
		else {
			self.buttonReportAbus.userInteractionEnabled = true
			self.reportAbusWith(forReportID: self.ideaDetailsObj.IdeaID!, abuseType: kReportAbusIdea)
		}

	}
	// MARK:- Views
	@IBAction func Views(sender: UIButton) {

	}

	// MARK:- Likes
	@IBAction func likes(sender: UIButton) {
		Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
			if isLogin == true {
				if let likeStaus = self.ideaDetailsObj.isLikedStatus {
					self.setLikeDislikeStaus(likeStaus)
				}

			}
		}

	}
}

extension IdeasDetailsController {
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0:
				return IS_IPAD() ? 313.0 : 240.0
			case 1:
				return 70.0 + ideaDetailsObj.ideaDescription!.requiredHeight(forWidth: CGRectGetWidth(UIScreen.mainScreen().bounds) - 40.0, andFont: PRIMARY_FONT(IS_IPAD() ? 18.0 : 15.0)!)
			default:
				return IS_IPAD() ? 130.0 : 105.0
			}
		case 1:
			switch indexPath.row {
			case 0:
				if arrComments.count > 0 {
					let objComments = self.arrComments[0] as! Comments
					return 140.0 + objComments.commentsDetails!.requiredHeight(forWidth: CGRectGetWidth(UIScreen.mainScreen().bounds) - 40.0, andFont: PRIMARY_FONT(IS_IPAD() ? 18.0 : 15.0)!)
				}
				return 140.0
			default:
				return 0
			}
		default:
			return 0
		}
	}
}

// MARK: Call API.
extension IdeasDetailsController {
	func getIdeaDetailsWithIdeaID(forIdeaID ideaId: Int?) {
		APIHandler.handler.getIdeaDetails(ideaId, success: { (response) in
			debugPrint(response)
			debugPrint("Idea Details\(response["Idea"]["comments"])")

			self.ideaDetailsObj.isFollowStatus = Bool(response["isFollowing"])
			self.ideaDetailsObj.isLikedStatus = Bool(response["isLiked"])
			self.ideaDetailsObj.isPinnedStatus = Bool(response["isPinned"])
			self.ideaDetailsObj.IdeaUserID = response["Idea"]["user_id"].int
			self.ideaDetailsObj.isReportAbusStatus = Bool(response["abused"])
			// change like button Staus,
			self.changeLikeButtonImage(self.ideaDetailsObj.isLikedStatus!)
			self.changePinnedImage(self.ideaDetailsObj.isPinnedStatus!)
			// Follow Button
			self.changeFollowTitle(self.ideaDetailsObj.isFollowStatus!)
			self.changeReportAbusImage(self.ideaDetailsObj.isReportAbusStatus!)

			self.arrComments.removeAll()
			for value in response["Idea"]["comments"].arrayObject! {
				let objComments = Comments(withDictionary: value as! [String: AnyObject])
				self.arrComments.append(objComments)
			}

			if self.arrComments.count > 0 {
				let objComments = self.arrComments[0] as! Comments
				self.labelCommentsName.text = objComments.CommentsUserName
				self.labelCommentsDesc.text = objComments.commentsDetails?.stringByRemovingPercentEncoding
				self.labelCommentsDate.text = NSDate.dateFromTimeInterval(objComments.commentDate!).getFormattedStringWithFormat()

				self.changeReportAbusImageComment(objComments.commentReportAbus!)
//                if objComments.commentReportAbus == true{
//                self.buttonAlert.setImage(UIImage(named: kReportAbusRedImage), forState: .Normal)
//                }else{
//                self.buttonAlert.setImage(UIImage(named: kReportAbusGreenImage), forState: .Normal)
//                }
            }else{
                self.labelCommentsDesc.text = "No Comments available"
   
            }

			let imageProfileUrl = response["user"]["display_profile"].string
			if let iageProfile = imageProfileUrl {
				self.imageProfileIdeasDetails.setImage(withURL: NSURL(string: iageProfile)!, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .CrossDissolve(0.4))

			}
			else {
				self.imageProfileIdeasDetails.image = UIImage(named: "DefultProfileImage")
			}

			debugPrint("Idea Details List==> \(response["comments"][0]["comment"])")
			self.tableView.reloadData()

		}) { (error) in

		}
	}
	// MARK:- Call Follow And unFollow Api

	func setFollowAndUnFollowStaus() {
		if ideaDetailsObj.isFollowStatus == true {
			APIHandler.handler.unFollow(forUnfollowrID: self.ideaDetailsObj.IdeaUserID!, success: { (response) in
				debugPrint("Un Follow Respose ==> \(response)")
				self.changeFollowTitle(false)
				self.ideaDetailsObj.isFollowStatus = false
				}, failure: { (error) in
			})

		}
		else if ideaDetailsObj.isFollowStatus == false {
			// call follow api
			APIHandler.handler.addFollow(forFollowerID: self.ideaDetailsObj.IdeaUserID!, success: { (response) in
				self.changeFollowTitle(true)
				self.ideaDetailsObj.isFollowStatus = true
				debugPrint("Follow Status==>\(response)")

				}, failure: { (error) in

			})

		}
	}

	// MARK:- Idea Pinned
	// Set Pinned.
	func setIdeaPinnedStatus(isPinnedStatus: Bool) {
		if isPinnedStatus == true {
			// call remove pinned api.
			APIHandler.handler.removeIdeaPin(forIdeaID: self.ideaDetailsObj.IdeaID!, success: { (response) in
				self.changePinnedImage(false)
				self.ideaDetailsObj.isPinnedStatus = false
				// Toast.show(withMessage: PINNED_REMOVED)
				}, failure: { (error) in

			})
		}
		else {
			// call add pinned api
			APIHandler.handler.addIdeaPin(withIdeaID: self.ideaDetailsObj.IdeaID!, success: { (response) in
				// Toast.show(withMessage: PINNED_ADD)
				self.changePinnedImage(true)
				self.ideaDetailsObj.isPinnedStatus = true
				}, failure: { (error) in
			})
		}

	}
// Call Api Like and Dislike
	func setLikeDislikeStaus(isLikeStaus: Bool) {
		if isLikeStaus == true {
			// call dislike api.
			APIHandler.handler.ideaDislike(forIdeaID: self.ideaDetailsObj.IdeaID!, success: { (response) in
				debugPrint("Idea DisLike Response\(response)")
				self.ideaDetailsObj.likeCount = response["likeCount"].intValue
				self.loadIdeaDetails()
				self.changeLikeButtonImage(false)
				self.ideaDetailsObj.isLikedStatus = false
				}, failure: { (error) in

			})
		} else {
			// call Like Api
			APIHandler.handler.addIdeaLike(forUserID: Globals.sharedClient.userID!, IdeaID: self.ideaDetailsObj.IdeaID!, success: { (response) in

				debugPrint("Idea Like Response\(response)")
				self.ideaDetailsObj.likeCount = response["likeCount"].intValue
				self.loadIdeaDetails()
				self.changeLikeButtonImage(true)
				self.ideaDetailsObj.isLikedStatus = true

			}) { (error) in

			}
		}

	}

	func addLike(forUserID userID: Int?, ideaID: Int?) {
		APIHandler.handler.addIdeaLike(forUserID: userID, IdeaID: ideaID, success: { (response) in

			debugPrint("Idea Like Response\(response)")
			self.ideaDetailsObj.likeCount = response["likeCount"].intValue
			self.loadIdeaDetails()
			self.changeLikeButtonImage(true)
			self.ideaDetailsObj.isLikedStatus = true

		}) { (error) in

		}
	}

	// Working on Report abus.
	func reportAbusWith(forReportID typeID: Int?, abuseType: String?) {
		APIHandler.handler.reportAbuseWithTypeID(forTypeID: typeID!, abuse_type: abuseType!, success: { (response) in
			print("Report Value==\(response)")
			if abuseType == kReportAbusIdea {
				self.ideaDetailsObj.isReportAbusStatus = true
				self.changeReportAbusImage(true)
			} else if abuseType == kReportAbusComment {
				let objComments = self.arrComments[0] as! Comments
				objComments.commentReportAbus = true
				self.changeReportAbusImageComment(true)
			}

		}) { (error) in

		}
	}

}

// MARK:- Change Button Image.
extension IdeasDetailsController {
	// Change Like button Image.
	func changeLikeButtonImage(isLikeStatus: Bool) {
		if isLikeStatus == true {
			self.imgLike.image = UIImage(named: kImageLikeSelected)
		}
		else {
			self.imgLike.image = UIImage(named: kImageLikeDeselected)
		}
	}
	// Chnage Pinned Button Image
	func changePinnedImage(isPinnedStaus: Bool) {
		if isPinnedStaus == true {
			self.imgPinned.image = UIImage(named: kImagePinnedSelected)
		}
		else {
			self.imgPinned.image = UIImage(named: kImagePinnedDselected)
		}
	}

	// Follow And un follow
	func changeFollowTitle(isFollowStatua: Bool) {
		if isFollowStatua == true {
			self.buttonFollow.setTitle("Unfollow", forState: .Normal)
		} else {
			self.buttonFollow.setTitle("Follow", forState: .Normal)
		}
	}

	// Chnage Report Abus Status
	func changeReportAbusImage(isReportAbusStatus: Bool) {
		if isReportAbusStatus == true {
			// self.imgReportAbus.image = UIImage(named: kReportAbusRedImage)
			self.buttonReportAbus.setImage(UIImage(named: kReportAbusRedImage), forState: .Normal)

		} else {
			self.buttonReportAbus.setImage(UIImage(named: kReportAbusGreenImage), forState: .Normal)
			// self.imgReportAbus.image = UIImage(named: kReportAbusGreenImage)

		}

	}

	// Chnage Report Abus Status
	func changeReportAbusImageComment(isReportAbusStatus: Bool) {
		if isReportAbusStatus == true {
			self.buttonAlert.setImage(UIImage(named: kReportAbusRedImage), forState: .Normal)

		} else {
			self.buttonAlert.setImage(UIImage(named: kReportAbusGreenImage), forState: .Normal)

		}

	}

}

extension IdeasDetailsController {
	func setCommentButton() {
		commentBtn = UIButton(type: .System) // let preferred over var here
		commentBtn.frame = CGRectMake(CGRectGetWidth(UIScreen.mainScreen().bounds) - 65.0, CGRectGetHeight(UIScreen.mainScreen().bounds) - 48, 45.0, 45.0)
		commentBtn.tintColor = UIColor.clearColor()
		commentBtn.setBackgroundImage(UIImage(named: "CommentsFlootingIcon"), forState: UIControlState.Normal)
		commentBtn.addTarget(self, action: #selector(IdeasDetailsController.buttonComments(_:)), forControlEvents: UIControlEvents.TouchUpInside)
		NavigationHelper.helper.mainContainerViewController?.view.addSubview(self.commentBtn!)
	}

	@IBAction func buttonComments(sender: UIButton) {

		Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
			if isLogin == true {
				self.commentBtn.userInteractionEnabled = false
				CommentPopupController.showAddOrClearPopUp(NavigationHelper.helper.mainContainerViewController!, didSubmit: { (text, popUp) in
					// API Calling
					APIHandler.handler.writeComment(forUser: INTEGER_FOR_KEY(kUserID), ideaID: self.ideaDetailsObj.IdeaID, comment: text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()), success: { (response) in
						debugPrint("UserDetails Response -> \(response)")
						popUp?.dismissAnimate()
						self.getIdeaDetailsWithIdeaID(forIdeaID: self.ideaDetailsObj.IdeaID)

					}) { (error) in
						debugPrint("Error \(error)")
					}

				}) {
					debugPrint("Finish")
					self.commentBtn.userInteractionEnabled = true
				}
			}

			// self.commentBtn.userInteractionEnabled = true
		}

	}
}

