//
//  InfluencerProfileViewController.swift
//  Greenply
//
//  Created by Shatadru Datta on 15/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class HeaderButton: UIButton {
	var section: Int?
	var imageSideArraw: UIImageView?
}

class InfluencerProfileViewController: BaseTableViewController, HeaderButtonDeleagte {

	var influencerProfileArray: [AnyObject]?
	var arrayIndex: [Int] = []
	var selectedRow: Bool!
	var influencerDetailsProfileArray: [AnyObject]?
	var arrProfileDetails = [String]?()
	var arrExprience = [AnyObject]()
    var arrWorkExperience: [AnyObject]?
	var arrTraining = [AnyObject]()
    var arrNewTraining: [AnyObject]?
    var arrEducation = [AnyObject]()
    var arrNewEducation: [AnyObject]?
	var arrSkils = [AnyObject]()
    var arrCertification = [AnyObject]()
    var strBase64: String!
    var fileType: String!
    var dictselectImage:  [String: String]?
    var imageCertificationArr = [AnyObject]?()
    var imageArr = [NSData]?()
    var certfirst: Bool = false
    var imageProfile: UIImage?
    var imageBackgroundProfile: UIImage?
    var list = [String]()
    var isSearch: Bool?
    var arrTagsResult = [AnyObject]()
    var arrAllTagsID = [AnyObject]()
    var dictValue: [String: AnyObject]!
	override func viewDidLoad() {

		super.viewDidLoad()

		self.getAllSkillsList()

		arrProfileDetails = [OBJ_FOR_KEY(kUserName) as! String, OBJ_FOR_KEY(kUserName) as! String, OBJ_FOR_KEY(kUserContactNumber) as! String, OBJ_FOR_KEY(kUserAddress) as! String, OBJ_FOR_KEY(kUserAboutUS) as! String, OBJ_FOR_KEY(kUserAboutUS) as! String]

		self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
		NavigationHelper.helper.headerViewController?.delegateButton = self
		influencerProfileArray = Helper.sharedClient.readPlist(forName: "InfluencerProfile")
		influencerDetailsProfileArray = Helper.sharedClient.readPlist(forName: "InfluencerDetails")
		selectedRow = false
		NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_EDIT_PROFILE
		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
		NavigationHelper.helper.headerViewController?.addHeaderButton(KHeaderTickButton)
        NavigationHelper.helper.tabBarViewController!.hideTabBar()

		tableView.backgroundView = nil
		tableView.reloadData()
		// Do any additional setup after loading the view.
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

    @IBAction func actionEditProfile(sender: UIButton) {
    }
	@IBAction func actionSave(sender: UIButton) {
        
//        let name = self.arrProfileDetails![1]
//        let contact = self.arrProfileDetails![2]
//        let address = self.arrProfileDetails![3]
//        let aboutUs = self.arrProfileDetails![5]
//        if name == "" {
//            Toast.show(withMessage: ENTER_USERNAME)
//        } else if contact == "" {
//            Toast.show(withMessage: ENTER_MOBILE_NUMBER)
//        } else if address == "" {
//            Toast.show(withMessage: ADDRESS)
//        } else if aboutUs == "" {
//            Toast.show(withMessage: ABOUTUS)
//        } else if self.arrExprience.count == 0 {
//            Toast.show(withMessage: ENTER_EXPERIENCE)
//        } else if self.arrTraining.count == 0 {
//            Toast.show(withMessage: ENTER_TRAINING)
//        } else if self.arrEducation.count == 0 {
//            Toast.show(withMessage: ENTER_EDUCATION)
//        } else if self.arrCertification.count == 0{
//            Toast.show(withMessage: ENTER_CERTIFICATION)
//        } else if self.arrAllTagsID.count == 0 {
//            Toast.show(withMessage: ENTER_SKILLS)
//        } else {
            self.InfluencerAPI()
      //  }
        
    }
    
//        APIHandler.handler.editInfluencerProfile(forUser: Globals.sharedClient.userID, forUserName: "ff", contactNumber: "7044216974", email: OBJ_FOR_KEY(kUserEmail) as? String, birthDate: OBJ_FOR_KEY(kUserBirthDate) as? String, address:"sdjfh", aboutUs: "hdsgfhg", userEducation: arrEducation , userTraining: arrTraining , UserExperience: arrExprience , UserCertification: arrCertification , serviceArea: "Developemnt", skillID: self.arrAllTagsID, base64: self.strBase64 , success: { (response) in
//    
//    }) { (error) in
//    
//    }
//}

}

extension InfluencerProfileViewController {

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		if let array = influencerProfileArray {
			return array.count
		} else {
			return 0
		}
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

         if section == 0 || section == 1 || section == 2 || section == 3 || section == 7 {
			return (((influencerProfileArray![section] as! [String: AnyObject])["fieldArray"]!) as! [AnyObject]).count
		} else {
			let array = arrayIndex.filter({ (object) -> Bool in return object == section ? true : false })
			if array.count > 0 {
				return (((influencerProfileArray![section] as! [String: AnyObject])["fieldArray"]!) as! [AnyObject]).count
			} else {
				return 0
			}
		}
	}

	override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView()
		var backgroundImageView = UIImageView()
		switch section {
		case 4, 6:
			backgroundImageView = UIImageView(frame: CGRect(x: 8, y: 3, width: tableView.frame.size.width - 16, height: IS_IPAD() ? 60.0 : 40.0))
		default:
			backgroundImageView = UIImageView(frame: CGRect(x: 8, y: 3, width: tableView.frame.size.width - 16, height: IS_IPAD() ? 60.0 : 50.0))
		}
		backgroundImageView.layer.cornerRadius = IS_IPAD() ? 12.0 : 8.0
		backgroundImageView.layer.masksToBounds = true
		backgroundImageView.backgroundColor = UIColor.whiteColor()
		let imageBorder = UIImageView(frame: CGRect(x: 0, y: IS_IPAD() ? 60.0 : 40.0, width: tableView.frame.size.width, height: 3.0))
		imageBorder.backgroundColor = UIColorRGB(239.0, g: 239.0, b: 244.0)
		let buttonHeader = HeaderButton(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: IS_IPAD() ? 50.0 : 40.0))
		buttonHeader.section = section
		buttonHeader.addTarget(self, action: #selector(InfluencerProfileViewController.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
		let imageIcon = UIImageView(frame: CGRect(x: tableView.frame.size.width - 50, y: IS_IPAD() ? 10 : 8.0, width: IS_IPAD() ? 40.0 : 25.0, height: IS_IPAD() ? 40.0 : 25.0))
		let label = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.size.width - imageIcon.frame.size.width - 50, height: IS_IPAD() ? 60.0 : 40.0))

		switch section {
		case 0, 1, 2, 3:
			imageIcon.image = UIImage(named: "InfluencerDropdownIconRight")
		default:
			let array = arrayIndex.filter({ (object) -> Bool in return object == section ? true : false })
			if array.count > 0 {
				imageIcon.image = UIImage(named: "InfluencerDropdownIcon")
			} else {
				imageIcon.image = UIImage(named: "InfluencerDropdownIconRight")
			}
		}

		label.text = ((influencerProfileArray![section] as! [String: AnyObject])["sectionTitle"] as? String)!
		label.textColor = UIColorRGB(65.0, g: 134.0, b: 44.0)
		label.font = label.font.fontWithSize(IS_IPAD() ? 22.0 : 15.0)
		label.backgroundColor = .clearColor()
		view.backgroundColor = UIColorRGB(239.0, g: 239.0, b: 244.0)

		view.addSubview(backgroundImageView)
		view.addSubview(label)
		view.addSubview(buttonHeader)

		switch section {
		case 1, 2, 3:
			debugPrint("")
		default:
			view.addSubview(imageBorder)
		}

		switch section {
		case 0, 10:
			debugPrint("No Code")
		default:
			label.font = UIFont.boldSystemFontOfSize(IS_IPAD() ? 22.0 : 15.0)
			view.addSubview(imageIcon)
		}
		return view
	}

	override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		switch section {
		case 0, (influencerProfileArray?.count)! - 1:
			return 0
		default:
			return IS_IPAD() ? 60.0 : 40.0
		}
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: BaseTableViewCell?
		switch indexPath.section {
		case 0:
			if indexPath.row == 0 {
				cell = tableView.dequeueReusableCellWithIdentifier(String(ProfileViewTableViewCell), forIndexPath: indexPath) as! ProfileViewTableViewCell
				(cell as! ProfileViewTableViewCell).datasource = imageBackgroundProfile
                (cell as! ProfileViewTableViewCell).didSelectImage = {
                    GPImagePickerController.pickImage(onController: self,  didPick: { (image) in
                        self.imageProfile = image
                        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
                    }) {
                        
                    }
                }
                
                (cell as! ProfileViewTableViewCell).didSelectBackgroundImage = {
                    GPImagePickerController.pickImage(onController: self,  didPick: { (image) in
                        self.imageBackgroundProfile = image
                        
                        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
                    }) {
                        
                    }
                }
				return cell!
			} else {
				cell = tableView.dequeueReusableCellWithIdentifier(String(FieldTableViewCell), forIndexPath: indexPath) as! FieldTableViewCell
                (cell as? FieldTableViewCell)?.index = indexPath
                (cell as? FieldTableViewCell)?.strTextValue = self.arrProfileDetails![indexPath.row]
                (cell as? FieldTableViewCell)?.textValue = { text, indexpath in
                    self.arrProfileDetails!.removeAtIndex(indexpath.row)
                    self.arrProfileDetails!.insert(text, atIndex: indexpath.row)
                }
			}
		case 1, 2, 3:
			cell = tableView.dequeueReusableCellWithIdentifier(String(ExperienceTableViewCell), forIndexPath: indexPath) as! ExperienceTableViewCell
		case 4:
			cell = tableView.dequeueReusableCellWithIdentifier(String(LicenseTableViewCell), forIndexPath: indexPath) as! LicenseTableViewCell
            
            imageCertificationArr = ((influencerProfileArray![indexPath.section]["fieldArray"]!) as! [[AnyObject]])
            (cell as? LicenseTableViewCell)?.dataSource = imageCertificationArr![indexPath.row] as? [AnyObject]
			(cell as! LicenseTableViewCell).didSelectCollectionCell = {

				GPImagePickerController.pickImage(onController: self, didPick: { (image) in
					let imageData = image// info[UIImagePickerControllerOriginalImage] as? UIImage
                    let pickedImage: NSData = UIImagePNGRepresentation(imageData)!
					var dict: [String: AnyObject] = self.influencerProfileArray![4] as! [String: AnyObject]
					var dictArray: [AnyObject] = dict["fieldArray"] as! [AnyObject]
					var imageArray: [AnyObject] = dictArray[0] as! [AnyObject]
                    imageArray.append(image)
                    if imageArray.count > 4 {
                        imageArray.removeAtIndex(0)
                    }
					dictArray[0] = imageArray
                    let fType = MIMEType.mimeTypeForData(pickedImage)
                    let fileExtension = fType.componentsSeparatedByString("/")
                    self.fileType = "\(String.randomString(10)).\(fileExtension[1])"
                    self.strBase64 = pickedImage.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                    self.dictselectImage = ["filename":  self.fileType,  "base64":self.strBase64]
                    self.arrCertification.append(self.dictselectImage!)
                    print(self.imageCertificationArr)
					dict["fieldArray"] = dictArray
                    self.influencerProfileArray![4] = dict
                    self.tableView.reloadData()
					}, didCancel: {
				})
			}
            
			return cell!
		case 5:
			cell = tableView.dequeueReusableCellWithIdentifier(String(SkillsTableViewCell), forIndexPath: indexPath) as! SkillsTableViewCell
            (cell as! SkillsTableViewCell).tagviewDesc.delegate = self
            (cell as! SkillsTableViewCell).tagviewDesc.backgroundColor = .whiteColor()
        case 6:
			cell = tableView.dequeueReusableCellWithIdentifier(String(LocationTableViewCell), forIndexPath: indexPath) as! LocationTableViewCell
		case 7:
			cell = tableView.dequeueReusableCellWithIdentifier(String(SaveButtonTableViewCell), forIndexPath: indexPath) as! SaveButtonTableViewCell
        default:
			debugPrint("No Code")
		}
      
    
		cell?.datasource = ((influencerProfileArray![indexPath.section] as! [String: AnyObject])["fieldArray"]!)[indexPath.row]
		return cell!
	}

	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

		let height: String?
		if IS_IPAD() {
			height = (((influencerProfileArray![indexPath.section] as! [String: AnyObject])["heightOfRowiPad"]!) as! String)
		} else {
			height = (((influencerProfileArray![indexPath.section] as! [String: AnyObject])["heightOfRowiPhone"]!) as! String)
		}
		var floatHeight: CGFloat?
		if let number = NSNumberFormatter().numberFromString(height!) {
			floatHeight = CGFloat(number)
		}
		switch indexPath.section {
		case 0:
			if indexPath.row == 0 {
				return IS_IPAD() ? 260.0 : 205.0
			} else {
				return floatHeight!
			}
		default:
			return floatHeight!
		}
	}

	func buttonClicked(sender: HeaderButton!) {
		let array = arrayIndex.filter({ (object) -> Bool in return object == sender.section ? true : false })
		if array.count > 0 {
			arrayIndex.removeObject(array.last!)
		} else {
			arrayIndex.append(sender.section!)
		}
		if sender.section == 1 || sender.section == 2 || sender.section == 3 {
			let influencerDetailsVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(InfluencerProfileDetailsController)) as! InfluencerProfileDetailsController
			var dict: [String: AnyObject] = self.influencerProfileArray![sender.section!] as! [String: AnyObject]
			if sender.section == 1 {
				influencerDetailsVC.identifykeyStatus = .eExperience
			}
			if sender.section == 2 {
				influencerDetailsVC.identifykeyStatus = .eTraining
			}
			if sender.section == 3 {
				influencerDetailsVC.identifykeyStatus = .eEducation
			}
			

			let dictArray = dict["fieldArray"] as! [AnyObject]
			influencerDetailsVC.influencerDetailsArray = dictArray
			influencerDetailsVC.didSaveInfluencerDetails = { (array, datasource) in
				var dict: [String: AnyObject] = self.influencerProfileArray![sender.section!] as! [String: AnyObject]
				var dictArray: [AnyObject] = dict["fieldArray"] as! [AnyObject]
				dictArray = array
				if sender.section == 1 {
                    for (_, element) in dictArray.enumerate() {
                        self.dictValue = ["organisation_name": element["Title"]!!, "start_date": element["From"]!!, "end_date": element["To"]!!]
                    }
					self.arrExprience.append(self.dictValue) //   assign exprience value
				} else if sender.section == 2 {
                    for (_, element) in dictArray.enumerate() {
                        self.dictValue = ["training_name": element["Title"]!!, "start_date": element["From"]!!, "end_date": element["To"]!!]
                    }
					self.arrTraining.append(self.dictValue) // assign training value
				}
				else if sender.section == 3 {
                    for (_, element) in dictArray.enumerate() {
                        self.dictValue = ["degree": element["Title"]!!, "stream": element["Description"]!!, "start_date": element["From"]!!, "end_date": element["To"]!!]
                    }
					self.arrEducation.append(self.dictValue) // assign education value
				}

				dict["fieldArray"] = dictArray
				self.influencerProfileArray![sender.section!] = dict
				self.tableView.reloadData()
			}
			self.navigationController!.pushViewController(influencerDetailsVC, animated: true)
        }
//        } else if sender.section == 5 {
//            let skillsDetailVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(TagViewController)) as! TagViewController
//            self.navigationController!.pushViewController(skillsDetailVC, animated: true)
//        } 
        else {
			tableView.reloadData()
		}
	}
}


//MARK:- Hedaer Buttton Delagte
extension InfluencerProfileViewController {
	func didTapMenuButton(strButtonType: String) {
		if strButtonType == KHeaderTickButton {
			// some action
		} else {

		}
	}
}

//MARK:- Api Call SkillList
extension InfluencerProfileViewController {
	func getAllSkillsList() {
		APIHandler.handler.getSkillList({ (response) in
		
            self.arrTagsResult = response["Skill"].arrayObject!
            if self.arrTagsResult.count > 0 {
                for value in response["Skill"].arrayObject! {
                    let objTags = SkillTags(withDictionary: value as! [String: AnyObject])
                    self.arrSkils.append(objTags)
                    self.list.append(objTags.skillName!)
                }
                debugPrint("AddIdeaTags ==>\(self.arrSkils)")
            }
        }) { (error) in
		}
	}
}


//MARK:- GetSkillsTags
extension InfluencerProfileViewController {
    func getTagsID(pArry: [AnyObject], keySearch: String)
    { let name = NSPredicate(format: "skill_name contains[c] %@", keySearch)
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
    { let name = NSPredicate(format: "skill_name contains[c] %@", keySearch)
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

}

//MARK:- KSTokenView Delegate
extension InfluencerProfileViewController: KSTokenViewDelegate {
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
    
    func tokenView(tokenView: KSTokenView, shouldChangeAppearanceForToken token: KSToken) -> KSToken? {
        self.arrAllTagsID.append(token)
        return token
    }
}

extension InfluencerProfileViewController {
    func InfluencerAPI() {
        APIHandler.handler.editInfluencerProfile(forUser: Globals.sharedClient.userID, forUserName: self.arrProfileDetails![1], contactNumber: self.arrProfileDetails![2], email: OBJ_FOR_KEY(kUserEmail) as? String, birthDate: OBJ_FOR_KEY(kUserBirthDate) as? String, address: self.arrProfileDetails![3], aboutUs: self.arrProfileDetails![5], userEducation: arrEducation , userTraining: arrTraining , UserExperience: arrExprience , UserCertification: arrCertification , serviceArea: "Developemnt", skillID: self.arrAllTagsID, base64: self.strBase64 ,success: { (response) in
            self.navigationController?.popViewControllerAnimated(true)
        }) { (error) in
            
        }

    }
}


