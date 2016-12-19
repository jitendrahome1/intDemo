//
//  BecomeInfluencerViewController.swift
//  Greenply
//
//  Created by Shatadru Datta on 06/10/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class BecomeInfluencerViewController: BaseTableViewController {

    @IBOutlet weak var textName: JATextField!
    @IBOutlet weak var textMobileNumber: JATextField!
    @IBOutlet weak var textType: JATextField!
    @IBOutlet weak var textViewAboutMe: JAPlaceholderTextView!
    @IBOutlet weak var labelUploadFile: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var imageBackground: UIImageView!
    var becomeInfluencerArray: [AnyObject]?
    var arrayType = [String]()
    var strTypeId: String!
    var strBase64: String!
    var fileType: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = nil
        self.tableView.keyboardDismissMode = .OnDrag
        textMobileNumber.keyboardType = .NumberPad
        becomeInfluencerArray = Helper.sharedClient.readPlist(forName: "BecomeInfluencer")
        
        //InfluencerType API Call
        APIHandler.handler.userType({ (response) in
            for value in response["influencer"].arrayValue {
                let influencerType = value["influencer_type"].stringValue
                let influencerTypeId = value["influencer_type_id"].stringValue
                let influencerData = "\(influencerType)+\(influencerTypeId)"
                self.arrayType.append(influencerData)
                debugPrint(self.arrayType)
            }
        }) { (error) in
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        NavigationHelper.helper.tabBarViewController!.hideTabBar()
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: false, isHideMenuButton: false)
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_INFLUENCER
    }
    
    //MARK:- SaveAction
    @IBAction func saveAction(sender: UIButton) {
        guard textName.hasText() && textMobileNumber.hasText() && textType.hasText() && textViewAboutMe.hasText() && strBase64 != nil else {
            if textName.text!.isBlank {
                Toast.show(withMessage: ENTER_USERNAME)
            }
            else if textMobileNumber.text!.isBlank {
                Toast.show(withMessage: ENTER_MOBILE_NUMBER)
            }
            else if textType.text!.isBlank {
                Toast.show(withMessage: ENTER_TYPE)
            }
            else if textViewAboutMe.text!.isBlank {
                Toast.show(withMessage: ENTER_ABOUTME)
            }
            else if strBase64 == nil {
                Toast.show(withMessage: UPLOAD_FILE)
            }
            else
            {}
            return
        }
        becomeInfluencerAPICalling()
    }
    
    @IBAction func browseAction(sender: UIButton) {
        GPImagePickerController.pickImage(onController: self, didPick: { (image) in
            let imagesData: NSData = UIImagePNGRepresentation(image)!
            self.fileType = MIMEType.mimeTypeForData(imagesData)
            let fileExtension = self.fileType.componentsSeparatedByString("/")
            self.labelUploadFile.text = "\(String.randomString(10)).\(fileExtension[1])"
            self.strBase64 = imagesData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            }, didCancel: {
                
        })
    }
     
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//MARK: -TableViewDatasource
extension BecomeInfluencerViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (becomeInfluencerArray?.count)!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height: String?
        if IS_IPAD() {
            height = (((becomeInfluencerArray![indexPath.row] as! [String: AnyObject])["heightOfRowiPad"]!) as! String)
        } else {
            height = (((becomeInfluencerArray![indexPath.row] as! [String: AnyObject])["heightOfRowiPhone"]!) as! String)
        }
        var floatHeight: CGFloat?
        if let number = NSNumberFormatter().numberFromString(height!) {
            floatHeight = CGFloat(number)
        }
        return floatHeight!
    }
}

//MARK:- TextFieldDelegate
extension BecomeInfluencerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == textName {
            textMobileNumber.becomeFirstResponder()
        } else if textField == textMobileNumber {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == textType{
               self.view.endEditing(true)
        }
    
      
        if textField == textType {
            GPPickerViewController.showPickerController(self, isDatePicker: false, pickerArray: self.arrayType, position: .Bottom, pickerTitle: "", preSelected: "") { (value, index) in
                if String(value) != "" {
                    let listArr = value.componentsSeparatedByString("+")
                    self.strTypeId = listArr[1]
                    self.textType.text = listArr[0]
                }
            }
            return false
        } else {
            return true
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var searchText =  textField.text
        
        if textField == textMobileNumber {
            if (range.length == 0){
                let stringNew = NSMutableString(string: textField.text!)
                stringNew.insertString(string, atIndex: range.location)
                searchText = stringNew as String
            }
            else if(range.length == 1){
                let stringNew = NSMutableString(string: textField.text!)
                stringNew.deleteCharactersInRange(range)
                searchText = stringNew as String
            }
            if searchText!.utf16.count == 11 &&   searchText!.utf16.count > 0{
                return false
            }
            else{
                return true
            }
        }
        return true
    }
}

//MARK:- API Calling
extension BecomeInfluencerViewController {
    func becomeInfluencerAPICalling() {
        APIHandler.handler.becomeInfluencer(forUser: Globals.sharedClient.userID, name: textName.text, email: String(OBJ_FOR_KEY(kUserEmail)!), contact_no: Int(textMobileNumber.text!), address: String(OBJ_FOR_KEY(kUserAddress)!),aboutme: textViewAboutMe.text, user_type: kInfluencer, influencer_type_id: Int(strTypeId!), filetype: fileType, filename: labelUploadFile.text, base64: strBase64, success: { (response) in
            debugPrint(response)
          	let dictUserDetails = response.dictionary!["User"]
           
            SET_OBJ_FOR_KEY(dictUserDetails!["username"].string!, key: kUserName)
            SET_OBJ_FOR_KEY(dictUserDetails!["user_type"].string!, key: kUserType)
            SET_OBJ_FOR_KEY(dictUserDetails!["address"].string!, key: kUserAddress)
            SET_OBJ_FOR_KEY(dictUserDetails!["contact_no"].intValue, key: kUserContactNumber)
            SET_OBJ_FOR_KEY(dictUserDetails!["about_me"].string!, key: kUserAboutUS)
            
            
            }) { (error) in
        }
    }
}


