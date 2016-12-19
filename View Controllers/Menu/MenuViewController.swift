//
//  MenuViewController.swift
//  Greenply
//
//  Created by Jitendra on 9/8/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController {

	@IBOutlet weak var tableMenu: UITableView!
	var userType = String()
	var arrMenu = [AnyObject]()
	var arrMenuImage = [UIImage]()
	var viewControllerClass: AnyClass!
	var viewControllerTitle: String!
	var arrayMenuForAnimation = [AnyObject]()
	var isClosed = true
	var menuName: String!

	override func viewDidLoad() {
		super.viewDidLoad()
		self.loadMenuSetup()
	
		NavigationHelper.helper.reloadData = {
			self.loadMenuSetup()
			self.tableMenu.reloadData()
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.

	}

	func loadMenuSetup()
	{
		// Mark: User Login OR Not
		if arrMenu.count > 0 {
			arrMenu.removeAll()
		}
		// NOTE: - When user Become Influencer open influencer Plist

		// menuName = INTEGER_FOR_KEY(kUserID) != 0 ? "influencer" : "user"
        
        if INTEGER_FOR_KEY(kUserID) != 0{
            
        let userStatus = OBJ_FOR_KEY(kUserTypeStatus)?.integerValue
            if userStatus == 1{
               menuName = "influencer"
            }else{
               menuName = "user"
            }
           
        }
        else{
         menuName = "Guest"
        }

		//menuName = INTEGER_FOR_KEY(kUserID) != 0 ? "user" : "Guest"

		if let path = NSBundle.mainBundle().pathForResource(menuName, ofType: "plist") {
			let items: NSArray = NSArray(contentsOfFile: path)!
			for item in items {
				arrMenu.append(item)

			}
		}

	}

	// MARK: TableView Delegate and DataSource
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return arrMenu.count
	}

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return IS_IPAD() ? 80 : 45
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

		let cell: MenuCell = tableView.dequeueReusableCellWithIdentifier(String(MenuCell)) as! MenuCell
		cell.labelMenuTitle.text = arrMenu[indexPath.row]["name"] as? String
		cell.imgMenu?.image = UIImage(named: (arrMenu[indexPath.row]["image"] as? String)!)
		cell.backgroundColor = UIColor.clearColor()
		return cell
	}
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

		viewControllerClass = NSClassFromString(SWIFT_CLASS_STRING(arrMenu[indexPath.row]["Class"]! as! String)!)
		viewControllerTitle = arrMenu[indexPath.row]["name"]! as! String
		openStoryboard(arrMenu[indexPath.row]["storyboard"] as? String)

	}
	// func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
	// cell.contentView.alpha = 0;
	//
	// UIView.animateWithDuration(0.2, delay: Double(indexPath.row) * 0.1, options: [.TransitionFlipFromTop], animations: {
	// cell.contentView.alpha = 1.0;
	// }, completion: nil)
	// }
	func openStoryboard(isMainStoryboard: String?) {

		// self.slideMenuController()?.closeRight()

		guard viewControllerClass != nil else {
			let alert = UIAlertController(title: "GreenPly", message: "Under Construction...", preferredStyle: UIAlertControllerStyle.Alert)
			alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
			self.presentViewController(alert, animated: true, completion: nil)
			return
		}

		NavigationHelper.helper.openSidePanel(false)

		if !NavigationHelper.helper.currentViewController!.isKindOfClass(viewControllerClass) {
			if NavigationHelper.helper.contentNavController!.viewControllers.containsObject(viewControllerClass).isPresent {
				if String(viewControllerClass) != String(DashboardViewController) {
					NavigationHelper.helper.contentNavController!.viewControllers.removeAtIndex(NavigationHelper.helper.contentNavController!.viewControllers.containsObject(viewControllerClass).index)
				}
			}
			if isMainStoryboard! == "Main"
			{
				self.navigateToViewController(mainStoryboard.instantiateViewControllerWithIdentifier(String(viewControllerClass)))
			}
			else if isMainStoryboard! == "Other" {
				self.navigateToViewController(otherStoryboard.instantiateViewControllerWithIdentifier(String(viewControllerClass)))
			}
			else if isMainStoryboard! == "Login" {
				self.navigateToViewController(loginStoryboard.instantiateViewControllerWithIdentifier(String(viewControllerClass)))
			}

			else if isMainStoryboard! == "Logout" {
				self.presentViewController(UIAlertController.showStandardAlertWith(kAppTitle, alertText: WANT_TO_LOGOUT, positiveButtonText: TEXT_YES, negativeButtonText: TEXT_NO, selected_: { (index) in
					if index == 1 {

						REMOVE_OBJ_FOR_KEY(kUserID)
						REMOVE_OBJ_FOR_KEY(kToken)
						REMOVE_OBJ_FOR_KEY(kUserName)
                        REMOVE_OBJ_FOR_KEY(kUserEmail)
						REMOVE_OBJ_FOR_KEY(kUserType)
                        REMOVE_OBJ_FOR_KEY(kUserAddress)
                        REMOVE_OBJ_FOR_KEY(kUserContactNumber)
                         REMOVE_OBJ_FOR_KEY(kUserAboutUS)
						APIManager.manager.header.removeValueForKey("access-token")
						NavigationHelper.helper.reloadMenu()

						if NavigationHelper.helper.currentViewController!.isKindOfClass(DashboardViewController) {
                               NavigationHelper.helper.headerViewController!.nsConstNotificationWidth.constant = 0.0
                             NavigationHelper.helper.headerViewController?.lblNotification.hidden = true
							NavigationHelper.helper.contentNavController!.popToRootViewControllerAnimated(true)
						}
						else
						{
                            NavigationHelper.helper.headerViewController?.lblNotification.hidden = true
                            NavigationHelper.helper.headerViewController!.nsConstNotificationWidth.constant = 0.0
							NavigationHelper.helper.contentNavController!.popToRootViewControllerAnimated(true)
						}

					}
					}), animated: true, completion: nil)

			}

			else {
				self.presentViewController(UIAlertController.showStandardAlertWith(kAppTitle, alertText: "Work in Progress...", selected_: { (index) in

					}), animated: true, completion: nil)
			}
		}
	}

    
	func navigateToViewController(viewController: UIViewController) {

		if viewController.isKindOfClass(LoginViewController)
		{
			let loginControllerNavigation = loginStoryboard.instantiateViewControllerWithIdentifier("LoginNavigationalController") as! UINavigationController
			self.presentViewController(loginControllerNavigation, animated: true, completion: nil)
		}
		else if viewController.isKindOfClass(DashboardViewController) {
			NavigationHelper.helper.contentNavController!.popToRootViewControllerAnimated(true)
		}
        else if viewController.isKindOfClass(ProfileViewController) {
            let userStatus = OBJ_FOR_KEY(kUserTypeStatus)?.integerValue
            if userStatus == 1{
                let influncerProfileVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(InfluencerProfileViewController)) as! InfluencerProfileViewController
                NavigationHelper.helper.contentNavController!.pushViewController(influncerProfileVC, animated: true)
            }else{
                let profileVC = otherStoryboard.instantiateViewControllerWithIdentifier(String(ProfileViewController)) as!ProfileViewController
                NavigationHelper.helper.contentNavController!.pushViewController(profileVC, animated: true)
            }
        }
       else if viewController.isKindOfClass(BecomeInfluencerViewController) {
            if OBJ_FOR_KEY(kUserTypeStatus)!.integerValue == 500 {
               let becomeInfluencerNavigation = mainStoryboard.instantiateViewControllerWithIdentifier("BecomeInfluencerViewController") as! BecomeInfluencerViewController
             NavigationHelper.helper.contentNavController!.pushViewController(becomeInfluencerNavigation, animated: true)
           } else {
               let alert = UIAlertController(title: ALERT_TITLE, message: INFLUENCER_VERIFICATION, preferredStyle: UIAlertControllerStyle.Alert)
               alert.addAction(UIAlertAction(title: OK, style: UIAlertActionStyle.Default, handler: nil))
               self.presentViewController(alert, animated: true, completion: nil)
            }
        }
		else
		{
			NavigationHelper.helper.navController = NavigationHelper.helper.contentNavController! as UINavigationController
			// NavigationHelper.helper.currentViewController = viewController
			// NavigationHelper.helper.navigationController.pushViewController(viewController, animated: true)

			NavigationHelper.helper.contentNavController!.pushViewController(viewController, animated: true)
		}
	}

    
	func insertRow(forIndex index: Int) {
		guard !isClosed else {
			return
		}
		arrayMenuForAnimation.append(arrMenu[index])
		tableMenu.insertRowsAtIndexPaths([NSIndexPath.init(forRow: index, inSection: 0)], withRowAnimation: .Top)
		let seconds = 0.2
		let delay = seconds * Double(NSEC_PER_SEC) // nanoseconds per seconds
		let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))

		dispatch_after(dispatchTime, dispatch_get_main_queue(), {
			// here code perfomed with delay
			if index + 1 != self.arrMenu.count {
				self.insertRow(forIndex: index + 1)
			}
		})
	}
}

