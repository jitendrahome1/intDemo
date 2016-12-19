//
//  ProjectListingController.swift
//  Greenply
//
//  Created by Shatadru Datta on 30/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

enum eButtonProject {
	case eshowButton
	case eHideButton
}

enum ePortFolioListing {
	case ePortfolioListingTitle
	case eMyPortfolioTitle
}

class ProjectListingController: BaseViewController, HeaderButtonDeleagte {

	var influencerID: Int?
	@IBOutlet weak var collectionViewProjList: UICollectionView!
	var buttonAddProjectStatus: eButtonProject = .eshowButton
	var ePortfolioTitleStatus: ePortFolioListing = .ePortfolioListingTitle
	var pUserID: Int?

	// Change letter
	var strPageNumber: String = "1"
	var strPerPage: String = "1"
	var arrPortfolioDetailsList = [AnyObject]()
	override func viewDidLoad() {
		super.viewDidLoad()

		NavigationHelper.helper.tabBarViewController!.hideTabBar()
		setupCollectionView()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		// NavigationHelper.helper.headerViewController!.addHeaderButton(kSearchButton)
		// NavigationHelper.helper.headerViewController?.addPlusButton()

		if ePortfolioTitleStatus == .ePortfolioListingTitle {
			NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_PORTFOLIO_LISTING
			NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: false, isHidenotification: false, isHideMenuButton: false)
			self.getMyPortfolioLsit(forUserID: pUserID)
		}
		else {
            NavigationHelper.helper.headerViewController?.delegateButton = self
			NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_MY_PORTFOLIO_LISTING
			NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
			NavigationHelper.helper.headerViewController?.addHeaderButton(kPluseButton)
			self.getMyPortfolioLsit(forUserID: Globals.sharedClient.userID)
		}
	}

	override func viewDidLayoutSubviews() {

		super.viewDidLayoutSubviews()
	}
}

extension ProjectListingController: UICollectionViewDataSource, UICollectionViewDelegate {

	func setupCollectionView() {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = IS_IPAD() ? 20.0 : 10.0
		collectionViewProjList.collectionViewLayout = layout
	}

	// MARK: UICollectionViewDataSource methods
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return arrPortfolioDetailsList.count
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(ProjListCollectionViewCell), forIndexPath: indexPath) as! ProjListCollectionViewCell
		if buttonAddProjectStatus == .eshowButton {
			cell.buttonAdd.hidden = false

			cell.editButtonHandler = { (projectID) in
				self.pushUploadIdeaVCWith(forProjectID: projectID)
				print("id\(projectID)")
			}
		}
		else {
			cell.buttonAdd.hidden = true
		}
		if arrPortfolioDetailsList.count > 0 {
			cell.datasource = arrPortfolioDetailsList[indexPath.row]
		}
		cell.layer.cornerRadius = IS_IPAD() ? 15.0 : 10.0
		cell.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
		cell.layer.borderColor = UIColor(red: 210.0 / 255.0, green: 210.0 / 255.0, blue: 210.0 / 255.0, alpha: 1.0).CGColor
		cell.layer.masksToBounds = true
		return cell
	}

	// MARK: UICollectionViewDelegateFlowLayout methods
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSizeMake((SCREEN_WIDTH / 2 - (IS_IPAD() ? 20.0 : 15.0)), (SCREEN_WIDTH / 2 - (IS_IPAD() ? 20.0 : 15.0)))
	}

	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

		let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ProjListCollectionViewCell
		let ProjectDetailsVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(ProjectDetailsController)) as! ProjectDetailsController
		let objPortfolioList = cell.datasource
		ProjectDetailsVC.objPortfolioDetails = objPortfolioList as! Portfolio
		NavigationHelper.helper.contentNavController!.pushViewController(ProjectDetailsVC, animated: true)
	}
}
// MARK: - APi Calling

extension ProjectListingController {

	// MARK: - UserID chnage to meet and expert ID when we get.
	/* NOTE: - Rember For testing we are passsing login user ID , But when we get Meet an ExpertID , then we passed login userID as meet an ExperID
	 */
	func getMyPortfolioLsit(forUserID userID: Int?) {

		arrPortfolioDetailsList.removeAll()
		// if INTEGER_FOR_KEY(kUserID) != 0 {
		APIHandler.handler.getMyPortfolioListing(userID!, pageNumber: strPageNumber, perPage: strPerPage,
			success: { (response) in
				debugPrint("Project List ==>\(response)")
                let notificationCount = response["totalNotification"].intValue
                if notificationCount > 0{
                    NavigationHelper.helper.headerViewController!.lblNotification.hidden = false
                    NavigationHelper.helper.headerViewController!.lblNotification.text = String(notificationCount)
                }else{
                    NavigationHelper.helper.headerViewController!.lblNotification.hidden = true
                }
				if let arrResult = response["portfolios"].arrayObject
				{ for value in arrResult {
					let objPortfolio = Portfolio(withDictionary: value as! [String: AnyObject])
					self.arrPortfolioDetailsList.append(objPortfolio)
					}
					self.collectionViewProjList.reloadData()
					debugPrint("Portfolio Details==>\(self.arrPortfolioDetailsList)")

				}
				else {
					Toast.show(withMessage: NO_RECORDS_FOUND)
				}

		}) { (error) in

		}
		// }
//		else {
//			// Show Messgae please Login.
//		}

	}

}
// MARK:- Header button Delegate
extension ProjectListingController {
	func didTapMenuButton(strButtonType: String) {
		if strButtonType == kPluseButton {
			let addPortfolioVC = otherStoryboard.instantiateViewControllerWithIdentifier(String(AddPortfolioViewController)) as! AddPortfolioViewController
			addPortfolioVC.eProjectStatus = .eUploadProject
			NavigationHelper.helper.contentNavController!.pushViewController(addPortfolioVC, animated: true)

		} else {

		}
	}

	// MARK:- Function.
	// Push to upload projet view controller Function.
	func pushUploadIdeaVCWith(forProjectID projectID: Int?) {
		let editPortfolioVC = otherStoryboard.instantiateViewControllerWithIdentifier(String(AddPortfolioViewController)) as! AddPortfolioViewController
		editPortfolioVC.projectID = projectID
		editPortfolioVC.eProjectStatus = .eProjectDetails
		NavigationHelper.helper.contentNavController!.pushViewController(editPortfolioVC, animated: true)
	}

}