//
//  ProjectDetailsController.swift
//  Greenply
//
//  Created by Shatadru Datta on 31/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class ProjectDetailsController: BaseTableViewController {

	@IBOutlet weak var imgLike: UIImageView!
	@IBOutlet weak var collectionImages: UICollectionView!
	@IBOutlet weak var imageBannerProjDetails: UIImageView!
	@IBOutlet weak var imageProfileProjDetails: UIImageView!
	@IBOutlet weak var labelProjDescription: UILabel!
    var isReportSatus: Bool?
    @IBOutlet weak var buttonReportAbus: UIButton!
    @IBOutlet weak var labelProjType: UILabel!
	@IBOutlet weak var labelProjLocation: UILabel!
	@IBOutlet weak var labelDesignType: UILabel!
	@IBOutlet weak var imageBottomLayer: UIImageView!
	@IBOutlet weak var labelProjName: UILabel!
	@IBOutlet weak var labelLikes: UILabel!
	@IBOutlet weak var labelViews: UILabel!
	@IBOutlet weak var buttonFollow: UIButton!
	var objPortfolioDetails: Portfolio!
    var portFolioUserID: Int?
	@IBOutlet var labelProjectType: UILabel!
	@IBOutlet var labelLocationType: UILabel!
	@IBOutlet var labelStyleType: UILabel!
	@IBOutlet var labelRoomType: UILabel!
	@IBOutlet var labelWorkType: UILabel!
	@IBOutlet var labelProjectBudget: UILabel!
	@IBOutlet var labelTags: UILabel!

	@IBOutlet var viewContents: [UIView]!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.tableView.backgroundView = nil
		self.tableView.backgroundColor = UIColorRGB(233.0, g: 235.0, b: 236.0)

		for (index, view) in viewContents.enumerate() {

			view.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
			view.layer.borderColor = UIColorRGB(224.0, g: 226.0, b: 227.0)?.CGColor

			if index == 0 || index == 6 || index == 7 {
				view.layer.cornerRadius = IS_IPAD() ? 10.0 : 5.0
				view.layer.masksToBounds = true
			} else {
				view.layer.masksToBounds = false
			}
		}

		imageProfileProjDetails.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
		imageProfileProjDetails.layer.borderColor = UIColorRGB(149.0, g: 204.0, b: 68.0)?.CGColor
		imageProfileProjDetails.layer.cornerRadius = IS_IPAD() ? imageProfileProjDetails.frame.size.width / 2: 50 / 2
		imageProfileProjDetails.layer.masksToBounds = true

		buttonFollow.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
		buttonFollow.layer.borderColor = UIColorRGB(149.0, g: 204.0, b: 68.0)?.CGColor
		buttonFollow.layer.cornerRadius = IS_IPAD() ? 20.0 : 10.0
		buttonFollow.layer.masksToBounds = true

	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
		NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_Project_Details
		self.showProftfolioDataDetails()
		// call api portfolio Details
		self.getPortFolioDetailsWith(forPortfolioID: objPortfolioDetails.portfolioID)
	}
    
    @IBAction func actionReportAbus(sender: UIButton) {
    }
    @IBAction func actionFollow(sender: UIButton) {
       
        Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
            if isLogin == true{
                if self.objPortfolioDetails.isFollowStatus == true{
                    
                    APIHandler.handler.unFollow(forUnfollowrID: self.portFolioUserID!, success: { (response) in
                        debugPrint("Un Follow Respose ==> \(response)")
                        self.changeFollowTitle(false)
                        self.objPortfolioDetails.isFollowStatus = false
                        }, failure: { (error) in
                    })
                }
                else if self.objPortfolioDetails.isFollowStatus == false{
                    APIHandler.handler.addFollow(forFollowerID: self.portFolioUserID!, success: { (response) in
                        self.changeFollowTitle(true)
                        self.objPortfolioDetails.isFollowStatus = true
                        debugPrint("Follow Status==>\(response)")
                        
                        }, failure: { (error) in
                            
                    })
                }
            }
        }
   
        
    }
	
    @IBAction func likes(sender: UIButton) {
        Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
            if isLogin == true{
                
            }
        }
	}
	@IBAction func share(sender: UIButton) {
        Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
            if isLogin == true{
                
            }
        }
	}
	@IBAction func alert(sender: UIButton) {
        if isReportSatus == true{
          self.buttonReportAbus.userInteractionEnabled = true
             self.reportAbusWith(forReportID: objPortfolioDetails.portfolioID!, abuseType: kReportAbusPortfolio)
        }else{
            self.buttonReportAbus.userInteractionEnabled = false
           
        }
        
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK:- action.

	@IBAction func actionImageList(sender: AnyObject) {

		let portfolioImageListVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(AllPortfolioImagesListViewController)) as! AllPortfolioImagesListViewController
		let imageArr = objPortfolioDetails.arrPortFolioImages

		portfolioImageListVC.arrPortfolioImageList = imageArr
		NavigationHelper.helper.contentNavController?.pushViewController(portfolioImageListVC, animated: true)
	}

	func showProftfolioDataDetails() {
		labelProjName.text = objPortfolioDetails.projectName
		labelLikes.text = "\(objPortfolioDetails.likeCount!)"
		labelViews.text = "\(objPortfolioDetails.viewCount!)"
		labelProjDescription.text = objPortfolioDetails.portfolioDescription

	}

}

extension ProjectDetailsController {
// MARK:- User Details.
    func getAttributeName(attributeSearchName: String, pArry: [AnyObject]) -> String?
	{
		let name = NSPredicate(format: "attribute_name contains[c] %@", attributeSearchName)

		let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
		let filteredArray = pArry.filter { compoundPredicate.evaluateWithObject($0) }
		// return filteredArray.first!["attribute_value_name"]
		if filteredArray.count > 0 {
			let dict = filteredArray.first
			return dict!["attribute_value_name"] as? String
		}
		return nil
	}
    // MARK:- 
    // Follow And un follow
    func changeFollowTitle(isFollowStatua: Bool){
        if isFollowStatua == true{
            self.buttonFollow.setTitle("Unfollow", forState: .Normal)
        }else{
            self.buttonFollow.setTitle("Follow", forState: .Normal)
        }
    }
    // Change Like button Image.
    func changeLikeButtonImage(isLikeStatus: Bool) {
        if isLikeStatus == true {
            self.imgLike.image = UIImage(named: kImageLikeSelected)
        }
        else {
            self.imgLike.image = UIImage(named: kImageLikeDeselected)
        }
    }
    
    
    // Chnage Report Abus Status
    func changeReportAbusImage(isReportAbusStatus: Bool) {
        if isReportAbusStatus == true {
            self.buttonReportAbus.setImage(UIImage(named:kReportAbusGreenImage ), forState: .Normal)
            
        } else {
            self.buttonReportAbus.setImage(UIImage(named:kReportAbusRedImage ), forState: .Normal)
        }
        
    }
}
extension ProjectDetailsController {
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0:
				return 147
			case 1:
				return IS_IPAD() ? 212.0 : 190.0
			case 2:
                return (objPortfolioDetails.portfolioDescription?.requiredHeight(forWidth: SCREEN_WIDTH - ((2 * 16) + 10), andFont: labelProjDescription.font))! + 65.0 + 20.0
			default:
				return IS_IPAD() ? 440 : 340
			}
		case 1:
			switch indexPath.row {
			case 0:
				return IS_IPAD() ? 75.0 : 68.0
			case 1:
				return IS_IPAD() ? 68.0 : 60
			case 2:
				return IS_IPAD() ? 68.0 : 60
			case 3:
				return IS_IPAD() ? 68.0 : 60
			case 4:
				return IS_IPAD() ? 68.0 : 60
			case 5:
				return IS_IPAD() ? 68.0 : 60
			case 6:
				return IS_IPAD() ? 85.0 : 60
			default:
				return 0
			}
		default:
			return 0
		}
	}
}

extension ProjectDetailsController: UICollectionViewDataSource, UICollectionViewDelegate {

	// MARK: UICollectionViewDataSource methods
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.objPortfolioDetails.arrPortFolioImages.count
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		var cell: BaseCollectionViewCell?
		cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(ProjectsCollectionViewCell), forIndexPath: indexPath) as! ProjectsCollectionViewCell
		cell?.datasource = objPortfolioDetails.arrPortFolioImages[indexPath.row]
		return cell!
	}

	// MARK: UICollectionViewDelegateFlowLayout methods
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSizeMake(115.0, 115.0)
	}
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

		let portfolioImageListVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(AllPortfolioImagesListViewController)) as! AllPortfolioImagesListViewController
		let imageArr = objPortfolioDetails.arrPortFolioImages
		portfolioImageListVC.arrPortfolioImageList = imageArr

		NavigationHelper.helper.contentNavController!.pushViewController(portfolioImageListVC, animated: true)

	}
}

// API Calling
extension ProjectDetailsController {
	func getPortFolioDetailsWith(forPortfolioID portfolioID: Int?) {

		APIHandler.handler.getPortFolioDetails(forPortFolioID: portfolioID, success: { (response) in

			var dict = response.dictionaryObject
			let arrAttr = dict!["attribute_name"]
			self.objPortfolioDetails.isFollowStatus = Bool(response["isFollowing"])
           self.isReportSatus = Bool(response["abused"])
            self.changeReportAbusImage(self.isReportSatus!)
            self.objPortfolioDetails.isLikedStatus = Bool(response["isLiked"])
           self.portFolioUserID = dict!["user_id"] as? Int
            self.changeLikeButtonImage(self.objPortfolioDetails.isLikedStatus!)
            self.changeFollowTitle(self.objPortfolioDetails.isFollowStatus!)
            
			self.labelStyleType.text = self.getAttributeName("Style Type", pArry: arrAttr! as! [AnyObject])
			self.labelWorkType.text = self.getAttributeName("Work Type", pArry: arrAttr! as! [AnyObject])
			self.labelProjectBudget.text = self.getAttributeName("Project Budget", pArry: arrAttr! as! [AnyObject])
			 self.labelProjType.text = self.getAttributeName("Project Type", pArry: arrAttr! as! [AnyObject])

			self.labelLocationType.text = "" // Not Coming to APi.
			self.labelRoomType.text = "" // Not Coming to APi.

			let arrTag = response!["tags"].arrayObject
			var nameStr = ""
			for index in 0..<arrTag!.count {
				nameStr = nameStr + (arrTag![index]["tag_name"]! as? String)!
				if index < arrTag!.count - 1 {
					nameStr = nameStr + ","
				}
			}
    
			self.labelTags.text = nameStr
			

		}) { (error) in

		}

	}
      // MARK:- Call Follow And unFollow Api
    func setFollowAndUnFollowStaus() {
    
    }
    // Working on Report abus.
    func reportAbusWith(forReportID typeID: Int?, abuseType: String?) {
        APIHandler.handler.reportAbuseWithTypeID(forTypeID: typeID!, abuse_type: abuseType!, success: { (response) in
            print("Report Value==\(response)")
            //self.ideaDetailsObj.isReportAbusStatus = true
            self.changeReportAbusImage(false)
        }) { (error) in
            
        }
    }
    

}

