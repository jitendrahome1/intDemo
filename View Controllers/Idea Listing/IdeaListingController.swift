//
//  IdeaListingController.swift
//  Greenply
//
//  Created by Shatadru Datta on 30/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
enum eButtonEdit {
	case eButtonShow
	case eButtonHide
}
enum eIdeaListAPI {
	case eCallIdeaListApi
	case eNotCallIdeaListApi
}
enum eIdeaListTitle {
	case eIdeaListingTitle
	case eMyIdeaTitle
}
class IdeaListingController: BaseViewController, HeaderButtonDeleagte {
	var eButtonEditStatus: eButtonEdit = .eButtonHide
	var eIdeaListApiCallStatus: eIdeaListAPI = .eCallIdeaListApi
	var eIdeaListingTitleStaus: eIdeaListTitle = .eIdeaListingTitle
	@IBOutlet weak var collectionViewIdeasList: UICollectionView!
	var arrIdeasList = [AnyObject]()
    var arrSearchList = [AnyObject]()
    var isSearch: Bool!
    var strVal = ""
	override func viewDidLoad() {
		super.viewDidLoad()
        isSearch = false
		NavigationHelper.helper.headerViewController?.delegateButton = self
      
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	override func viewWillAppear(animated: Bool) {

		super.viewWillAppear(animated)
  NavigationHelper.helper.headerViewController?.textSearch.delegate = self
		if self.eIdeaListingTitleStaus == .eIdeaListingTitle {
			NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_IDEA_LISTING
		}
		else {
			NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_MY_Idea

		}
		if self.eButtonEditStatus == .eButtonHide {
            NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWithIdeas(isHideBackButton: false, isHideFilterButton: false, isHidenotification: false, isHideMenuButton: false, isHideSearchButton: false)
			NavigationHelper.helper.tabBarViewController!.showTabBar()
			self.getIdeaListingList()
		}
		else if self.eButtonEditStatus == .eButtonShow {
            NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWithIdeas(isHideBackButton: false, isHideFilterButton: true, isHidenotification: false, isHideMenuButton: false, isHideSearchButton: false)
			NavigationHelper.helper.headerViewController?.addHeaderButton(kPluseButton)
			NavigationHelper.helper.tabBarViewController!.hideTabBar()
			self.getMyIdeaList(forUserID: Globals.sharedClient.userID)
		}

		if self.eIdeaListApiCallStatus == .eNotCallIdeaListApi {
			// not call api/

			self.collectionViewIdeasList.reloadData()
		}
       NavigationHelper.helper.tabBarViewController?.clearSelection(exceptIndex: 1)
       // NavigationHelper.helper.tabBarViewController?.clearAllBtn()

	}
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NavigationHelper.helper.headerViewController?.textSearch.resignFirstResponder()
        NavigationHelper.helper.headerViewController?.imgBorder.alpha = 0
        NavigationHelper.helper.headerViewController?.leadingImgBorder.constant = 130
        NavigationHelper.helper.headerViewController?.buttonSearch.selected = false
    }
    
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		// NavigationHelper.helper.tabBarViewController.unSelectedAllButton()
		// NavigationHelper.helper.tabBarViewController.buttonIdea.selected = true

	}
}

extension IdeaListingController: UICollectionViewDataSource, UICollectionViewDelegate {

	func setupCollectionView() {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = IS_IPAD() ? 20.0 : 10.0
		collectionViewIdeasList.collectionViewLayout = layout
	}

	// MARK: UICollectionViewDataSource methods
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearch == true {
            return arrSearchList.count
        } else {
            return arrIdeasList.count
        }
		
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(IdeasListCollectionViewCell), forIndexPath: indexPath) as! IdeasListCollectionViewCell
		if eButtonEditStatus == .eButtonHide {
			cell.buttonEdit.hidden = true
		}
		else if eButtonEditStatus == .eButtonShow {
			cell.buttonEdit.hidden = false
			cell.editButtonHandler = { (ideaID) in
				self.pushUploadIdeaVCWith(forIdeaID: ideaID)
			}
		}

		if arrIdeasList.count > 0 {
            if isSearch == true {
                cell.datasource = arrSearchList[indexPath.row]
            } else {
                cell.datasource = arrIdeasList[indexPath.row]
            }
			
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

		let cell = collectionView.cellForItemAtIndexPath(indexPath) as! IdeasListCollectionViewCell
		let IdeaDetailsVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(IdeasDetailsController)) as! IdeasDetailsController
        if eButtonEditStatus == .eButtonShow
        {
            IdeaDetailsVC.isCommentBtnShowHide = false
            
        }
     
		let objIdeaList = cell.datasource
		IdeaDetailsVC.ideaDetailsObj = objIdeaList as! IdeaListing

		NavigationHelper.helper.contentNavController!.pushViewController(IdeaDetailsVC, animated: true)
	}
}

// MARK:- Function.
extension IdeaListingController {
	// Push to UploadIdeasTableViewController Function.
	func pushUploadIdeaVCWith(forIdeaID pIdeaID: Int?) {
		let uploadIdeasVC = otherStoryboard.instantiateViewControllerWithIdentifier(String(UploadIdeasTableViewController)) as! UploadIdeasTableViewController
		uploadIdeasVC.eUloadIdeaStatus = .eIdeaDetails
		debugPrint("IdeaID \(pIdeaID!)")
		uploadIdeasVC.IdeaID = pIdeaID!
		NavigationHelper.helper.contentNavController!.pushViewController(uploadIdeasVC, animated: true)
	}
}

//MARK:- API Calling
extension IdeaListingController {
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
			self.collectionViewIdeasList.reloadData()
		}) { (error) in
		}
	}

	// Mark:- Get Idea List With UserID,
	func getMyIdeaList(forUserID userID: Int?) {
		self.arrIdeasList.removeAll()
		APIHandler.handler.getIdeaListingWithUserID(forUserID: userID!, success: { (response) in

            let notificationCount = response["totalNotification"].intValue
            if notificationCount > 0{
                NavigationHelper.helper.headerViewController!.lblNotification.hidden = false
                NavigationHelper.helper.headerViewController!.lblNotification.text = String(notificationCount)
            }else{
                NavigationHelper.helper.headerViewController!.lblNotification.hidden = true
            }
			if response["Idea"].arrayObject?.count > 0 {

				for value in response["Idea"].arrayObject! {
					let idesListObj = IdeaListing(withDictionary: value as! [String: AnyObject])
					self.arrIdeasList.append(idesListObj)
				}
				debugPrint("Portfolio Details==>\(self.arrIdeasList)")
			}
			else {
				Toast.show(withMessage: NO_RECORDS_FOUND)
			}
			self.collectionViewIdeasList.reloadData()
		}) { (error) in

		}
	}
}

// MARK:- Header Button Delegate
extension IdeaListingController {
	func didTapMenuButton(strButtonType: String) {
		if strButtonType == kPluseButton {
			let uploadIdeasVC = otherStoryboard.instantiateViewControllerWithIdentifier(String(UploadIdeasTableViewController)) as! UploadIdeasTableViewController
			uploadIdeasVC.eUloadIdeaStatus = .eUploadIdea
			NavigationHelper.helper.contentNavController!.pushViewController(uploadIdeasVC, animated: true)
		} else {

		}
	}
}

// MARK:- TextFieldDelegate & Search Method
extension IdeaListingController: UITextFieldDelegate {
    
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
            self.collectionViewIdeasList.reloadData()
        } else {
            isSearch = true
            self.filterContentForSearchText(strVal)
        }
        
        return true
    }
    
    func filterContentForSearchText(searchText:NSString)
    {
        
        arrSearchList = self.arrIdeasList.filter { (obj) -> Bool in
            let objIdeaListing = obj as! IdeaListing
            if (objIdeaListing.ideaName!.lowercaseString.containsString(searchText.lowercaseString as String)) {
                return true
            } else {
                return false
            }
        }
   
        self.collectionViewIdeasList.reloadData()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        isSearch = false
        textField.resignFirstResponder()
        return true
    }
}


