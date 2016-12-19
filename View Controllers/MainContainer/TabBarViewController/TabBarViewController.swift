//
//  MenuViewController.swift
//  Greenply
//
//  Created by Jitendra on 9/9/16.
//  Copyright © 2016 Indus Net. All rights reserved.
///

import UIKit

class TabBarViewController: UIViewController {

	@IBOutlet var buttonTabCollection: [TabButton]!
	var lastIndex: Int = 0
	override func viewDidLoad() {
		super.viewDidLoad()
		NavigationHelper.helper.tabBarViewController = self
//		NavigationHelper.helper.tabBarViewController = self

		for (index, button) in buttonTabCollection.enumerate() {
			button.didTap = {
				button.selected = true
				if index != 3 {
					self.clearSelection(exceptIndex: index)
				} else {
					button.selected = false
				}
				self.moveToViewController(index)
			}
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func clearSelection(exceptIndex exceptionIndex: Int?) {
		for (index, button) in self.buttonTabCollection.enumerate() {

			if index != exceptionIndex {

				button.selected = false

			}

			else {
				button.selected = true
				self.lastIndex = exceptionIndex!
			}
		}

	}

	func showTabBar() {
		NavigationHelper.helper.mainContainerViewController!.nsBtottomConstTabBar.constant = 0
		NavigationHelper.helper.mainContainerViewController!.view.layoutIfNeeded()
//		NavigationHelper.helper.mainContainerViewController?.tabBarControllerView.transform = CGAffineTransformIdentity
	}
	func hideTabBar() {
		NavigationHelper.helper.mainContainerViewController!.nsBtottomConstTabBar.constant = -(NavigationHelper.helper.mainContainerViewController!.NSConstantTapBarHeight.constant)
		NavigationHelper.helper.mainContainerViewController!.view.layoutIfNeeded()
//		NavigationHelper.helper.mainContainerViewController?.mainContainer.translatesAutoresizingMaskIntoConstraints = true
//		NavigationHelper.helper.mainContainerViewController?.tabBarControllerView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(NavigationHelper.helper.mainContainerViewController!.tabBarControllerView.frame))
	}

	// MARK: Move To ViewController Function
	func moveToViewController(index: Int) {
        NavigationHelper.helper.headerViewController?.hideUnhideSearch()
		switch index {
		case 0:
			if NavigationHelper.helper.contentNavController!.viewControllers.containsObject(DashboardViewController).isPresent {
				NavigationHelper.helper.contentNavController!.popToRootViewControllerAnimated(true)
			}
			else {
				let dashboardVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(DashboardViewController)) as!DashboardViewController
				NavigationHelper.helper.contentNavController!.pushViewController(dashboardVC, animated: true)

			}
			self.lastIndex = index
		case 1:

			let ideaListingVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(IdeaListingController)) as!IdeaListingController

			if !NavigationHelper.helper.contentNavController!.viewControllers.containsObject(IdeaListingController).isPresent {

				NavigationHelper.helper.contentNavController!.pushViewController(ideaListingVC, animated: true)

			}
			else {

				let allViewController: [UIViewController] = NavigationHelper.helper.contentNavController!.viewControllers as [UIViewController]

				for aviewcontroller: UIViewController in allViewController
				{
					if aviewcontroller.isKindOfClass(IdeaListingController)
					{
						// self.navigationController?.popToViewController(aviewcontroller, animated: true)

						NavigationHelper.helper.contentNavController!.popToViewController(aviewcontroller, animated: true)
					}
				}

			}
			self.lastIndex = index
		case 2:
			let meetExpertVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(MeetAnExpertViewController)) as!MeetAnExpertViewController
			if !NavigationHelper.helper.contentNavController!.viewControllers.containsObject(MeetAnExpertViewController).isPresent {

				NavigationHelper.helper.contentNavController!.pushViewController(meetExpertVC, animated: true)
			}
			else {
				let allViewController: [UIViewController] = NavigationHelper.helper.contentNavController!.viewControllers as [UIViewController]

				for aviewcontroller: UIViewController in allViewController
				{
					if aviewcontroller.isKindOfClass(MeetAnExpertViewController)
					{
						// self.navigationController?.popToViewController(aviewcontroller, animated: true)

						NavigationHelper.helper.contentNavController!.popToViewController(aviewcontroller, animated: true)
					}
				}

			}
			self.lastIndex = index
		case 3:
			if INTEGER_FOR_KEY(kUserID) != 0 {
                let userStatus = OBJ_FOR_KEY(kUserTypeStatus)?.integerValue
                if userStatus == 1{
                    let influncerProfileVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(InfluencerProfileViewController)) as! InfluencerProfileViewController
                    NavigationHelper.helper.contentNavController!.pushViewController(influncerProfileVC, animated: true)
                }else
                {
				let profileVC = otherStoryboard.instantiateViewControllerWithIdentifier(String(ProfileViewController)) as!ProfileViewController
				NavigationHelper.helper.contentNavController!.pushViewController(profileVC, animated: true)
                }
				self.lastIndex = index
			}
			else {
				self.presentViewController(UIAlertController.showStandardAlertWith(kAppTitle, alertText: WANT_TO_LOGIN, positiveButtonText: TEXT_YES, negativeButtonText: TEXT_NO, selected_: { (index) in
					if index == 1 {
						let loginControllerNavigation = loginStoryboard.instantiateViewControllerWithIdentifier("LoginNavigationalController") as! UINavigationController
						self.presentViewController(loginControllerNavigation, animated: true, completion: nil)
					} else {
						self.clearSelection(exceptIndex: self.lastIndex)
					}
					}), animated: true, completion: nil)
			}
		default:
			debugPrint("No Selction")
		}
	}

}
