//
//  MeetAnExpertDetailsViewController.swift
//  Greenply
//
//  Created by Shatadru Datta on 29/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MeetAnExpertDetailsViewController: BaseTableViewController {

	@IBOutlet weak var viewRating: FloatRatingView!
	@IBOutlet weak var labelName: UILabel!;
	@IBOutlet weak var labelDistance: UILabel!
	@IBOutlet weak var labelPlace: UILabel!
	@IBOutlet weak var imageProfile: UIImageView!
	@IBOutlet weak var imageBackgroundProfile: UIImageView!
	@IBOutlet weak var buttonRateReview: UIButton!
	@IBOutlet weak var buttonLikes: UIButton!
	@IBOutlet weak var buttonCall: UIButton!
	@IBOutlet weak var buttonFollow: UIButton!
	@IBOutlet weak var buttonFollowing: UIButton!
	@IBOutlet weak var buttonFollowers: UIButton!
	@IBOutlet weak var buttonView: UIButton!
	@IBOutlet weak var labelProjects: UILabel!
	@IBOutlet weak var buttonViewAllProj: UIButton!
	@IBOutlet weak var collectionViewProj: UICollectionView!
	@IBOutlet weak var labelIdeas: UILabel!
	@IBOutlet weak var buttonViewAllIdeas: UIButton!
	@IBOutlet weak var collectionViewIdeas: UICollectionView!
	@IBOutlet weak var labelAboutName: UILabel!
	@IBOutlet weak var labelAboutNameDesc: UILabel!
	@IBOutlet weak var labelEducation: UILabel!
	@IBOutlet weak var labelEducationDesc: UILabel!
	@IBOutlet weak var labelWorkExperience: UILabel!
	var objExprience: Experience!
	@IBOutlet weak var buttonEduMore: UIButton!
	@IBOutlet weak var labelEduTitle: UILabel!
	@IBOutlet weak var buttonExpMore: UIButton!
	@IBOutlet weak var labelExpTitle: UILabel!

	@IBOutlet weak var labelExpToDate: UILabel!

	@IBOutlet weak var labelEduDesc: UILabel!
	@IBOutlet weak var labelEduFormDate: UILabel!
	@IBOutlet weak var lableEduToDate: UILabel!

	@IBOutlet weak var labelExpFromDate: UILabel!
	@IBOutlet weak var labelServiceArea: UILabel!
	@IBOutlet weak var labelSeviceDesc: UILabel!
	@IBOutlet weak var viewRate: FloatRatingView!
	@IBOutlet weak var labelRatingonDate: UILabel!
	@IBOutlet weak var labelGivenCommentsName: UILabel!
	@IBOutlet weak var labelRateComments: UILabel!
	var arrInfluncerIdeaList = [AnyObject]()
	var arrInfluncerProjectList = [AnyObject]()
	var objInfluencerDetails: Influencer!
	var buttonRating: UIButton!
	// var likeDislikeStaus: Bool!
	var arrRating = [AnyObject]()

    var isReportAbus: Bool = false   ////For the TimeBing
    @IBOutlet weak var buttonReportAbus: UIButton!
	@IBOutlet weak var labelViewCount: UILabel!
	@IBOutlet weak var labelLikeCount: UILabel!
	@IBOutlet weak var btnLikeDisLike: UIButton!
	@IBOutlet var viewContents: [UIView]!
    
    //.................
    var arrWorkExperience = [AnyObject]()
    var arrDistance = [AnyObject]()
    var arrJobCost = [AnyObject]()
    var arrRatings = [AnyObject]()
    //.................
    

	override func viewDidLoad() {
		super.viewDidLoad()

		//buttonExpMore.hidden = false

		// likeDislikeStaus = true // for time being
		self.tableView.backgroundView = nil

		for (_, view) in viewContents.enumerate() {
			view.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
			view.layer.borderColor = UIColorRGB(224.0, g: 226.0, b: 227.0)?.CGColor
			view.layer.cornerRadius = IS_IPAD() ? 15.0 : 5.0
			view.layer.masksToBounds = true
		}

		imageProfile.backgroundColor = UIColor.brownColor()
		imageProfile.layer.borderWidth = IS_IPAD() ? 3.0 : 2.0
		imageProfile.layer.borderColor = UIColor(red: 163.0 / 255.0, green: 208.0 / 255.0, blue: 107.0 / 255.0, alpha: 1.0).CGColor
		imageProfile.layer.cornerRadius = IS_IPAD() ? imageProfile.frame.size.width / 2: 90 / 2
		imageProfile.layer.masksToBounds = true
		buttonFollow.layer.cornerRadius = buttonFollow.frame.height / 2 - 2

		self.tableView.estimatedRowHeight = 90.0
		self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        
    }

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
      
        self.changeReportAbusImage(isReportAbus)
		let arrExpValue = self.objInfluencerDetails.arrExperienceList
		if arrExpValue.count > 0 {
			objExprience = self.objInfluencerDetails.arrExperienceList[0] as! Experience
			self.labelExpTitle.text = self.objExprience.organisation_name!
			self.labelExpToDate.text = NSDate.dateFromTimeInterval(self.objExprience.startDate!).getFormattedStringWithFormat()
			self.labelExpFromDate.text = NSDate.dateFromTimeInterval(self.objExprience.endDate!).getFormattedStringWithFormat()
		}

// self.getInfluncerDetails(forUserID: objInfluencerDetails.influencerID)
		NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_MEET_EXPERT
		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: false, isHideMenuButton: false)
		NavigationHelper.helper.tabBarViewController!.hideTabBar()
		self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
		// get influencer Details
		self.getinfluencerDetails { (objinfluencer) in

			self.labelName.text = objinfluencer.influencerUserName
			self.labelLikeCount.text = String(objinfluencer.influencerLikeCount!)
			self.labelPlace.text = objinfluencer.influencerAddress
			self.labelViewCount.text = String(objinfluencer.influencerViewCount!)
			self.labelAboutNameDesc.text = objinfluencer.aboutUs
			self.labelSeviceDesc.text = objinfluencer.influencerserviceArea

			// self.labelEducationDesc.text = objinfluencer.influencerEducations

			Helper.sharedClient.distanceBetweenTwoLocations((String(objinfluencer.latitude!)).toDouble(), sourceLongitude: (String(objinfluencer.longitude!)).toDouble()) { (result) in
				self.labelDistance.text = String(result) + "KM"
			}

			self.changeLikeAndDislike(self.objInfluencerDetails.isLikedStatus!)
			self.checkFollowingORStartFollowingStatus()

			if let profilePic = objinfluencer.influencerCoverProfle {
				self.imageProfile.setImage(withURL: NSURL(string: profilePic)!, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .CrossDissolve(0.4))
			} else {
				self.imageProfile.image = UIImage(named: "DefultProfileImage")
			}
		}

		self.setRatingButton()

		viewRate.editable = false
	}
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		buttonRating.removeFromSuperview()
	}

	@IBAction func actionExpMore(sender: UIButton) {
		let moreDetails = mainStoryboard.instantiateViewControllerWithIdentifier(String(MoreDetailsViewController)) as! MoreDetailsViewController

		moreDetails.strMoreType = "EXPERISTION"
		moreDetails.arrDataItems = self.objInfluencerDetails.arrExperienceList
		NavigationHelper.helper.contentNavController!.pushViewController(moreDetails, animated: true)
	}

	@IBAction func actionEduMore(sender: UIButton) {

		let moreDetails = mainStoryboard.instantiateViewControllerWithIdentifier(String(MoreDetailsViewController)) as! MoreDetailsViewController
		moreDetails.strMoreType = "EDUCATION"
		moreDetails.arrDataItems = self.objInfluencerDetails.arrEducationList
		NavigationHelper.helper.contentNavController!.pushViewController(moreDetails, animated: true)

	}
	// MARK:-

	// MARK:- Action.
	@IBAction func followAction(sender: UIButton) {

		if buttonFollow.titleLabel?.text == TITLE_START_FOllOWING {
			Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
				if isLogin == true {

				}
			}
		}
		else {
			// cal To Api For un Folllwing
			self.setFollowAndUnFollowStaus()
		}

	}

    @IBAction func actionReportAbus(sender: UIButton) {
        
        if isReportAbus == true{   //For the TimeBing
            self.buttonReportAbus.userInteractionEnabled = false
        }else{
             self.buttonReportAbus.userInteractionEnabled = true
            self.reportAbusWith(forReportID: self.objInfluencerDetails.influencerID!, abuseType: kReportAbusUser)
        }
    }
	@IBAction func actionLikeUnLike(sender: UIButton) {

		Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
			if isLogin == true {
				// call APi
				self.influncerLikeDislike(forUserID: Globals.sharedClient.userID, influencerID: self.objInfluencerDetails.influencerID!)
			}

		}

	}
	// MARK:- Action.
	@IBAction func clickProjects(sender: UIButton) {

		// Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
		// if isLogin == true {
		// let portfolioListingVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(ProjectListingController)) as! ProjectListingController
		//
		// portfolioListingVC.buttonAddProjectStatus = .eHideButton
		// portfolioListingVC.ePortfolioTitleStatus = .ePortfolioListingTitle
		// portfolioListingVC.influencerID = self.objInfluencerDetails.influencerID!
		// NavigationHelper.helper.contentNavController!.pushViewController(portfolioListingVC, animated: true)
		// }
		// }

		let portfolioListingVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(ProjectListingController)) as! ProjectListingController

		portfolioListingVC.buttonAddProjectStatus = .eHideButton
		portfolioListingVC.ePortfolioTitleStatus = .ePortfolioListingTitle
		portfolioListingVC.pUserID = self.objInfluencerDetails.influencerID!
		NavigationHelper.helper.contentNavController!.pushViewController(portfolioListingVC, animated: true)

	}

	@IBAction func clickIdeas(sender: UIButton) {
		let IdeaListingVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(IdeaListingController)) as! IdeaListingController
		// NavigationHelper.helper.currentViewController = IdeaListingVC
		// NavigationHelper.helper.navigationController = NavigationHelper.helper.contentNavController as UINavigationController
		NavigationHelper.helper.contentNavController!.pushViewController(IdeaListingVC, animated: true)

	}

	@IBAction func clickRateReview(sender: UIButton) {
		let rateandReviewVC = otherStoryboard.instantiateViewControllerWithIdentifier(String(RatingAndReviewController)) as! RatingAndReviewController
		// rateandReviewVC.influncerID = objInfluencerDetails.influencerID!
		rateandReviewVC.objInfluencerItems = self.objInfluencerDetails
		NavigationHelper.helper.contentNavController!.pushViewController(rateandReviewVC, animated: true)

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
// MARK:- Function.
extension MeetAnExpertDetailsViewController {
	// Add rating Button.
	func setRatingButton() {
		buttonRating = UIButton(type: .System) // let preferred over var here
		buttonRating.frame = CGRectMake(CGRectGetWidth(UIScreen.mainScreen().bounds) - 65.0, CGRectGetHeight(UIScreen.mainScreen().bounds) - 80.0, 50.0, 50.0)
		buttonRating.tintColor = UIColor.clearColor()
		buttonRating.setBackgroundImage(UIImage(named: "CommentsFlootingEditIcon"), forState: UIControlState.Normal)
		buttonRating.addTarget(self, action: #selector(self.actionRating(_:)), forControlEvents: UIControlEvents.TouchUpInside)
		NavigationHelper.helper.mainContainerViewController?.view.addSubview(self.buttonRating!)
	}

	func actionRating(sender: UIButton) {
		Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
			if isLogin == true {
				let writeReviewVC = otherStoryboard.instantiateViewControllerWithIdentifier(String(WriteReviewController)) as! WriteReviewController
				// writeReviewVC.influncerID = self.objInfluencerDetails.influencerID!

				writeReviewVC.objInfluencerList = self.objInfluencerDetails
				NavigationHelper.helper.contentNavController!.pushViewController(writeReviewVC, animated: true)
			}
		}
	}
	func checkFollowingORStartFollowingStatus() {

		if INTEGER_FOR_KEY(kUserID) != 0 {
			self.buttonFollow.setTitle("Following", forState: .Normal)
			self.buttonFollow.setImage(UIImage(named: "FollowIcon"), forState: .Normal)
			self.buttonFollow.backgroundColor = UIColorRGB(227, g: 244, b: 30)
			self.buttonFollow.setTitleColor(UIColor.blackColor(), forState: .Normal)
			self.changeFollowTitle(objInfluencerDetails.isFollowStatus!)

		}
		else {
			self.buttonFollow.setImage(UIImage(named: ""), forState: .Normal)
			self.buttonFollow.setTitle("Start Following", forState: .Normal)
		}

	}
	func changeLikeAndDislike(isLikeStatus: Bool) {
		if isLikeStatus == true {
			self.btnLikeDisLike.setImage(UIImage(named: kFevImageSeleted), forState: .Normal)

		} else {
			self.btnLikeDisLike.setImage(UIImage(named: kFevImageDeSeleted), forState: .Normal)

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

	// MARK:- Get influencer Details...
	func getinfluencerDetails(objinfluencer: (objinfluencer: Influencer) -> ()) {
		objinfluencer(objinfluencer: self.objInfluencerDetails!)

		// Get Rating..
		self.getInfluncerRateAndReviewList({ (pRatingData) in
            if pRatingData.count > 0 {
				let objRating = pRatingData[0] as! Ratings
                self.viewRate.rating = Float(objRating.rating!)
				self.labelRateComments.text = objRating.comment
                // labelDesc.text = objRatings.comment
				let date = NSDate.dateFromTimeInterval(Double(objRating.createdAt!)).getFormattedStringWithFormat()
				self.labelRatingonDate.text = date
				self.labelGivenCommentsName.text = objRating.name
            }
           

		})
      
       

	}
    
    
    // Chnage Report Abus Status
    func changeReportAbusImage(isReportAbusStatus: Bool) {
        if isReportAbusStatus == true {
            self.buttonReportAbus.setImage(UIImage(named: kReportAbusRedImage), forState: .Normal)
            
        } else {
            self.buttonReportAbus.setImage(UIImage(named: kReportAbusGreenImage), forState: .Normal)
            
        }
        
    }

}

extension MeetAnExpertDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

	// MARK: UICollectionViewDataSource methods
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == collectionViewProj {
			return self.arrInfluncerProjectList.count
		} else {
			return self.arrInfluncerIdeaList.count
		}
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		var cell: BaseCollectionViewCell?
		if collectionView == collectionViewProj {
			cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(ProjectsCollectionViewCell), forIndexPath: indexPath) as! ProjectsCollectionViewCell
			if self.arrInfluncerProjectList.count > 0 {

				let objPortfolio = arrInfluncerProjectList[indexPath.row] as! Portfolio
				cell?.datasource = objPortfolio.arrPortFolioImages[0]

			}

		} else {
			cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(IdeasCollectionViewCell), forIndexPath: indexPath) as! IdeasCollectionViewCell

			if self.arrInfluncerIdeaList.count > 0 {
				cell?.datasource = self.arrInfluncerIdeaList[indexPath.row]
			}

		}
		return cell!
	}

	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if collectionView == collectionViewProj {

			let ProjectDetailsVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(ProjectDetailsController)) as! ProjectDetailsController
			let objPortfolioList = arrInfluncerProjectList[indexPath.row] as! Portfolio
			ProjectDetailsVC.objPortfolioDetails = objPortfolioList
			NavigationHelper.helper.contentNavController!.pushViewController(ProjectDetailsVC, animated: true)

		}
		else {
			let cell = collectionView.cellForItemAtIndexPath(indexPath) as! IdeasCollectionViewCell
			let IdeaDetailsVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(IdeasDetailsController)) as! IdeasDetailsController
			let objIdeaList = cell.datasource
			IdeaDetailsVC.ideaDetailsObj = objIdeaList as! IdeaListing
			NavigationHelper.helper.contentNavController?.pushViewController(IdeaDetailsVC, animated: true)
		}

	}

	// MARK: UICollectionViewDelegateFlowLayout methods
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSizeMake(115.0, 115)
	}
}

extension MeetAnExpertDetailsViewController {
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		switch indexPath.row {
		case 0:
			return IS_IPAD() ? 284.0 : 217.0
		case 1:
			return IS_IPAD() ? 80.0 : 72.0
		case 2, 3:
			return IS_IPAD() ? 220 : 190.0
		case 5:
			return IS_IPAD() ? 200 : 180
		case 6:
			return IS_IPAD() ? 160 : 140
		case 4, 7..<9:
			return UITableViewAutomaticDimension
		default:
			return 0
		}
	}
}
// MARK:- Api Calling
extension MeetAnExpertDetailsViewController {

	func influncerLikeDislike(forUserID userID: Int?, influencerID: Int?) {

		if self.objInfluencerDetails.isLikedStatus == true {

			// Influencer Dislike
			APIHandler.handler.influencerDislike(forinfluencerID: influencerID!, success: { (response) in

				self.changeLikeAndDislike(false)
				self.objInfluencerDetails.isLikedStatus = false
				// Toast.show(withMessage: DISLIKE_SUCCESSFULLY)
			}) { (error) in

			}

		} else {
			// Influencer Like
			APIHandler.handler.addInfluencerLike(forUserID: userID!, influencerID: influencerID!, success: { (response) in
				// debugPrint("like Response \(response)")
				// // For the time being
				// Toast.show(withMessage: LIKE_SUCCESSFULLY)
				self.changeLikeAndDislike(true)
				self.objInfluencerDetails.isLikedStatus = true
			}) { (error) in

			}

		}
	}

	func setFollowAndUnFollowStaus() {
		if objInfluencerDetails.isFollowStatus == true {
			APIHandler.handler.unFollow(forUnfollowrID: self.objInfluencerDetails.influencerID!, success: { (response) in
				debugPrint("Un Follow Respose ==> \(response)")
				self.changeFollowTitle(false)
				self.objInfluencerDetails.isFollowStatus = false
				}, failure: { (error) in
			})

		}
		else if objInfluencerDetails.isFollowStatus == false {
			// call follow api
			APIHandler.handler.addFollow(forFollowerID: self.objInfluencerDetails.influencerID!, success: { (response) in
				self.changeFollowTitle(true)
				self.objInfluencerDetails.isFollowStatus = true

				}, failure: { (error) in

			})

		}
	}

	// MARK:- Get Influncer Idea details.
	func getInfluncerIdeaList() {
		self.arrInfluncerIdeaList.removeAll()

		APIHandler.handler.getIdeaListingWithUserID(forUserID: objInfluencerDetails.influencerID!, success: { (response) in

			for value in response["Idea"].arrayObject! {
				let idesListObj = IdeaListing(withDictionary: value as! [String: AnyObject])
				self.arrInfluncerIdeaList.append(idesListObj)
			}
			self.collectionViewIdeas.reloadData()
		}) { (error) in

		}
	}

	// Get Influncer Project List
	func getInfluncerProjectList() {
		self.arrInfluncerProjectList.removeAll()

		APIHandler.handler.getMyPortfolioListing(objInfluencerDetails.influencerID!, pageNumber: "1", perPage: "1", success: { (response) in

			if let arrResult = response["portfolios"].arrayObject
			{
				for value in arrResult {
					let objPortfolio = Portfolio(withDictionary: value as! [String: AnyObject])
					self.arrInfluncerProjectList.append(objPortfolio)
				}
				self.collectionViewProj.reloadData()

			}
			self.getInfluncerIdeaList()
		}) { (error) in

		}

	}

	// MArk:- Get Influncer Rate list
	func getInfluncerRateAndReviewList(pRatingData: ([AnyObject] -> ())) {

		APIHandler.handler.rateAndReview(forUser: self.objInfluencerDetails.influencerID!, success: { (response) in
			self.arrRating.removeAll()
            
            dispatch_async(dispatch_get_main_queue()) {
                self.getInfluncerProjectList()
            }
            
			if let _ = response.dictionaryObject!["reviewlist"] {
				self.buttonRateReview.userInteractionEnabled = true
				for value in response["reviewlist"]["ratings"].arrayObject! {
					let RateListObj = Ratings(withDictionary: value as! [String: AnyObject])
					self.arrRating.append(RateListObj)
				}
				pRatingData(self.arrRating)

			} else {
				self.buttonRateReview.userInteractionEnabled = false
			}

		}) { (error) in

		}
	}
    
    
    
    // Working on Report abuse.
    func reportAbusWith(forReportID typeID: Int?, abuseType: String?) {
    APIHandler.handler.reportAbuseWithTypeID(forTypeID: typeID!, abuse_type: abuseType!, success: { (response) in
        self.isReportAbus = true // For Time being
            self.changeReportAbusImage(true)
        }) { (error) in
           
        Toast.show(withMessage: mReportAlredy)
        }
    }
}
