//
//  AddPortfolioViewController.swift
//  Greenply
//
//  Created by Jitendra on 8/31/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
import SwiftyJSON
enum eUploadProject {
	case eUploadProject
	case eProjectDetails
}
class AddPortfolioViewController: BaseTableViewController, HeaderButtonDeleagte {
	var projectID: Int?
	var arrayTableList = [AnyObject]()
	var arrayAttributeIDs = [String]()
	var arrayDropDownOptions = [[AnyObject]]()
	var arrTAges = [AnyObject]()
	var arrTagsResult = [AnyObject]()
	var list = [String]()
	var arrAllTagsID = [AnyObject]()
	var selectedIndexPath: NSIndexPath?
	var projTypeId: String?
	var styleTypeId: String?
	var workTypeId: String?
	var projBudgetId: String?
	var eProjectStatus: eUploadProject = .eUploadProject
	var isSearch: Bool?
	var pickedImage: NSData?
	var arrImagesData = [AnyObject]()
	var strProjectName: String?
	var strProjectDisc: String?
	var isAddTags: Bool?
    var arrTagsNameList = [AnyObject]()
    var arrEditImageID = [AnyObject]()
    var imageArray = [AnyObject]()
    
    var arrRoomType = [AnyObject]()
	override func viewDidLoad() {
		super.viewDidLoad()
       NavigationHelper.helper.headerViewController?.delegateButton = self
		isAddTags = true
		arrayTableList = Helper.sharedClient.readPlist(forName: "AddPortfolioList")
		self.tableView.reloadData()

		if eProjectStatus == .eUploadProject {
			getAttributes()
			setUpArrayDropDownOption()
		}
		else if eProjectStatus == .eProjectDetails {

			self.getPortFolioDetailsWith(forPortfolioID: projectID!)

		}
		// NavigationHelper.helper.headerViewController?.delegateButton = self
		self.backgroundImageView.image = UIImage(named: "BackgroundImage")
		self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_PROJECT
		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
		NavigationHelper.helper.headerViewController?.addHeaderButton(KHeaderTickButton)
		NavigationHelper.helper.tabBarViewController?.hideTabBar()
	}

   
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func buttonClicked(sender: HeaderButton!) {

		self.tableView.endEditing(true)

		var dict: [String: AnyObject] = self.arrayTableList[sender.section!] as! [String: AnyObject]
		var dictArray: [AnyObject] = dict["arrayList"] as! [AnyObject]
		if dictArray.count > 0 {
			let arrayTemp = dictArray
			dictArray.removeAll()
			dict["arrayList"] = dictArray
			self.arrayTableList[sender.section!] = dict
			if arrayTemp.count > 0 {
				self.tableView.deleteRowsAtIndexPaths(getIndexPathArray(forArray: arrayTemp, section: sender.section!), withRowAnimation: .Top)
			}
			UIView.animateWithDuration(0.2) {
				sender.imageSideArraw!.transform = CGAffineTransformIdentity
			}
		} else {
			dictArray = arrayDropDownOptions[sender.section!]
			dict["arrayList"] = dictArray
			self.arrayTableList[sender.section!] = dict
			self.tableView.insertRowsAtIndexPaths(getIndexPathArray(forArray: arrayDropDownOptions[sender.section!], section: sender.section!), withRowAnimation: .Top)
			self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: dictArray.count - 1, inSection: sender.section!), atScrollPosition: .Bottom, animated: true)
			UIView.animateWithDuration(0.2) {
				sender.imageSideArraw!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
			}
		}
	}

	func getAttributes() {
		APIHandler.handler.getAttributesForProjrcts({ (response) in
			self.getTags()
			self.arrayDropDownOptions[2] = self.getArrayFromArrayJson(response["Attributes"][1]["attributeValues"].arrayValue)
           
  
            self.arrRoomType = self.getRoomType(response["Attributes"][0]["attributeValues"].arrayValue)
          
           
			self.arrayDropDownOptions[1] = self.getArrayFromArrayJson(response["Attributes"][2]["attributeValues"].arrayValue) // project type add
			self.arrayDropDownOptions[3] = self.getArrayFromArrayJson(response["Attributes"][3]["attributeValues"].arrayValue) // work type add
			self.arrayDropDownOptions[4] = self.getArrayFromArrayJson(response["Attributes"][4]["attributeValues"].arrayValue) // budget type add
		}) { (error) in

		}
	}

	func getArrayFromArrayJson(array: [JSON]) -> [AnyObject] {
		var arrayAnyObject = [AnyObject]()
		for object in array {
			var dict = [String: String]()
			dict["id"] = String(object["id"].intValue)
			dict["name"] = object["name"].stringValue
			dict["count"] = String(object["count"].intValue)
			arrayAnyObject.append(dict as AnyObject)
      
		}
		return arrayAnyObject
	}
    
    func getRoomType(array: [JSON]) -> [AnyObject] {
        var arrStyleItems = [AnyObject]()
        for object in array {
            var dict = [String: String]()
            dict["id"] = String(object["id"].intValue)
            dict["name"] = object["name"].stringValue
            dict["count"] = String(object["count"].intValue)
          arrStyleItems.append(dict as AnyObject)
        }
        return arrStyleItems
    }

	func getIndexPathArray(forArray array: [AnyObject], section: Int) -> [NSIndexPath] {
		var arrayindexPaths = [NSIndexPath]()
		for (index, _) in array.enumerate() {
			let indexPath = NSIndexPath(forRow: index, inSection: section)
			arrayindexPaths.append(indexPath)
		}
		return arrayindexPaths
	}

	func setUpArrayDropDownOption() {
		for value in arrayTableList {
			let dictArray: [AnyObject] = value["arrayList"] as! [AnyObject]
			arrayDropDownOptions.append(dictArray)
		}

		for (index, dictObj) in self.arrayTableList.enumerate() {
			if index != 0 && index != arrayTableList.count - 1 {
				var dict = dictObj as! [String: AnyObject]
				var dictArray: [AnyObject] = dict["arrayList"] as! [AnyObject]
				dictArray.removeAll()
				dict["arrayList"] = dictArray
				self.arrayTableList[index] = dict
			}
		}

	}

	func reloadArrayDropDownOption() {
		for (index, data) in arrayTableList.enumerate() {
			if index == 0 || index == 4 || index == 6 || index == 7 {
				let dictArray: [AnyObject] = data["arrayList"] as! [AnyObject]
				if dictArray.count > 0 {
					arrayDropDownOptions[index] = dictArray
				}
			}
		}
	}

}

extension AddPortfolioViewController {

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return arrayTableList.count
	}

	override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView()
		var backgroundImageView = UIImageView()
		backgroundImageView = UIImageView(frame: CGRect(x: 8, y: 3, width: tableView.frame.size.width - 16, height: IS_IPAD() ? 60.0 : 40.0))
		backgroundImageView.layer.cornerRadius = IS_IPAD() ? 12.0 : 8.0
		backgroundImageView.layer.masksToBounds = true
		backgroundImageView.backgroundColor = UIColor.whiteColor()
		let imageBorder = UIImageView(frame: CGRect(x: 0, y: IS_IPAD() ? 60.0 : 40.0, width: tableView.frame.size.width, height: 3.0))
		imageBorder.backgroundColor = UIColorRGB(239.0, g: 239.0, b: 244.0)
		let buttonHeader = HeaderButton(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: IS_IPAD() ? 50.0 : 40.0))
		buttonHeader.section = section
		buttonHeader.addTarget(self, action: #selector(UploadIdeasTableViewController.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
		let imageIcon = UIImageView(frame: CGRect(x: tableView.frame.size.width - 50, y: IS_IPAD() ? 10 : 8.0, width: IS_IPAD() ? 40.0 : 25.0, height: IS_IPAD() ? 40.0 : 25.0))
		let label = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.size.width - imageIcon.frame.size.width - 50, height: IS_IPAD() ? 60.0 : 40.0))
		imageIcon.image = UIImage(named: "InfluencerDropdownIconRight")

		var dict: [String: AnyObject] = self.arrayTableList[section] as! [String: AnyObject]
		let dictArray: [AnyObject] = dict["arrayList"] as! [AnyObject]
		if dictArray.count > 0 {
			imageIcon.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
		} else {
			imageIcon.transform = CGAffineTransformIdentity
		}

		buttonHeader.imageSideArraw = imageIcon

		label.text = ((arrayTableList[section] as! [String: AnyObject])["sectionTitle"] as? String)!
		label.textColor = UIColorRGB(65.0, g: 134.0, b: 44.0)
		label.font = label.font.fontWithSize(IS_IPAD() ? 22.0 : 15.0)
		label.backgroundColor = .clearColor()
		view.backgroundColor = UIColorRGB(239.0, g: 239.0, b: 244.0)

		view.addSubview(backgroundImageView)
		view.addSubview(label)
		view.addSubview(buttonHeader)
		view.addSubview(imageBorder)

		view.addSubview(imageIcon)
		return view
	}

	override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		switch section {
		case 0, (arrayTableList.count) - 1:
			return 0
		default:
			return IS_IPAD() ? 60.0 : 40.0
		}
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return (arrayTableList[section]["arrayList"] as! [AnyObject]).count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: BaseTableViewCell?

		switch indexPath.section {
		case 0:
			if indexPath.row == 0 {
				cell = tableView.dequeueReusableCellWithIdentifier(String(PortfolioCell) + "TextField") as! PortfolioCell
				(cell as! PortfolioCell).textFieldIdeaName.backgroundColor = .whiteColor()
			} else {
				cell = tableView.dequeueReusableCellWithIdentifier(String(PortfolioCell) + "TextView") as! PortfolioCell
				(cell as! PortfolioCell).textViewDescription.backgroundColor = .whiteColor()
			}
		case 5:
			cell = tableView.dequeueReusableCellWithIdentifier(String(PortfolioCell) + "TagView") as! PortfolioCell
			// (cell as! PortfolioCell).dataSource = self.arrTAges

			if eProjectStatus == .eProjectDetails {

				self.setTags(forArrTagsName: self.arrTagsNameList, cell: cell!, isTagsStaus: isAddTags!)
				(cell as! PortfolioCell).tagViewDescription.delegate = self
				return cell!
			}

			(cell as! PortfolioCell).tagViewDescription.delegate = self
			(cell as! PortfolioCell).tagViewDescription.backgroundColor = .clearColor()
		case 6:
			cell = tableView.dequeueReusableCellWithIdentifier(String(AddPortfolioImageCell)) as! AddPortfolioImageCell
			(cell as! AddPortfolioImageCell).dataSource = ((arrayTableList[indexPath.section] as! [String: AnyObject])["arrayList"]!)[indexPath.row]
           
            // function to work edit project image
            if eProjectStatus == .eProjectDetails{
             
             (cell as! AddPortfolioImageCell).arrGetImageId = self.arrEditImageID
             (cell as! AddPortfolioImageCell).isEditImagShowHide = true
            }else{
                (cell as! AddPortfolioImageCell).isEditImagShowHide = false
            }
            
            // edit image handler
            (cell as! AddPortfolioImageCell).didGetImageID = { (imageValue) in
                
                PopupViewController.showAddOrClearPopUp(self, Title: "Add Details", showRoomButtonType: true, arrData:self.arrRoomType, imageID:imageValue)
            }
            
            // Delete image handler
            (cell as! AddPortfolioImageCell).didCrossImageID = { (imageValue) in
                
            
            }
            
			cell!.backgroundColor = .clearColor()
			(cell as! AddPortfolioImageCell).didSelectCollectionCell = {
      
				self.tableView.endEditing(true)
				GPImagePickerController.pickImage(onController: self, didPick: { (image) in
					let imageData = image// info[UIImagePickerControllerOriginalImage] as? UIImage
					let pickedImage = UIImagePNGRepresentation(imageData)
					self.arrImagesData.append(pickedImage!)
					var dict: [String: AnyObject] = self.arrayTableList[6] as! [String: AnyObject]
					var dictArray: [AnyObject] = dict["arrayList"] as! [AnyObject]
					self.imageArray = dictArray[0] as! [AnyObject]
					self.imageArray.append(image)
					if self.imageArray.count > 9 {
						self.imageArray.removeAtIndex(0)
					}
					dictArray[0] = self.imageArray
               
					dict["arrayList"] = dictArray
					self.arrayTableList[6] = dict
					self.reloadArrayDropDownOption()
					self.tableView.reloadData()
					}, didCancel: {

				})
                
             
			}
            
           
			return cell!
		case 7:
			cell = tableView.dequeueReusableCellWithIdentifier(String(PortfolioCell) + "Submit") as! PortfolioCell
			(cell as! PortfolioCell).didTapSave = { (sender) in
				self.tableView.endEditing(true)
//                self.saveIdeas()
				self.addProjectWithData()
			}

		default:
			cell = tableView.dequeueReusableCellWithIdentifier(String(PortfolioCell) + "CheckButton") as! PortfolioCell
			// (cell as! PortfolioCell).section = indexPath.section
			(cell as! PortfolioCell).arrayAttributes = arrayAttributeIDs
			if self.selectedIndexPath == indexPath {
				(cell as! PortfolioCell).buttonCheck.selected = true
			} else {
				(cell as! PortfolioCell).buttonCheck.selected = false
			}
		}

		(cell as! PortfolioCell).didTapCheckBox = { (sender, attributeID) in
			self.tableView.endEditing(true)
			self.arrayAttributeIDs.removeAll()
			self.selectedIndexPath = indexPath
			if (self.selectedIndexPath?.section == 1) {
				self.projTypeId = attributeID
			} else if (self.selectedIndexPath?.section == 2) {
				self.styleTypeId = attributeID
			} else if (self.selectedIndexPath?.section == 3) {
				self.workTypeId = attributeID
			} else {
				self.projBudgetId = attributeID
			}

//			if self.arrayAttributeIDs.filter({ (id) -> Bool in return id == attributeID ? true : false }).count > 0 {
//				self.arrayAttributeIDs.removeObject(attributeID!)
//			} else {
//				self.arrayAttributeIDs.append(attributeID!)
//			}

//            if self.projTypeId != nil {
//                //self.arrayAttributeIDs.append(self.projTypeId!)
//             self.strStypeTypeId = self.projTypeId!
//            }
//            if self.styleTypeId != nil {
//              //  self.arrayAttributeIDs.append(self.styleTypeId!)
//                self.strStypeTypeId = self.styleTypeId!
//            }
//            if self.workTypeId != nil {
//                //self.arrayAttributeIDs.append(self.workTypeId!)
//                self.strWorkTypeId = self.workTypeId!
//            }
//            if self.projBudgetId != nil {
//                //self.arrayAttributeIDs.append(self.projBudgetId!)
//                self.strBudgetTypeId = self.projTypeId!
//            }

			self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .None)
		}

		(cell as! PortfolioCell).didChangeText = { (data, indexpath) in
			var dict: [String: AnyObject] = self.arrayTableList[indexpath.section] as! [String: AnyObject]
			var dictArray: [AnyObject] = dict["arrayList"] as! [AnyObject]
			dictArray[indexpath.row] = (data as? String)!
			dict["arrayList"] = dictArray
			self.arrayTableList[indexPath.section] = dict
			self.reloadArrayDropDownOption()
		}

		cell?.datasource = ((arrayTableList[indexPath.section] as! [String: AnyObject])["arrayList"]!)[indexPath.row]
		(cell as! PortfolioCell).indexPath = indexPath
		cell!.backgroundColor = .clearColor()
        
        
    

		return cell!
	}

	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

		switch indexPath.section {
		case 0:
			if indexPath.row == 0 {
				return IS_IPAD() ? 60 : 50 // text field cell
			} else {
				return IS_IPAD() ? 100 : 80 // text view cell
			}
		case 5:
			return IS_IPAD() ? 100 : 150 // text view cell (tags)
		case 6:
			return IS_IPAD() ? 200 : 150 // upload image cell
		case 7:
			return IS_IPAD() ? 70 : 60 // save button cell
		default:
			return IS_IPAD() ? 60 : 40 // check box cell
		}
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.tableView.endEditing(true)
	}
}
extension AddPortfolioViewController {
	func didTapMenuButton(strButtonType: String) {
		if strButtonType == KHeaderTickButton {
			// some action
            self.addProjectWithData()
		} else {

		}
	}

	// Mark:- Get Tags ID
	func getTagsID(pArry: [AnyObject], keySearch: String)
	{ let name = NSPredicate(format: "tag_name contains[c] %@", keySearch)
		let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
		let filteredArray = pArry.filter { compoundPredicate.evaluateWithObject($0) }
		let dict = filteredArray.first

		if let dictFilter = dict {
			if let _ = dict!["id"] {
				self.arrAllTagsID.append(dictFilter["id"] as! Int)
			}
		}
	}

	// MARK:- Remove Tags ID
	func removeTagsID(pArry: [AnyObject], keySearch: String)
	{ let name = NSPredicate(format: "tag_name contains[c] %@", keySearch)
		let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
		let filteredArray = pArry.filter { compoundPredicate.evaluateWithObject($0) }
		let dict = filteredArray.first

		if let dictFilter = dict {
			if let _ = dict!["id"] {
				let index = dictFilter["id"] as! Int
				self.arrAllTagsID.removeObject(index)
			}
		}
	}

	// mark-  ValidateFields
	func ValidateFields() -> Bool
	{
		self.view.endEditing(true)
		let result = true
		if self.strProjectName!.isBlank {
			Toast.show(withMessage: ENTER_PROJECT)
			return false
		}
		else if self.strProjectDisc!.isBlank {
			Toast.show(withMessage: ENTER_PROJECT_DESCRIPTION)
			return false
		}
		else if self.projTypeId == nil || self.projTypeId == "" {
			Toast.show(withMessage: SELECT_PROJECT_TYPE)
			return false
		}
		else if styleTypeId == nil || styleTypeId == "" {
			Toast.show(withMessage: SELECT_STYLETYPE)
			return false
		}
		else if self.workTypeId == nil || self.workTypeId == "" {
			Toast.show(withMessage: SELECT_WORK_TYPE)
			return false
		}
		else if self.projBudgetId == nil || self.projBudgetId == "" {
			Toast.show(withMessage: SELECT_BUDGET_TYPE)
			return false
		}
		else if !(self.arrAllTagsID.count > 0) {
			Toast.show(withMessage: TYPE_SOME_TAGS)
			return false
		}
		else if !(self.arrImagesData.count > 0) {
			Toast.show(withMessage: SELECT_PROJECT_IMAGE)
			return false
		}
		return result
	}

	// set project details data
	// MARK:- Set User details Data

	func setProjectDetailsData(pvalue: String?, section: Int?, row: Int?) {
		var dict: [String: AnyObject] = self.arrayTableList[section!] as! [String: AnyObject]
		var dictArray: [AnyObject] = dict["arrayList"] as! [AnyObject]
		dictArray[row!] = pvalue!
		dict["arrayList"] = dictArray
		self.arrayTableList[section!] = dict
	}

	// set attribute
	func setIdeaAttribute(forDictAttribute projectAttribute: [AnyObject]) {
	
		for index in 0..<projectAttribute.count {
			let dictAttribute = projectAttribute[index]
			print("\(dictAttribute)")

			if (dictAttribute["attribute_name"] as! String) == "Work Type" {
				let idValue = dictAttribute["attribute_value_id"]

				self.arrayAttributeIDs.append(String(idValue!))
				self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
			}
			if (dictAttribute["attribute_name"] as! String) == "Project Budget" {
				let idValue = dictAttribute["attribute_value_id"]

				self.arrayAttributeIDs.append(String(idValue))
				// self.tableView.reloadSections(NSIndexSet(index: 4), withRowAnimation: .None)
			}
			if (dictAttribute["attribute_name"] as! String) == "Project Type" {
				let idValue = dictAttribute["attribute_value_id"]

				self.arrayAttributeIDs.append(String(idValue))
				// self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)

			}
			if (dictAttribute["attribute_name"] as! String) == "Style Type" {
				let idValue = dictAttribute["attribute_value_id"]

				self.arrayAttributeIDs.append(String(idValue))
				// self.tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)

			}

		}

	}
	func setProjectImage(forArrImages arrImages: [AnyObject], section: Int?) {
		
		for index in 0..<arrImages.count {
			let dictImages = arrImages[index]
            //let objPortfolioImages = ProfileImage(withDictionary: dictImages as! [String: AnyObject])
            let imageID = dictImages["id"] as? String
             self.arrEditImageID.insert("", atIndex: 0)
            self.arrEditImageID.append(imageID!)
			let url = NSURL(string: (dictImages["thumb_image"] as? String)!)
			let imageData = NSData(contentsOfURL: url!)
            let img = UIImage(data: imageData!)
            self.imageArray.insert("AddPictureIcon", atIndex: 0)
			self.imageArray.append(img!)
			print("ImageUrl\(url)")
		}

        // self.fileType = MIMEType.mimeTypeForData(imageData)
        // self.base64 = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        // self.arrayDropDownOptions[section!] = [[arrImagesData]]
        var dict: [String: AnyObject] = self.arrayTableList[section!] as! [String: AnyObject]
        var dictArray: [AnyObject] = dict["arrayList"] as! [AnyObject]
        dictArray[0] = self.imageArray
        dict["arrayList"] = dictArray
        self.arrayTableList[section!] = dict
        //self.arrayDropDownOptions[section!] = [[arrImagesData]]
         self.tableView.reloadData()
	}
    
    // Parse Tags name with Tags ID
    func getTagsNameWithTagID(forTags arrTag: [AnyObject]) {
        for index in 0..<arrTag.count {
            self.arrTagsNameList.append((arrTag[index]["tag_name"]! as? String)!)
            
            self.arrAllTagsID.append((arrTag[index]["tag_id"]!)!)
        }
        isAddTags = true
        self.getAttributes()
        self.setUpArrayDropDownOption()
    }
    
	func setTags(forArrTagsName pTagsName: [AnyObject], cell: UITableViewCell, isTagsStaus: Bool) {
		var nameStr: String = ""
		if isTagsStaus == true {
			for index in 0..<pTagsName.count {
				nameStr = (pTagsName[index] as? String)!
				(cell as! PortfolioCell).tagViewDescription.addToken(KSToken.init(title: nameStr))
			}
			isAddTags = false
		}
	}

}

//MARK:- Api Calling
extension AddPortfolioViewController {
	// GEt Tags
	func getTags() {
		CDSpinner.show()
		APIHandler.handler.getTagsList({ (response) in
			debugPrint(response)
			self.arrTagsResult = response["tags"].arrayObject!
			if self.arrTagsResult.count > 0
			{
				for value in response["tags"].arrayObject! {
					let objTags = AddIdeaTags(withDictionary: value as! [String: AnyObject])
					self.arrTAges.append(objTags)
					self.list.append(objTags.tagName!)

				}
				debugPrint("AddIdeaTags ==>\(self.arrTAges)")
			}

		}) { (error) in
			CDSpinner.hide()
		}
	}

	// Call Add Project  Data Api
	func addProjectWithData() {

		self.strProjectName = arrayDropDownOptions[0][0] as? String
		self.strProjectDisc = arrayDropDownOptions[0][1] as? String
		if !(self.ValidateFields())
		{
			print(" some thing is missing")
			return;
		}

        if eProjectStatus == .eProjectDetails{
        
        APIHandler.handler.editUploadProject(Globals.sharedClient.userID!, projectName: self.strProjectName, description: self.strProjectDisc!, projectTypeID: Int(projTypeId!), stypeTypeID: styleTypeId, workTypeID: workTypeId, budgetTypeID: projBudgetId, arrTags: arrAllTagsID, imageData: arrImagesData, success: { (response) in
            print("Upload image Respose ==\(response)")
            }, failure: { (error) in
            
        })
        }else{
		APIHandler.handler.uploadProject(Globals.sharedClient.userID!, projectName: self.strProjectName, description: self.strProjectDisc!, projectTypeID: projTypeId, stypeTypeID: styleTypeId, workTypeID: workTypeId, budgetTypeID: projBudgetId, arrTags: arrAllTagsID, imageData: arrImagesData, success: { (response) in
			print("Upload image Respose ==\(response)")
			Toast.show(withMessage: UPDATE_PROJECT_SUCCESSFULLY)
			self.navigationController?.popViewControllerAnimated(true)
		}) { (error) in

		}
        }

	}

	// get project deatils......

	func getPortFolioDetailsWith(forPortfolioID portfolioID: Int?) {

		APIHandler.handler.getPortFolioDetails(forPortFolioID: portfolioID, success: { (response) in

			let dict = response.dictionaryObject

			let dictAttribute = dict!["attribute_name"] as! [AnyObject]
            let tagsList = dict!["tags"] as! [AnyObject]
			let arrImages = dict!["portfolioImages"] as! [AnyObject]
			print("project details ==\(dict)")
            
            self.setIdeaAttribute(forDictAttribute: dictAttribute)
			 self.setProjectImage(forArrImages: arrImages, section:6 )

			// self.setProjectAttribute(forDictAttribute: dictAttribute! as! [String: AnyObject])
			self.setProjectDetailsData(dict!["name"] as? String, section: 0, row: 0)
			self.setProjectDetailsData(dict!["description"] as? String, section: 0, row: 1)
            self.getTagsNameWithTagID(forTags: dict!["tags"] as! [AnyObject])
            
			self.tableView.reloadData()
		}) { (error) in
		}

	}
}
extension AddPortfolioViewController: KSTokenViewDelegate {
	func tokenView(token: KSTokenView, performSearchWithString string: String, completion: ((results: Array<AnyObject>) -> Void)?) {
		var data: Array<String> = []
		for value: String in list {
			if value.lowercaseString.rangeOfString(string.lowercaseString) != nil {
				data.append(value)
			}
		}
		completion!(results: data)
	}

	func tokenView(token: KSTokenView, displayTitleForObject object: AnyObject) -> String {
		let idea = (object as! String).componentsSeparatedByString("+")
		return idea[0]
	}

	func tokenView(tokenView: KSTokenView, didAddToken token: KSToken) {
		if isSearch == true {
			self.getTagsID(self.arrTagsResult, keySearch: String(token))
		}
		isSearch = false

		debugPrint(token)
	}

	func tokenView(tokenView: KSTokenView, didDeleteToken token: KSToken) {
		self.removeTagsID(self.arrTagsResult, keySearch: String(token))
		debugPrint(token)
	}

	func tokenView(token: KSTokenView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.isSearch = true

	}
//        func tokenView(tokenView: KSTokenView, shouldChangeAppearanceForToken token: KSToken) -> KSToken? {
//            self.arrAllTagsID.append(token)
//            return token
//        }

}





