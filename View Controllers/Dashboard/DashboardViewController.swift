//
//  DasboardViewController.swift
//  Greenply
//
//  Created by Rupam Mitra on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class DashboardViewController: BaseCollectionViewController {

	var aboutUsArray: [AnyObject]?
	var meetTheExpertArray: [AnyObject]?
	var homeDecorIdeasArray: [AnyObject]?
	var arrIdeasList = [AnyObject]()
	var bannerImage: String?
	override func viewDidLoad() {

		super.viewDidLoad()

		self.collectionView?.backgroundColor = UIColorRGB(230.0, g: 230.0, b: 230.0)
        self.collectionView?.bounces = true
		aboutUsArray = Helper.sharedClient.readPlist(forName: "AboutUs")
		meetTheExpertArray = Helper.sharedClient.readPlist(forName: "MeettheProviders")
		homeDecorIdeasArray = Helper.sharedClient.readPlist(forName: "HomeDecorIdeas")
		setupCollectionView()
		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: true, isHideFilterButton: true, isHidenotification: false, isHideMenuButton: false, animation: false)
		// let seconds = 2.0
		// let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
		// let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
		// dispatch_after(dispatchTime, dispatch_get_main_queue(), {
		// // here code perfomed with delay
		// let IdealistVC = otherStoryboard.instantiateViewControllerWithIdentifier(String(AddPortfolioViewController)) as! AddPortfolioViewController
		// //        NavigationHelper.helper.currentViewController = IdealistVC
		//
		// NavigationHelper.helper.contentNavController!.pushViewController(IdealistVC, animated: true)
		// })
//		self.getDashboard()
//		self.getIdeaListingList()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
        self.view.endEditing(true)
		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: true, isHideFilterButton: true, isHidenotification: false, isHideMenuButton: false)
		NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_DASHBOARD
		NavigationHelper.helper.tabBarViewController!.showTabBar()
		NavigationHelper.helper.tabBarViewController?.clearSelection(exceptIndex: 0)
        self.getDashboard()
        self.getIdeaListingList()
	}
	@IBAction func homeDecorIdeas(sender: UIButton) {

		let IdealistVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(IdeaListingController)) as! IdeaListingController
		// NavigationHelper.helper.currentViewController = IdealistVC

		NavigationHelper.helper.contentNavController!.pushViewController(IdealistVC, animated: true)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewDidLayoutSubviews() {

		super.viewDidLayoutSubviews()

	}
}

extension DashboardViewController {

	func setupCollectionView() {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		self.collectionView?.collectionViewLayout = layout
	}

	// MARK: UICollectionViewDataSource methods
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 4
	}

	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

		var cell: BaseCollectionViewCell?
		switch indexPath.row {
		case 0:
			cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(DashboardBannerCollectionViewCell), forIndexPath: indexPath) as! DashboardBannerCollectionViewCell
			cell?.datasource = bannerImage
		case 1:
			cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(DashboardHomeDecorIdeasCollectionViewCell), forIndexPath: indexPath) as! DashboardHomeDecorIdeasCollectionViewCell
			// (cell as! DashboardHomeDecorIdeasCollectionViewCell).dataSource = homeDecorIdeasArray!

			(cell as! DashboardHomeDecorIdeasCollectionViewCell).dataSource = arrIdeasList
			// (cell as! DashboardHomeDecorIdeasCollectionViewCell).arrIdeasDataList = arrIdeasList

		case 2:
			cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(DashboardMeetTheExpertCollectionViewCell), forIndexPath: indexPath) as! DashboardMeetTheExpertCollectionViewCell
			(cell as! DashboardMeetTheExpertCollectionViewCell).dataSource = meetTheExpertArray!
		case 3:
            
            
			cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(DashboardAboutUsCollectionViewCell), forIndexPath: indexPath) as! DashboardAboutUsCollectionViewCell
            
            (cell as! DashboardAboutUsCollectionViewCell).getIndexValue = { (indexValue) in
                print("IndexPath\(indexValue)")
                if indexValue == 2{
                    Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
                        if isLogin == true {
                            let uploadIdeasVC = otherStoryboard.instantiateViewControllerWithIdentifier(String(UploadIdeasTableViewController)) as! UploadIdeasTableViewController
                            NavigationHelper.helper.contentNavController!.pushViewController(uploadIdeasVC, animated: true)
                            }
                            
                        }
                    }
                }
                
            
			(cell as! DashboardAboutUsCollectionViewCell).dataSource = aboutUsArray!

		default:
			debugPrint("No cell")
		}
		return cell!
	}

	// MARK: UICollectionViewDelegateFlowLayout methods
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		switch indexPath.row {
		case 0:
			return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH / 3.0)
		case 1:
			return CGSizeMake(SCREEN_WIDTH, IS_IPAD() ? 330 : 200) // 250
		case 2:
			return CGSizeMake(SCREEN_WIDTH, IS_IPAD() ? 330 : 180)
		case 3:
			return CGSizeMake(SCREEN_WIDTH, IS_IPAD() ? 260 : 160)
			// return CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds) , 180)
		default:
			return CGSizeMake(SCREEN_WIDTH, IS_IPAD() ? 280 : 220)
		}
	}
}

extension DashboardViewController {
	// API Calling...
	func getIdeaListingList() {

		self.arrIdeasList.removeAll()
		APIHandler.handler.getIdeaListingList({ (response) in
			debugPrint("Idea List \(response))")
            let notificationCount = response["totalNotification"].intValue
            if notificationCount > 0{
                NavigationHelper.helper.headerViewController!.lblNotification.hidden = false
                   NavigationHelper.helper.headerViewController!.lblNotification.text = String(notificationCount)
            }else{
               NavigationHelper.helper.headerViewController!.lblNotification.hidden = true
            }

			for value in response["Idea"].arrayObject! {
				let idesListObj = IdeaListing(withDictionary: value as! [String: AnyObject])
				self.arrIdeasList.append(idesListObj)
			}
			self.collectionView!.reloadData()
		}) { (error) in
		}
	}

	func getDashboard() {
		APIHandler.handler.getDashboard({ (response) in
			self.bannerImage = response["Banner"]["image"].stringValue
			self.collectionView?.reloadData()
		}) { (error) in

		}
	}
}
