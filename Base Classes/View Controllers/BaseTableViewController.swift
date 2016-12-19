//
//  BaseTableViewController.swift
//  Greenply
//
//  Created by Rupam Mitra on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

	var backButtonEnabled: Bool = false
	var searchButtonEnabled: Bool = false
	var notificationButtonEnabled: Bool = false
	var filterButtonEnabled: Bool = false
	var menuButtonEnabled: Bool = false
	var crossButtonEnabled: Bool = false
	var barButtonArray = [UIBarButtonItem]()
	var filterButton = UIBarButtonItem()
	var xPosition = CGFloat()
	var backgroundImageView = UIImageView()
	override func viewDidLoad() {
		super.viewDidLoad()

		self.setNavigationBackButton()
		self.setBarButtonItems()
		// MARK:- initial UISetup for view.
		let backgroundImage = UIImage(named: "Background")
		backgroundImageView = UIImageView(image: backgroundImage)
		self.tableView.backgroundView = backgroundImageView
        NavigationHelper.helper.enableSideMenuSwipe = true

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func setNavigationBackButton() {

		if backButtonEnabled == true {
			self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "HeaderBack")!, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.actionBack))
		}
		else {
			self.navigationItem.setHidesBackButton(true, animated: true)

		}
	}

	func setBarButtonItems() {

		if menuButtonEnabled == true {
			let menuButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "MenuIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.actionMenu))
			barButtonArray.append(menuButton)
		}
		if notificationButtonEnabled == true {
			let notificationButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Notification"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.actionNotification))
			barButtonArray.append(notificationButton)
		}
		if filterButtonEnabled == true {
			let filterButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "FilterIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.actionFilter))
			barButtonArray.append(filterButton)
		}

		if searchButtonEnabled == true {
			let searchButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "HeaderSearch"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.actionSearch))
			barButtonArray.append(searchButton)
		}
		if crossButtonEnabled == true {
			let crossButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: #selector(self.crossButton))
			barButtonArray.append(crossButton)
		}

		self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
		navigationItem.rightBarButtonItems = barButtonArray
	}
	// MARK:- Crete NavigationTitle
	func setNavigationTitle(title: String)
	{
	

        let labelFrame = CGRect(x: 0, y: IS_IPAD() ? 0 :  -3, width: 190, height: IS_IPAD() ? 30 : 23)
     
		let labelTitle = UILabel(frame: labelFrame)

		labelTitle.text = title
		labelTitle.textColor = UIColor.whiteColor()
		labelTitle.textAlignment = NSTextAlignment.Left
        labelTitle.font = PRIMARY_FONT(IS_IPAD() ? 22 : 16)
        //labelTitle.font = PRIMARY_FONT(IS_IPAD() ? 22 : 16)
		let rectForView = CGRect(x: 0, y: 40, width: SCREEN_WIDTH - 75, height: IS_IPAD() ? 30 : 23)

		let viewForTitle = UIView(frame: rectForView)
		
		viewForTitle.addSubview(labelTitle)
   
		self.navigationItem.titleView = viewForTitle

	}
	// MARK: - Nav Bar Button Action
	func actionBack() {
		self.navigationController?.popViewControllerAnimated(true)
	}
	func actionSearch() {
		debugPrint("Search")
	}
	func actionFilter() {
		debugPrint("Filter")
	}
	func actionMenu() {
		debugPrint("menu")
        NavigationHelper.helper.openSidePanel(true)
//		self.slideMenuController()?.openRight()
	}
	func actionNotification() {
		debugPrint("Notification")
		self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
	}
	func crossButton() {
		debugPrint("corssActon")
		self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
	}

}

extension BaseTableViewController
{ // MARK: UITableViewDelegate methods
	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		cell.backgroundColor = UIColor.clearColor()
	}
}
