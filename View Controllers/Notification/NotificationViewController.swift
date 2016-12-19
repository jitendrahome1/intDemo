//
//  NotificationViewController.swift
//  Greenply
//
//  Created by Jitendra on 8/30/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class NotificationViewController: BaseTableViewController {

    @IBOutlet weak var tblNotification: UITableView!
    var arrNotificationList = [AnyObject]()
    override func viewDidLoad() {
		
        super.viewDidLoad()
        self.initialUISetup()
		// Do any additional setup after loading the view.
       
	}
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton:false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
        NavigationHelper.helper.tabBarViewController!.hideTabBar()
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text =  TITLE_NOTIFICATION
    }
    
    
    override func viewDidAppear(animated: Bool) {
   
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
   
    
  

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
        
        self.tableView.layoutIfNeeded()
      
    }
 
    
    // MARK:- initial setup
    func initialUISetup()
   {
   
       self.backgroundImageView.image = UIImage(named: "BackgroundImage.png")
       self.tableView.estimatedRowHeight = 122
       self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
       self.tableView.rowHeight = UITableViewAutomaticDimension;
       APIHandler.handler.getNotifications({ (response) in
       self.arrNotificationList.removeAll()
       if response["notifications"].count > 0 {
            for value in response["notifications"].arrayObject! {
                let objNotification = Notification(withDictionary: value as! [String : AnyObject])
                self.arrNotificationList.append(objNotification)
            }
        }
        self.tableView.reloadData()

    }) { (error) in
        
    }

    }
}

extension NotificationViewController {
    
    // MARK: UITableViewDataSource methods
     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNotificationList.count
    }
    
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: NotificationCell = tableView.dequeueReusableCellWithIdentifier(String(NotificationCell)) as! NotificationCell
        cell.datasource = self.arrNotificationList[indexPath.row]
        return cell
    }
    
    // MARK: UITableViewDelegate methods
     override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }

}
