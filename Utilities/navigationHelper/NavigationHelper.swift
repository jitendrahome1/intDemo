//
//  MenuViewController.swift
//  Greenply
//
//  Created by Jitendra on 9/9/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class NavigationHelper: NSObject {

	static let helper = NavigationHelper()
	var currentViewController: UIViewController? {
		return contentNavController?.viewControllers.last!
	}
	var navController: UINavigationController!
	var headerViewController: HeaderViewController?
	var tabBarViewController: TabBarViewController?
	var contentNavController: ContentNavigationViewController?
	var mainContainerViewController: MainContainerViewController?
	var menuView = UIView()
	var menuWidth: CGFloat?
	var blurLayer: UIView?
	var isOpen = false

	var enableSideMenuSwipe = true// Make it false in view will appear to disable swipr to open menu feature

	var didOpen: ((open: Bool) -> ())?
    var reloadData: (() -> ())?

	private override init() {
	}

	internal func navigateToViewController(isSpeciality: Bool, index: Int) {
		navController.popViewControllerAnimated(true)
	}
}

extension NavigationHelper {

	func setUpSideMenu(view: UIView, blurView: UIView, menuWidth: CGFloat) {
        menuView = view
        blurLayer = blurView
        self.menuWidth = menuWidth
        view.translatesAutoresizingMaskIntoConstraints = true
        view.frame = CGRectMake(CGRectGetWidth(navController.view.bounds), 64, CGRectGetWidth(self.menuView.bounds), CGRectGetHeight(navController.view.bounds) - 64)
        navController.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(NavigationHelper.panDidMoved(_:))))
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NavigationHelper.didTap(_:))))
	}

    func reloadMenu() {
        if (reloadData != nil) {
            reloadData!()
        }
    }
    
	func openSidePanel(open: Bool) {
        NavigationHelper.helper.mainContainerViewController?.view.bringSubviewToFront(blurLayer!)
        NavigationHelper.helper.mainContainerViewController?.view.bringSubviewToFront(menuView)
		if open {
            
			UIView.animateWithDuration(0.3, animations: {
				self.blurLayer?.alpha = 0.5
				self.menuView.frame = CGRectMake(CGRectGetWidth(self.navController.view.bounds) - self.menuWidth!, 64, CGRectGetWidth(self.menuView.bounds), CGRectGetHeight(self.menuView.bounds))
				}, completion: { (completed) in
				if self.didOpen != nil && !self.isOpen {
					self.didOpen!(open: true)
				}
				self.isOpen = true
			})
		} else {

			UIView.animateWithDuration(0.3, animations: {
				self.blurLayer?.alpha = 0
				self.menuView.frame = CGRectMake(CGRectGetWidth(self.navController.view.bounds), 64, CGRectGetWidth(self.menuView.bounds), CGRectGetHeight(self.menuView.bounds))
				}, completion: { (completed) in
				if self.didOpen != nil && self.isOpen {
					self.didOpen!(open: false)
				}
				self.isOpen = false
			})
		}
	}

	func panDidMoved(gesture: UIPanGestureRecognizer) {

		if enableSideMenuSwipe {
			let translationInView = gesture.translationInView(navController.view)

			switch gesture.state {
			case .Began:
                NavigationHelper.helper.mainContainerViewController?.view.bringSubviewToFront(blurLayer!)
                NavigationHelper.helper.mainContainerViewController?.view.bringSubviewToFront(menuView)
			case .Changed:

				let movingx = menuView.center.x + translationInView.x;

				if ((navController.view.frame.width - movingx) > -self.menuWidth! / 2 && (navController.view.frame.width - movingx) < self.menuWidth! / 2) {

					menuView.center = CGPointMake(movingx, menuView.center.y);
					gesture.setTranslation(CGPointMake(0, 0), inView: navController.view)
					let changingAlpha = 0.5 / menuWidth! * (navController.view.frame.width - movingx) + 0.5 / 2; // y=mx+c
					blurLayer?.alpha = changingAlpha
				}
			case .Ended:
				if (menuView.center.x > navController.view.frame.width) {
					openSidePanel(false)
				} else if (menuView.center.x < navController.view.frame.width) {
					openSidePanel(true)
				}
			default: break
			}
		}
	}

	func didTap(gesture: UITapGestureRecognizer) {
		openSidePanel(false)
	}
}