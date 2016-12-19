//
//  MenuViewController.swift
//  Greenply
//
//  Created by Jitendra on 9/9/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MainContainerViewController: UIViewController {

    @IBOutlet weak var nsBtottomConstTabBar: NSLayoutConstraint!
    @IBOutlet weak var tabBarControllerView: UIView!
    @IBOutlet var NSConstantTapBarHeight: NSLayoutConstraint!
	@IBOutlet weak var mainContainer: UIView!
	@IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var menuContainer: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var menuViewWidthConstrain: NSLayoutConstraint!
	override func viewDidLoad() {
		super.viewDidLoad()
		NavigationHelper.helper.mainContainerViewController = self
        
        menuContainer.translatesAutoresizingMaskIntoConstraints = true
        menuContainer.frame = CGRectMake(CGRectGetWidth(self.view.bounds) * 0.3, 64, CGRectGetWidth(self.view.bounds) * 0.7, CGRectGetHeight(self.view.bounds) - 64)
        NavigationHelper.helper.setUpSideMenu(menuContainer, blurView: blurView, menuWidth: CGRectGetWidth(self.view.bounds) * 0.7)
//        NavigationHelper.helper.headerViewController.labelHeaderTitle.font =  UIFont(name: "Arial", size: 40)
        
    
     //   debugPrint("font size \(NavigationHelper.helper.headerViewController.labelHeaderTitle.font)")
        
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - Navigation

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

		if sender?.identifier == "ContentHeaderBarEmbedSegue"
		{
			NavigationHelper.helper.headerViewController = (sender?.destinationViewController as? HeaderViewController)!

		}

		else if (segue.identifier == "MainNavigationController")
		{

		}
		else if (segue.identifier == "ContentTabrBarEmbedSegue")
		{

		}

	}
	// MARK:- Show And Hide Tab Bar.
	func showHideTabBar(isTabBarHide: Bool)
	{
        if isTabBarHide == true
        {
            NavigationHelper.helper.mainContainerViewController!.tabBarView.hidden = true
            var hight = CGFloat()
            hight = NavigationHelper.helper.mainContainerViewController!.mainContainer.frame.height + NavigationHelper.helper.mainContainerViewController!.tabBarView.frame.height
            NavigationHelper.helper.mainContainerViewController!.mainContainer.frame.size.height = hight
            
        }
        else
        {
            NavigationHelper.helper.mainContainerViewController!.tabBarView.hidden = false
        }

	}
    

}

  


