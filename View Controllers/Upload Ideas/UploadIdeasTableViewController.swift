//
//  UploadIdeasTableViewController.swift
//  Greenply
//
//  Created by Chinmay Das on 22/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
import SwiftyJSON
enum eUploadIdea {
	case eUploadIdea
	case eIdeaDetails
}
class UploadIdeasTableViewController: BaseTableViewController {

	var arrayTableList = [AnyObject]()
	var arrayDropDownOptions = [[AnyObject]]()
	var arrayAttributeIDs = [String]()
	var IdeaID: Int?
	var base64 = String()
	var arrTagsResult = [AnyObject]()
	var fileType: String?
	var fileName: String?
	var list = [String]()
	var arrAllTagsID = [AnyObject]()
	var arrTAges = [AnyObject]()
	var strIdeaDisc: String?
	var strIdeaName: String?
	var imgeData: NSData?
	var arrTagsNameList = [AnyObject]()
	var arrUserTagsList = [AnyObject]()
	var isSearch: Bool?
	var isAddTags: Bool?
	// var strIdeadescription =
	var eUloadIdeaStatus: eUploadIdea = .eUploadIdea
    var selectedIndexPath: NSIndexPath?
    var styleTypeId: String?
    var roomTypeId: String?
    
	override func viewDidLoad() {
		super.viewDidLoad()
		isAddTags = true
		arrayTableList = Helper.sharedClient.readPlist(forName: "UploadIdeas")
//		self.tableView.reloadData()

		if eUloadIdeaStatus == .eUploadIdea {
			getAttributes()
			setUpArrayDropDownOption()
		}
		else if eUloadIdeaStatus == .eIdeaDetails {
			self.editIdeaDetailsWith(forIdeaId: IdeaID!)
		}

		self.backgroundImageView.image = UIImage(named: "BackgroundImage")
		self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_UPLOAD_IDEAS
		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
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
			self.tableView.deleteRowsAtIndexPaths(getIndexPathArray(forArray: arrayTemp, section: sender.section!), withRowAnimation: .Top)
			UIView.animateWithDuration(0.2) {
				sender.imageSideArraw!.transform = CGAffineTransformIdentity
			}
		} else {
			dictArray = arrayDropDownOptions[sender.section!]
			dict["arrayList"] = dictArray

			self.arrayTableList[sender.section!] = dict
			self.tableView.insertRowsAtIndexPaths(getIndexPathArray(forArray: arrayDropDownOptions[sender.section!], section: sender.section!), withRowAnimation: .Top)
			if dictArray.count > 0 {
				self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: dictArray.count - 1, inSection: sender.section!), atScrollPosition: .Bottom, animated: true)
				UIView.animateWithDuration(0.2) {
					sender.imageSideArraw!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))

				}
			}
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
		print("AllAtt==\(arrayAnyObject)")
		return arrayAnyObject
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

		var dict: [String: AnyObject] = self.arrayTableList[4] as! [String: AnyObject]
		var dictArray: [AnyObject] = dict["arrayList"] as! [AnyObject]
		dictArray.removeAll()
		dict["arrayList"] = dictArray
		self.arrayTableList[4] = dict

		var dict1: [String: AnyObject] = self.arrayTableList[3] as! [String: AnyObject]
		var dictArray1: [AnyObject] = dict1["arrayList"] as! [AnyObject]
		dictArray1.removeAll()
		dict1["arrayList"] = dictArray1
		self.arrayTableList[3] = dict1
	}

	func reloadArrayDropDownOption() {
		for (index, data) in arrayTableList.enumerate() {
			if index == 0 || index == 3 || index == 4 {
				let dictArray: [AnyObject] = data["arrayList"] as! [AnyObject]
				if dictArray.count > 0 {
                    if arrayDropDownOptions.count >= index + 1{
                    arrayDropDownOptions[index] = dictArray
                    }
					
				}
			}
		}
	}

}

//MARK:- UITableViewDelegate and DataSource Methods
extension UploadIdeasTableViewController {
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
				cell = tableView.dequeueReusableCellWithIdentifier(String(UploadIdeasCell) + "TextField") as! UploadIdeasCell

			} else {
				cell = tableView.dequeueReusableCellWithIdentifier(String(UploadIdeasCell) + "TextView") as! UploadIdeasCell

				(cell as! UploadIdeasCell).textViewDescription.backgroundColor = .whiteColor()

			}

		case 3:
			cell = tableView.dequeueReusableCellWithIdentifier(String(UploadIdeasCell) + "TagView") as! UploadIdeasCell

			if eUloadIdeaStatus == .eIdeaDetails {

				self.setTags(forArrTagsName: self.arrTagsNameList, cell: cell!, isTagsStaus: isAddTags!)
				(cell as! UploadIdeasCell).tagViewDescription.delegate = self
				return cell!
			}

			(cell as! UploadIdeasCell).tagViewDescription.delegate = self
			(cell as! UploadIdeasCell).tagViewDescription.backgroundColor = .whiteColor()

		case 4:
			cell = tableView.dequeueReusableCellWithIdentifier(String(UploadIdeasImageCell)) as! UploadIdeasImageCell

			(cell as! UploadIdeasImageCell).dataSource = ((arrayTableList[indexPath.section] as! [String: AnyObject])["arrayList"]!)[indexPath.row]

			cell!.backgroundColor = .clearColor()
			(cell as! UploadIdeasImageCell).didSelectCollectionCell = {

				self.tableView.endEditing(true)

				GPImagePickerController.pickImage(onController: self, didPick: { (image) in
					let imageData: UIImage = image// info[UIImagePickerControllerOriginalImage] as? UIImage
					let pickedImage: NSData = UIImagePNGRepresentation(imageData)!
					self.imgeData = pickedImage
					var dict: [String: AnyObject] = self.arrayTableList[4] as! [String: AnyObject]
					var dictArray: [AnyObject] = dict["arrayList"] as! [AnyObject]
					var imageArray: [AnyObject] = dictArray[0] as! [AnyObject]
					imageArray = [self.imgeData!]
					dictArray[0] = imageArray
					dict["arrayList"] = dictArray
					self.arrayTableList[4] = dict
					self.fileType = MIMEType.mimeTypeForData(self.imgeData)
					self.base64 = pickedImage.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
					self.reloadArrayDropDownOption()
					self.tableView.reloadData()
					}, didCancel: {

				})
			}
			return cell!

		case 5:
			cell = tableView.dequeueReusableCellWithIdentifier(String(UploadIdeasCell) + "Submit") as! UploadIdeasCell

			(cell as! UploadIdeasCell).didTapSave = { (sender) in
				self.tableView.endEditing(true)
				self.saveIdeas()
			}

		default:
			cell = tableView.dequeueReusableCellWithIdentifier(String(UploadIdeasCell) + "CheckButton") as! UploadIdeasCell
			(cell as! UploadIdeasCell).arrayAttributes = arrayAttributeIDs
        
            if self.selectedIndexPath == indexPath {
                (cell as! UploadIdeasCell).buttonCheck.selected = true
            }else{
                (cell as! UploadIdeasCell).buttonCheck.selected = false
            }

		}
       
        
		(cell as! UploadIdeasCell).didTapCheckBox = { (sender, attributeID) in
            self.selectedIndexPath = indexPath
			debugPrint(sender)
			self.tableView.endEditing(true)
            self.arrayAttributeIDs.removeAll()
            if (self.selectedIndexPath?.section == 1 ) {
                self.styleTypeId = attributeID
            } else {
                self.roomTypeId = attributeID
            }
//			if self.arrayAttributeIDs.filter({ (id) -> Bool in return id == attributeID ? true : false }).count > 0 {
//				self.arrayAttributeIDs.removeObject(attributeID!)
//				debugPrint(self.arrayAttributeIDs)
//			} else {
//				self.arrayAttributeIDs.append(attributeID!)
//				debugPrint(self.arrayAttributeIDs)
//			}
            if self.styleTypeId != nil {
                self.arrayAttributeIDs.append(self.styleTypeId!)
            }
            if self.roomTypeId != nil {
                self.arrayAttributeIDs.append(self.roomTypeId!)
            }
            
            self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .None)
		}

		(cell as! UploadIdeasCell).didChangeText = { (data, indexpath) in
			var dict: [String: AnyObject] = self.arrayTableList[indexpath.section] as! [String: AnyObject]
			var dictArray: [AnyObject] = dict["arrayList"] as! [AnyObject]
			dictArray[indexpath.row] = (data as? String)!
			dict["arrayList"] = dictArray
			self.arrayTableList[indexPath.section] = dict
			self.reloadArrayDropDownOption()
		}

		cell?.datasource = ((arrayTableList[indexPath.section] as! [String: AnyObject])["arrayList"]!)[indexPath.row]
		(cell as! UploadIdeasCell).indexPath = indexPath
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
		case 1, 2:
			return IS_IPAD() ? 60 : 40 // check box cell
		case 3:
			return IS_IPAD() ? 100 : 150 // text view cell (tags)
		case 4:
			return IS_IPAD() ? 200 : 150 // image upload cell
		default:
			return IS_IPAD() ? 70 : 60 // save button cell
		}
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.tableView.endEditing(true)
	}
}

extension UploadIdeasTableViewController {
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

    
	// Remove Tags
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
    
    
	// Parse Tags name with Tags ID
	func getTagsNameWithTagID(forTags arrTag: [AnyObject]) {
		for index in 0..<arrTag.count {
			self.arrTagsNameList.append((arrTag[index]["tag_name"]! as? String)!)
			self.arrAllTagsID.append((arrTag[index]["id"]! as! Int))
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
				(cell as! UploadIdeasCell).tagViewDescription.addToken(KSToken.init(title: nameStr))
			}
			isAddTags = false
		}
	}

	// MARK:- Set User details Data

	func setIdeaDetailsData(pvalue: String?, section: Int?, row: Int?) {
		var dict: [String: AnyObject] = self.arrayTableList[section!] as! [String: AnyObject]
		var dictArray: [AnyObject] = dict["arrayList"] as! [AnyObject]
		dictArray[row!] = pvalue!
		dict["arrayList"] = dictArray
		self.arrayTableList[section!] = dict
	}
	func setIdeaImage(forImageData imageData: NSData, section: Int?) {
        
        self.fileType = MIMEType.mimeTypeForData(imageData)
        self.base64 = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
		self.arrayDropDownOptions[section!] = [[imageData]]
	}

	func setIdeaAttribute(forDictAttribute ideaAttribute: [String: AnyObject]) {

		if let _ = ideaAttribute["room_type"] {
			self.arrayAttributeIDs.append(String(ideaAttribute["room_type"]!["value_id"] as! Int))
            self.roomTypeId = String(ideaAttribute["room_type"]!["value_id"] as! Int)
            self.tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)
		}
		if let _ = ideaAttribute["style_type"] {
			self.arrayAttributeIDs.append(String(ideaAttribute["style_type"]!["value_id"] as! Int))
            self.styleTypeId = String(ideaAttribute["style_type"]!["value_id"] as! Int)
            self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
		}
	}

	// mark-  ValidateFields
	func ValidateFields() -> Bool
	{
        self.view.endEditing(true)
		let result = true
		if self.strIdeaName!.isBlank {
			Toast.show(withMessage: ENTER_IDEA)
			return false
		}
		else if self.strIdeaDisc!.isBlank {
			Toast.show(withMessage: ENTER_IDEA_DESCRIPTION)
			return false
		}
        else if self.styleTypeId == nil || self.styleTypeId == "" {
            Toast.show(withMessage: SELECT_STYLETYPE)
            return false
        }
        else if self.roomTypeId == nil || self.roomTypeId == "" {
            Toast.show(withMessage: SELECT_ROOMTYPE)
            return false
        }
		else if !(self.imgeData?.length > 0) {
			Toast.show(withMessage: SELECT_IDEA_IMAGE)
			return false
		}
        else if !(self.arrAllTagsID.count > 0) {
         Toast.show(withMessage: TYPE_SOME_TAGS)
            return false
        }

		return result
	}

}
// MARK:- Api Working
extension UploadIdeasTableViewController {
	func getAttributes() {
		CDSpinner.show()
		APIHandler.handler.getAttributesForProjrcts({ (response) in
			self.getTags()
			CDSpinner.hide()
			self.arrayDropDownOptions[2] = self.getArrayFromArrayJson(response["Attributes"][0]["attributeValues"].arrayValue) // Room type add
			self.arrayDropDownOptions[1] = self.getArrayFromArrayJson(response["Attributes"][1]["attributeValues"].arrayValue) // Style type add

		}) { (error) in
			CDSpinner.hide()
		}
	}

	func getTags() {
		CDSpinner.show()
		APIHandler.handler.getTagsList({ (response) in
			debugPrint(response)
			self.arrTagsResult = response["tags"].arrayObject!
			print("All TAgs\(self.arrTagsResult)")
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

	// Save Idea
	func saveIdeas() {

        
		let ideaName = arrayDropDownOptions[0][0] as? String
		self.strIdeaName = ideaName
		let description = arrayDropDownOptions[0][1] as? String
		self.strIdeaDisc = description
		if !(self.ValidateFields())
		{
			print(" some thing is missing")
			return;
		}

		if eUloadIdeaStatus == .eIdeaDetails {

			let attributes = arrayAttributeIDs.joinWithSeparator(",")
			print("Firctdssd64:=== \( self.base64)")
			let ImagefileName = (NSDate.getTimeStamp() + ".jpg")
            APIHandler.handler.editUploadIdea(forIdeaId: IdeaID!, ideaName: ideaName, description: description, fileType: fileType, fileName: String(ImagefileName), fileSize: "100", base64: self.base64, IdeaTag: self.arrAllTagsID, attributeValues: attributes, success: { (response) in
				debugPrint(response)
				Toast.show(withMessage: UPDATE_IDEA_SUCCESSFULLY)
				self.navigationController?.popViewControllerAnimated(true)
			}) { (error) in
				debugPrint(error)
			}

		} else {
			let ideaName = arrayDropDownOptions[0][0] as? String
			let description = arrayDropDownOptions[0][1] as? String
			let attributes = arrayAttributeIDs.joinWithSeparator(",")
			print("Firctdssd64:=== \( self.base64)")
			let ImagefileName = (NSDate.getTimeStamp() + ".jpg")
			APIHandler.handler.uploadIdea(ideaName, description: description, fileType: fileType, fileName: String(ImagefileName), fileSize: "100", base64: self.base64, IdeaTag: self.arrAllTagsID, attributeValues: attributes, success: { (response) in
				debugPrint(response)
				Toast.show(withMessage: UPLOAD_IDEA_SUCCESSFULLY)
				self.navigationController?.popViewControllerAnimated(true)
			}) { (error) in
				debugPrint(error)
			}

		}

	}
	// get Idea details..
	func editIdeaDetailsWith(forIdeaId userID: Int?) {
		APIHandler.handler.getIdeaDetails(userID!, success: { (response) in

			print("Idea Detils == >\(response)")

			let dictDetails = response!["Idea"].dictionaryObject
            let dictAttribute = dictDetails!["attributeWithValue"]
           self.setIdeaAttribute(forDictAttribute: dictAttribute! as! [String: AnyObject])
    
			self.setIdeaDetailsData(dictDetails!["idea_name"] as? String, section: 0, row: 0)
			self.setIdeaDetailsData(dictDetails!["description"] as? String, section: 0, row: 1)

            self.getTagsNameWithTagID(forTags: dictDetails!["tags"] as! [AnyObject])

			let url = NSURL(string: (dictDetails!["idea_image"]!["thumb"] as? String)!)
			self.imgeData = NSData(contentsOfURL: url!)

			self.setIdeaImage(forImageData: self.imgeData!, section: 4)
			
			self.tableView.reloadData()
		}) { (error) in

		}
	}
}


extension UploadIdeasTableViewController: KSTokenViewDelegate {
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

	func tokenView(token: KSTokenView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.isSearch = true

	}

	func tokenView(tokenView: KSTokenView, didDeleteToken token: KSToken) {
		self.removeTagsID(self.arrTagsResult, keySearch: String(token))
		debugPrint(token)
	}
}
