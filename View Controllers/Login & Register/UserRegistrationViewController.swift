//
//  UserRegistrationViewController.swift
//  Greenply
//
//  Created by Jitendra on 8/29/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class UserRegistrationViewController: BaseTableViewController, UITextFieldDelegate, SelectCityDeleagte {

	@IBOutlet weak var textUserName: JATextField!
	@IBOutlet weak var textEmailID: JATextField!
	@IBOutlet weak var textContactNumber: JATextField!
	@IBOutlet weak var textCity: JATextField!
    @IBOutlet weak var textPincode: JATextField!
	@IBOutlet weak var textPassword: JATextField!
	@IBOutlet weak var textConfirmPassword: JATextField!

    var strSocialType: String = ""
    var strSocailID: String = ""
	override func viewDidLoad() {
        self.setKeyBordReturnStyleType()
		self.crossButtonEnabled = true
		self.backButtonEnabled = true
		super.viewDidLoad()
		self.setNavigationTitle(TITLE_USERREGISTRATION)
        self.textContactNumber.delegate = self
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        if let _ =  OBJ_FOR_KEY(kUserName){
         textUserName.text = OBJ_FOR_KEY(kUserName) as? String
        }
        if let _ =  OBJ_FOR_KEY(kUserEmail){
            textEmailID.text = OBJ_FOR_KEY(kUserEmail) as? String
        }
        
//        if let _ =  OBJ_FOR_KEY(kUserSocialID){
//            strSocailID = OBJ_FOR_KEY(kUserSocialID) as? String
//        }else{
//           strSocailID = ""
//        }
//        if let _ =  OBJ_FOR_KEY(kSocailTypeFacebook){
//            strSocialType = OBJ_FOR_KEY(kSocailTypeFacebook) as? String
//        }else{
//            strSocialType = ""
//        }
      
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	// MARK:- Action

	@IBAction func actionUserRegistration(sender: UIButton) {
		self.view.endEditing(true)
		guard textUserName.hasText() && textEmailID.hasText() && textEmailID.text!.isValidEmail && textCity.hasText() && textPincode.hasText() && textContactNumber.hasText() && textPassword.hasText() && textConfirmPassword.hasText() && textConfirmPassword.text == textPassword.text else {

			if textUserName.text!.isBlank
			{
				Toast.show(withMessage: ENTER_USERNAME)
			}
			else if textEmailID.text!.isBlank
			{
				Toast.show(withMessage: ENTER_EMAIL_ID)
			}
			else if !(textEmailID.text!.isValidEmail)
			{
				Toast.show(withMessage: ENTER_VALID_EMAIL)
			}
            else if textContactNumber.text!.isBlank {
                
                Toast.show(withMessage: ENTER_MOBILE_NUMBER)
            }
			else if textCity.text!.isBlank {
				Toast.show(withMessage: ENTER_CITY)
			}
                
            else if textPincode.text!.isBlank {
                Toast.show(withMessage: ENTER_PINCODE)
            }
			
			else if textPassword.text!.isBlank {

				Toast.show(withMessage: ENTER_PASSWORD)
			}
			else if textConfirmPassword.text!.isBlank {

				Toast.show(withMessage: ENTER_CONFIRM_PASSWORD)
			}
			else if !(textConfirmPassword.text == textPassword.text) {
				Toast.show(withMessage: PASSWORD_NOT_MATCH)
			}
			else { }
			return
		}

		CDSpinner.show(onViewControllerView: self.view)
		// API Calling
        APIHandler.handler.userRegistration(textUserName.text!, password: textPassword.text!, email: textEmailID.text!, contact_no: textContactNumber.text!, city: textCity.text!, pincode: textPincode.text!, socialID: strSocailID, socialType:strSocialType, success: { (response) in
			let dictUserDetails = response.dictionary!["User"]
			let verifictionCodeVC = loginStoryboard.instantiateViewControllerWithIdentifier(String(VerificationCodeViewController)) as! VerificationCodeViewController
			verifictionCodeVC.UserID = dictUserDetails!["id"].intValue
			self.navigationController?.pushViewController(verifictionCodeVC, animated: true)

		}) { (error) in
           debugPrint(error)
       // Toast.show(withMessage: kEmailExists)
		}
        
        
	}
    
    @IBAction func actionSelectCity(sender: UIButton) {
        let loctionCity = otherStoryboard.instantiateViewControllerWithIdentifier(String(LocationSeacrhViewController)) as! LocationSeacrhViewController
        loctionCity.delegateCity =  self
        self.navigationController?.pushViewController(loctionCity, animated: true)
    }
    // Mark:- Select City Delagte
    func didFinishCitySelected(selectCity: String?) {
        self.textCity.text =  selectCity!
        self.tableView.reloadData()
    }
    
    //  function change keybord 
    
    func setKeyBordReturnStyleType(){
        self.textUserName.returnKeyType = .Next
        self.textEmailID.returnKeyType = .Next
        self.textUserName.returnKeyType = .Next
        self.textPassword.returnKeyType = .Next
        self.textConfirmPassword.returnKeyType = .Default
    }
}
extension UserRegistrationViewController {

	// MARK: UITextFieldDelegate methods
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
	{
		switch indexPath.row {
		case 0:
			return IS_IPAD() ? 430 : 200
		case 1..<8:
			return IS_IPAD() ? 80 : 60
		default:
			return IS_IPAD() ? 80 : 70
		}
	}
}



extension UserRegistrationViewController {

	// MARK: UITextFieldDelegate methods
	func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.textUserName{
            textEmailID.becomeFirstResponder()
        }
        else if textField == self.textEmailID{
            textContactNumber.becomeFirstResponder()
        }
        else if textField == self.textPassword{
            textConfirmPassword.becomeFirstResponder()
        }
        else if textField == self.textConfirmPassword{
            textConfirmPassword.resignFirstResponder()
        }
			return true
	}
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
         var searchText =  textField.text

        if textField == textContactNumber{
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
        
        if textField == textPincode{
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
            if searchText!.utf16.count == 7 &&   searchText!.utf16.count > 0{
                return false
            }
            else{
                return true
            }
        }

        
        return true
         }
}
