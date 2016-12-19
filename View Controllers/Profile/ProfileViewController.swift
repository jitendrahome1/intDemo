//
//  ProfileViewController.swift
//  Greenply
//
//  Created by Jitendra on 8/31/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//
enum eProfileEdit {
    case kprofileEdit
    case kprofileNotEdit
}
import UIKit
import KCFloatingActionButton
class ProfileViewController: BaseTableViewController, HeaderButtonDeleagte, SelectCityDeleagte, UITextFieldDelegate {
    
    @IBOutlet weak var buttonSelectCity: UIButton!
    @IBOutlet weak var buttonBirthDate: UIButton!
    @IBOutlet weak var imageProfileBG: UIImageView!
    @IBOutlet weak var imageUserProfile: UIImageView!
    @IBOutlet weak var textMobileNumber: JATextField!
    @IBOutlet weak var textViewAboutUs: JAPlaceholderTextView!
    var eprofileEditStatus: eProfileEdit = .kprofileNotEdit
    @IBOutlet weak var buttonEditProfile: UIButton!
    @IBOutlet weak var textLocation: JATextField!
    @IBOutlet weak var textDateOfBirth: JATextField!
    @IBOutlet weak var textName: JATextField!
    var pDate: NSDate!
    
    @IBOutlet weak var buttonUploadImag: UIButton!
    @IBOutlet weak var labelUploadPic: UILabel!
    
    var floatingBtn: PDFloating?
    override func viewDidLoad() {
        super.viewDidLoad()
        textName.returnKeyType = .Next
        textMobileNumber.returnKeyType = .Default
        textName.delegate = self
        textMobileNumber.delegate = self
     
        buttonUploadImag.setAttributedTitle(NSAttributedString(string: "Upload Picture", attributes: [NSUnderlineStyleAttributeName : 1,NSFontAttributeName : PRIMARY_FONT( IS_IPAD() ? 20.0 : 16.0)!,NSForegroundColorAttributeName : UIColorRGB(57, g: 181, b: 74)!]), forState: .Normal)
        NavigationHelper.helper.headerViewController?.delegateButton = self
        self.textFieldEditable(false)
        self.backgroundImageView.image = UIImage(named: kTableViewBackgroundImage)
        if IS_OF_4_INCH() {
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageCircle()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NavigationHelper.helper.tabBarViewController!.hideTabBar()
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_PROFILE
        if eprofileEditStatus == .kprofileEdit {
            NavigationHelper.helper.headerViewController?.addHeaderButton(KHeaderTickButton)
        }
        else {
            self.setFloatingButton()
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        floatingBtn!.removeButton()
    }
    
    @IBAction func actionUploadImg(sender: UIButton) {
        GPImagePickerController.pickImage(onController: self, sourceRect: IS_IPAD() ? self.buttonEditProfile.frame : nil, didPick: { (image) in
            let imageData = image// info[UIImagePickerControllerOriginalImage] as? UIImage
            self.imageUserProfile.image = imageData
        }) {
            
        }
    }
    func setBoaderColor(pTextView: UITextView)
    {
        pTextView.layer.borderWidth = 0.8;
        pTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
    }
    
    // MARK:- Action
    @IBAction func actionEditProfile(sender: UIButton) {
        
        GPImagePickerController.pickImage(onController: self, sourceRect: IS_IPAD() ? self.buttonEditProfile.frame : nil, didPick: { (image) in
            let imageData = image// info[UIImagePickerControllerOriginalImage] as? UIImage
            self.imageProfileBG.image = imageData
        }) {
            
        }
    }
    
    @IBAction func actionSelectCity(sender: UIButton) {
        let loctionCity = otherStoryboard.instantiateViewControllerWithIdentifier(String(LocationSeacrhViewController)) as! LocationSeacrhViewController
        loctionCity.delegateCity = self
        self.navigationController?.pushViewController(loctionCity, animated: true)
    }
    @IBAction func actionSave(sender: UIButton) {
        
        if !(self.ValidateFields())
        {
            print(" some thing is missing")
            return;
        }
        self.view.endEditing(true)
        self.editUserProfile()
    }
    
    @IBAction func actionBirthDate(sender: UIButton) {
        self.view.endEditing(true)
        GPPickerViewController.showPickerController(self, isDatePicker: true, pickerArray: [], position: .Bottom, pickerTitle: "", preSelected: "") { (value, index) in
            
            if let strDateValue = value {
                self.textDateOfBirth.text = strDateValue as? String
            }
            
        }
    }
    
}

extension ProfileViewController {
    
    // MARK: UITableViewDelegate methods
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        switch indexPath.row {
        case 0:
            return IS_IPAD() ? 300 : 230
        case 1..<5:
            return IS_IPAD() ? 60 : 55
        case 5:
            return IS_IPAD() ? 170 : 130
        //
        default:
            // return IS_IPAD() ? 60 : 55
            return IS_IPAD() ? 90 : 70
        }
    }
    
}
extension ProfileViewController {
    func textFieldEditable(isEditable: Bool) {
        if isEditable == true {
            self.getUserDetails()
            
            textName.userInteractionEnabled = isEditable
            self.buttonUploadImag.hidden = false
            textMobileNumber.userInteractionEnabled = isEditable
            self.buttonEditProfile.hidden = false
            buttonBirthDate.userInteractionEnabled = isEditable
            textViewAboutUs.userInteractionEnabled = isEditable
            buttonSelectCity.userInteractionEnabled = isEditable
            NavigationHelper.helper.headerViewController?.addHeaderButton(KHeaderTickButton)
        }
        else {
            self.buttonEditProfile.hidden = true
            self.buttonUploadImag.hidden = true
            self.getUserDetails()
            textName.userInteractionEnabled = isEditable
            textLocation.userInteractionEnabled = isEditable
            textDateOfBirth.userInteractionEnabled = isEditable
            textMobileNumber.userInteractionEnabled = isEditable
            textViewAboutUs.userInteractionEnabled = isEditable
            buttonBirthDate.userInteractionEnabled = isEditable
            buttonSelectCity.userInteractionEnabled = isEditable
            NavigationHelper.helper.headerViewController?.addHeaderButton(KMenuButton)
        }
    }
    // MARK:- Header Button Delagte
    func didTapMenuButton(strButtonType: String) {
        if strButtonType == KHeaderTickButton {
            if !(self.ValidateFields())
            {
                print(" some thing is missing")
                return;
            }
            self.view.endEditing(true)
            self.editUserProfile()
        } else {
            
        }
    }
    // ImageView Circle
    func imageCircle() {
        self.imageUserProfile.layoutIfNeeded()
        self.imageUserProfile.layer.cornerRadius = self.imageUserProfile.frame.size.height / 2
        self.imageUserProfile.layer.borderWidth = 0.8;
        self.imageUserProfile.layer.borderColor = UIColorRGB(57, g: 181, b: 74)!.CGColor
        self.imageUserProfile.layer.masksToBounds = true
    }
    
    // Mark:- Select City Delagte
    func didFinishCitySelected(selectCity: String?) {
        self.textLocation.text = selectCity!
        self.tableView.reloadData()
    }
    
    func getUserDetails() {
        textName.text = OBJ_FOR_KEY(kUserName) as? String
        textMobileNumber.text = OBJ_FOR_KEY(kUserContactNumber) as? String
        textLocation.text = OBJ_FOR_KEY(kUserAddress) as? String
        textViewAboutUs.text = OBJ_FOR_KEY(kUserAboutUS) as? String
        if let birthDate = OBJ_FOR_KEY(kUserBirthDate) as? String {
            
             textDateOfBirth.text =  birthDate
//            let strBirthDate  = birthDate as! Double
//            textDateOfBirth.text =  NSDate.convertTimeStampToDate(strBirthDate)
           
        }else{
             if let birthDate = OBJ_FOR_KEY(kUserBirthDate)
             {
            let strBirthDate  = birthDate as! Double
            textDateOfBirth.text =  NSDate.convertTimeStampToDate(strBirthDate)
            }
        }
        
    }
    
    // mark-  ValidateFields
    func ValidateFields() -> Bool
    {
        self.view.endEditing(true)
        let result = true
        if self.textName.text == "" {
            Toast.show(withMessage: ENTER_USERNAME)
            return false
        }
        else if self.textMobileNumber.text == "" {
            Toast.show(withMessage: ENTER_MOBILE_NUMBER)
            return false
        }
        else if self.textDateOfBirth.text == ""{
            Toast.show(withMessage: ENTER_BIRTH_DATE)
            return false
        }
        else if self.textViewAboutUs.text == ""{
            Toast.show(withMessage: ENTER_ABOUT_US)
            return false
        }
        return result
    }
    

        
        // MARK: UITextFieldDelegate methods
        func textFieldShouldReturn(textField: UITextField) -> Bool {
            
            if textField == self.textName{
                self.textMobileNumber.becomeFirstResponder()
            }
            else if textField == self.textMobileNumber
            {
                textMobileNumber.resignFirstResponder()

                
            }
            
            return true
        }
        

    

}

extension ProfileViewController {
    
    // MARK: UITableViewDelegate methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount: Int?
        if eprofileEditStatus == .kprofileNotEdit {
            rowCount = 6
        } else {
            rowCount = 7
        }
        return rowCount!
    }
}

extension ProfileViewController {
    func setFloatingButton() {
        
        floatingBtn = PDFloating(withPosition: .bottomRight, size: IS_IPAD() ? 45 : 40, numberOfPetals: 5, images: ["FloatingFollowing", "FloatingFollowers", "FloatingProject", "FloatingIdeas", "FloatingEditProfile"], labelStrings: ["My Followings", "My Followers", "My Projects", "My Ideas", "Edit Profile"])
        // floatingBtn!.setImage(UIImage(named: "CommentsFlootingEditIcon"), forState: .Normal)
        floatingBtn!.titleLabel?.font = UIFont(name: FONT_NAME, size: IS_IPAD() ? 40 : 30)
        floatingBtn!.setTitle("+", forState: .Normal)
        floatingBtn!.backgroundColor = UIColorRGB(57, g: 181, b: 74)
        floatingBtn!.layer.cornerRadius = floatingBtn!.layer.frame.height / 2
        floatingBtn!.buttonActionDidSelected = { (indexSelected) in
            self.didSelectMenuOptionAtIndex(indexSelected)
        }
        
        NavigationHelper.helper.mainContainerViewController?.view.addSubview(self.floatingBtn!)
    }
    
    func didSelectMenuOptionAtIndex(row: Int) {
        
        switch row {
        case 0:
            let followersListVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(FollowersViewController)) as! FollowersViewController
            followersListVC.showFlowerBtn = false
            followersListVC.titleText = TITLE_FOLLOWINGS
            NavigationHelper.helper.contentNavController!.pushViewController(followersListVC, animated: true)
            floatingBtn!.removeButton()
        case 1:
            let followersListVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(FollowersViewController)) as! FollowersViewController
            followersListVC.showFlowerBtn = true
            followersListVC.titleText = TITLE_FOLLOWERS
            NavigationHelper.helper.contentNavController!.pushViewController(followersListVC, animated: true)
            floatingBtn!.removeButton()
        case 2:
            
            let portfolioListingVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(ProjectListingController)) as! ProjectListingController
            portfolioListingVC.ePortfolioTitleStatus = .eMyPortfolioTitle
            NavigationHelper.helper.contentNavController!.pushViewController(portfolioListingVC, animated: true)
            floatingBtn!.removeButton()
        case 3:
            let ideaListingVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(IdeaListingController)) as! IdeaListingController
            NavigationHelper.helper.contentNavController!.pushViewController(ideaListingVC, animated: true)
            ideaListingVC.eIdeaListingTitleStaus = .eMyIdeaTitle
            ideaListingVC.eButtonEditStatus = .eButtonShow
            
            floatingBtn!.removeButton()
        case 4:
            let userStatus = OBJ_FOR_KEY(kUserTypeStatus)?.integerValue
            if userStatus == 1{
                let influncerProfileVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(InfluencerProfileViewController)) as! InfluencerProfileViewController
                NavigationHelper.helper.contentNavController!.pushViewController(influncerProfileVC, animated: true)
            }
                
                //            if OBJ_FOR_KEY(kUserType) as! String == kInfluencer{
                //                let influncerProfileVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(InfluencerProfileViewController)) as! InfluencerProfileViewController
                //                NavigationHelper.helper.contentNavController!.pushViewController(influncerProfileVC, animated: true)
                //            }
            else{
                floatingBtn!.removeButton()
                self.eprofileEditStatus = .kprofileEdit
                self.textFieldEditable(true)
                self.tableView.reloadData()
            }
            
            //			let editProfileVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(InfluencerProfileViewController)) as! InfluencerProfileViewController
            //			NavigationHelper.helper.contentNavController!.pushViewController(editProfileVC, animated: true)
            break
        default:
            "Nothing to do"
        }
    }
}


// MARK:- Api Call
extension ProfileViewController {
    // Profile edit Api
    func editUserProfile() {
        APIHandler.handler.editSeekerProfileWith(forUserID: Globals.sharedClient.userID!, userName: self.textName.text!, userContactnumber: self.textMobileNumber.text!, userAddress: self.textLocation.text!, aboutMe: self.textViewAboutUs.text!, userBirthDate: self.textDateOfBirth.text!,zipCode:OBJ_FOR_KEY(kUserZipCode) as? String, success: { (response) in
            
            print("UpuserDetails \(response.dictionaryObject!)")
            
            Toast.show(withMessage: PROFILE_UPDTAE)
            
            let dictUserDetails = response.dictionary!["User"]
            SET_OBJ_FOR_KEY(dictUserDetails!["name"].string!, key: kUserName)
            SET_OBJ_FOR_KEY(dictUserDetails!["user_type"].string!, key: kUserType)
            SET_OBJ_FOR_KEY(dictUserDetails!["city"].string!, key: kUserAddress)
            SET_OBJ_FOR_KEY(dictUserDetails!["contact_no"].string!, key: kUserContactNumber)
            SET_OBJ_FOR_KEY(dictUserDetails!["about_me"].string!, key: kUserAboutUS)
            if let _ = dictUserDetails!["birth_date"].double{
            SET_OBJ_FOR_KEY(dictUserDetails!["birth_date"].double!, key: kUserBirthDate)
            }
          
            self.getUserDetails()
            
            self.setFloatingButton()
            self.eprofileEditStatus = .kprofileNotEdit
            self.textFieldEditable(false)
            self.tableView.reloadData()
            
            // NavigationHelper.helper.contentNavController?.popViewControllerAnimated(true)
            
        }) { (error) in
            
        }
    }
}

