//
//  MeetAnExpertViewController.swift
//  Greenply
//
//  Created by Shatadru Datta on 29/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MeetAnExpertViewController: BaseTableViewController {
    
    var arrInfluencerList = [AnyObject]()
    var solutionType = ""
    var arrSearchList = [AnyObject]()
    var isSearch: Bool!
    var strVal = ""
    
    override func viewDidLoad() {
		super.viewDidLoad()
        isSearch = false
        NavigationHelper.helper.headerViewController?.textSearch.delegate = self
        if solutionType == "" {
            solutionType = "influencer"
        }
    self.tableView.reloadData()
		self.tableView.backgroundView = nil
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWithIdeas(isHideBackButton: false, isHideFilterButton: false, isHidenotification: false, isHideMenuButton: false, isHideSearchButton: false)
		//NavigationHelper.helper.headerViewController?.addHeaderButton(kFilterBttton)
		NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_MEET_EXPERT
		NavigationHelper.helper.tabBarViewController!.showTabBar()
		NavigationHelper.helper.tabBarViewController?.clearSelection(exceptIndex: 2)
		self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
        
	}
    
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
    
    override func viewDidAppear(animated: Bool) {
    
        self.getAllInfluencerList()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NavigationHelper.helper.headerViewController?.textSearch.resignFirstResponder()
        NavigationHelper.helper.headerViewController?.imgBorder.alpha = 0
        NavigationHelper.helper.headerViewController?.leadingImgBorder.constant = 130
        NavigationHelper.helper.headerViewController?.buttonSearch.selected = false
    }
}

extension MeetAnExpertViewController {

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch == true {
            return arrSearchList.count
        } else {
            return arrInfluencerList.count
        }
		
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCellWithIdentifier(String(MeetAnExpertTableViewCell), forIndexPath: indexPath) as! MeetAnExpertTableViewCell
        if isSearch == true {
            cell.datasource = self.arrSearchList[indexPath.row]
        } else {
            cell.datasource = self.arrInfluencerList[indexPath.row]
        }
        return cell
	}

	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return IS_IPAD() ? 165.0 : 132.0
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let meetanExpertDetailsVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(MeetAnExpertDetailsViewController)) as! MeetAnExpertDetailsViewController
        if isSearch == true {
            meetanExpertDetailsVC.objInfluencerDetails = self.arrSearchList[indexPath.row] as! Influencer
        } else {
            meetanExpertDetailsVC.objInfluencerDetails = self.arrInfluencerList[indexPath.row] as! Influencer
        }
		NavigationHelper.helper.contentNavController!.pushViewController(meetanExpertDetailsVC, animated: true)
	}
}

// API Call
extension MeetAnExpertViewController{
    // get Influencer List
    func getAllInfluencerList(){
        APIHandler.handler.getInfluencerList(foruser: solutionType, success:{ (response) in
            let notificationCount = response["totalNotification"].intValue
            if notificationCount > 0{
                NavigationHelper.helper.headerViewController!.lblNotification.hidden = false
                NavigationHelper.helper.headerViewController!.lblNotification.text = String(notificationCount)
            }else{
                NavigationHelper.helper.headerViewController!.lblNotification.hidden = true
            }
           // debugPrint("Influencer List == \(response)")
          self.arrInfluencerList.removeAll()
            for value in response["User"].arrayObject! {
                let objInfluencer = Influencer(withDictionary: value as! [String : AnyObject])
                self.arrInfluencerList.append(objInfluencer)
                }
            self.tableView.reloadData()
            
        }) { (error) in
          Toast.show(withMessage: NO_RECORDS_FOUND)
                       self.tableView.reloadData()
        }
    }
}

// MARK:- TextFieldDelegate & Search Method
extension MeetAnExpertViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        isSearch = true
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            strVal = String(strVal.characters.dropLast())
        } else {
            strVal = strVal + string
        }
        if strVal.isEmpty {
            isSearch = false
            self.tableView.reloadData()
        } else {
            isSearch = true
            self.filterContentForSearchText(strVal)
        }
        
        return true
    }
    
    func filterContentForSearchText(searchText:NSString)
    {
        
        arrSearchList = self.arrInfluencerList.filter { (obj) -> Bool in
            let objMeetanExpert = obj as! Influencer
            if objMeetanExpert.influencerUserName!.containsString(searchText as String) {
                return true
            } else {
                return false
            }
        }
        self.tableView.reloadData()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        isSearch = false
        textField.resignFirstResponder()
        return true
    }
}





