//
//  FollowersViewController.swift
//  Greenply
//
//  Created by Shatadru Datta on 31/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class FollowersViewController: BaseTableViewController {

	var showFlowerBtn = Bool()
	var titleText: String?

	var arrayDataSource = [AnyObject]()
    var arrIdeaImagesList = [AnyObject]()
    override func viewDidLoad() {
		super.viewDidLoad()
		self.backgroundImageView.image = UIImage(named: "BackgroundImage")
		self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = titleText
		NavigationHelper.helper.tabBarViewController!.hideTabBar()
		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
        self.getFollowersAndFollowingsList()
	}
}

extension FollowersViewController {

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return arrayDataSource.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCellWithIdentifier(String(FollowersTableViewCell), forIndexPath: indexPath) as! FollowersTableViewCell
		
        if showFlowerBtn == true {
			cell.buttonUnfollow.hidden = true
		}
		else {
			cell.buttonUnfollow.hidden = false
		}
		cell.datasource = arrayDataSource[indexPath.row]
		cell.actionUnfollowHandler = { (followerID) in
			self.unfollow(followerID)
		}
		return cell
	}

	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

		if let cell = cell as? FollowersTableViewCell {
			cell.backgroundColor = UIColor.clearColor()
		}
	}

	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return IS_IPAD() ? 200 : 157
	}
}

extension FollowersViewController {

	func unfollow(followerID: Int) {
		APIHandler.handler.unFollow(forUnfollowrID: followerID, success: { (response) in
			self.getFollowersAndFollowingsList()
		}) { (error) in

		}
	}

	func getFollowersAndFollowingsList() {
		APIHandler.handler.getFollowersAndFollowingList({ (response) in
              self.arrayDataSource.removeAll()
            if self.titleText == TITLE_FOLLOWERS {
                 let arrfollower = response["follower"].arrayObject!
                if arrfollower.count > 0{
                    for dictfollower in arrfollower {
                        let dict:[String: AnyObject]  = dictfollower as! [String: AnyObject]
                        self.arrayDataSource.append(dict)
                    }
                }
                else{
                  Toast.show(withMessage: NO_RECORDS_FOUND)
                }
                
               
				
			} else {
          
                let arrFollowing = response["following"].arrayObject!
                
                if arrFollowing.count > 0{
                    for dictFollowing in arrFollowing {
                        let dict:[String: AnyObject]  = dictFollowing as! [String: AnyObject]
                        
                        self.arrayDataSource.append(dict)
                    }
                }
                else{
                    Toast.show(withMessage: NO_RECORDS_FOUND)
                }
               
                
            }
			 self.tableView.reloadData() 
		}) { (error) in

		}
	}

}
