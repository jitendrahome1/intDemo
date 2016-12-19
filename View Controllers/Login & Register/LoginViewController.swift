//
//  LoginViewController.swift
//  Greenply
//
//  Created by Jitendra on 8/26/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
class LoginViewController: BaseTableViewController, GIDSignInDelegate,GIDSignInUIDelegate {
let googleClientID = "541996200643-mfhklg3ii8fsop8kf2hcck0gl0e5d2oq.apps.googleusercontent.com"
	@IBOutlet weak var textEmailID: JATextField!
	@IBOutlet weak var textPassword: JATextField!
    
    var socialLoginSucceed: ((succeed: Bool)->())!
	override func viewDidLoad() {
        self.textEmailID.returnKeyType = .Next
        self.textPassword.returnKeyType = .Default
		self.crossButtonEnabled = true
		self.setNavigationTitle(TITLE_LOGIN)
		super.viewDidLoad()
		textPassword.placeholder = "Password"
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: Actions
	@IBAction func actionForgotPassword(sender: AnyObject) {
		let forgotPasswordVC = loginStoryboard.instantiateViewControllerWithIdentifier(String(ForgotPasswordViewControllerStepOne)) as! ForgotPasswordViewControllerStepOne
		self.navigationController?.pushViewController(forgotPasswordVC, animated: true)

	}

	@IBAction func actionLoginFB(sender: AnyObject) {
		
			JASocailLogin.JALoginWithFacebook(delegate: self, sucessData: { (sucessData) -> Void in
           
                if sucessData as! NSObject == false{
                   // nothing work.
                }
                else{
                    SET_OBJ_FOR_KEY(sucessData["name"] as! String, key: kUserName)
                SET_OBJ_FOR_KEY(sucessData["email"] as! String, key: kUserEmail)
                  //SET_OBJ_FOR_KEY("fb",  key: kSocailTypeFacebook)
				print("user Details\(sucessData)")
			// calling to api,
				APIHandler.handler.loginWithWithSocialID(forSocialID: sucessData["id"] as? String, socailType: "fb", success: { (response) in
                    let dictUserDetails = response.dictionary!["User"]
                    
                    Globals.sharedClient.userID = dictUserDetails!["id"].intValue
                  
                    if dictUserDetails!["otp_status"].intValue != 0 {
                        SET_OBJ_FOR_KEY(dictUserDetails!["access_token"].string!, key: kToken)
                        SET_INTEGER_FOR_KEY(dictUserDetails!["id"].intValue, key: kUserID)
                        SET_OBJ_FOR_KEY(dictUserDetails!["name"].string!, key: kUserName)
                        SET_OBJ_FOR_KEY(dictUserDetails!["user_type"].string!, key: kUserType)
                        SET_OBJ_FOR_KEY(dictUserDetails!["address"].string!, key: kUserAddress)
                        SET_OBJ_FOR_KEY(dictUserDetails!["contact_no"].string!, key: kUserContactNumber)
                        SET_OBJ_FOR_KEY(dictUserDetails!["about_me"].string!, key: kUserAboutUS)
                        SET_OBJ_FOR_KEY(dictUserDetails!["email"].string!, key: kUserEmail)
                    
                        Globals.sharedClient.userID = dictUserDetails!["id"].intValue
                        
                        NavigationHelper.helper.reloadMenu()
                        self.dismissToDashboard()
                    }else {
                        APIHandler.handler.resendOTP(forUser: dictUserDetails!["id"].intValue, success: { (response) in
                            
                            }, failure: { (error) in
                                self.navigationItem.rightBarButtonItem!.enabled = true;
                        })
                        let verifictionCodeVC = loginStoryboard.instantiateViewControllerWithIdentifier(String(VerificationCodeViewController)) as! VerificationCodeViewController
                        verifictionCodeVC.UserID = dictUserDetails!["id"].intValue
                        self.navigationController?.pushViewController(verifictionCodeVC, animated: true)
                    }
                 
					print("Geeting responselsocil ==\(response)")
                    
                    
                    
					},failure: { (error) in
                
                        let userRegistrationVC = loginStoryboard.instantiateViewControllerWithIdentifier("UserRegistrationViewController") as! UserRegistrationViewController
                        userRegistrationVC.strSocailID = (sucessData["id"] as? String)!
                        userRegistrationVC.strSocialType = "fb"
                        self.navigationController?.pushViewController(userRegistrationVC, animated: true)
                         
                        print("error\(error)")
				})
            }
			}) { (failure) -> Void in
			}
	}

	@IBAction func actionLoginGoogle(sender: AnyObject) {

        self.initiateGoogleLoginProtocol { (succeed) in
        
        }
        
		//Toast.show(withMessage: "Under Construction...")
	}

	@IBAction func actionUserRegistration(sender: AnyObject) {

		let userRegistrationVC = loginStoryboard.instantiateViewControllerWithIdentifier("UserRegistrationViewController") as! UserRegistrationViewController
		self.navigationController?.pushViewController(userRegistrationVC, animated: true)

	}
	@IBAction func loginAction(sender: AnyObject) {
		self.view.endEditing(true)
		guard textEmailID.hasText() && textPassword.hasText() && textEmailID.text!.isValidEmail else {
			if textEmailID.text!.isBlank
			{
				Toast.show(withMessage: ENTER_EMAIL_ID)
			}
			else if !(textEmailID.text!.isValidEmail)
			{
				Toast.show(withMessage: ENTER_VALID_EMAIL)
			}
			else if textPassword.text!.isBlank
			{
				Toast.show(withMessage: ENTER_PASSWORD)
			}
			return
		}

		CDSpinner.show(onViewControllerView: self.view)
		// API Calling
		self.navigationItem.rightBarButtonItem!.enabled = false;

		APIHandler.handler.login(textEmailID.text!, password: textPassword.text!, success: { (response) in
			let dictUserDetails = response.dictionary!["User"]

			if dictUserDetails!["otp_status"].intValue != 0 {
				SET_OBJ_FOR_KEY(dictUserDetails!["access_token"].string!, key: kToken)
				SET_INTEGER_FOR_KEY(dictUserDetails!["id"].intValue, key: kUserID)
				SET_OBJ_FOR_KEY(dictUserDetails!["name"].string!, key: kUserName)
				SET_OBJ_FOR_KEY(dictUserDetails!["user_type"].string!, key: kUserType)
				SET_OBJ_FOR_KEY(dictUserDetails!["address"].string!, key: kUserAddress)
				SET_OBJ_FOR_KEY(dictUserDetails!["contact_no"].string!, key: kUserContactNumber)
				SET_OBJ_FOR_KEY(dictUserDetails!["about_me"].string!, key: kUserAboutUS)
				SET_OBJ_FOR_KEY(dictUserDetails!["email"].string!, key: kUserEmail)
                SET_OBJ_FOR_KEY(dictUserDetails!["totalNotification"].intValue, key: kUserTotalNotification)
              
             
                if let _  = dictUserDetails!["zip"].string {
                  SET_OBJ_FOR_KEY(dictUserDetails!["zip"].string!, key: kUserZipCode)
                }
              
                APIManager.manager.header += ["access-token": "\(OBJ_FOR_KEY(kToken)!)"]
				if let _ = dictUserDetails!["profile"].dictionary
				{
					SET_OBJ_FOR_KEY(dictUserDetails!["profile"]["status"].intValue, key: kUserTypeStatus)
				} else {
					SET_OBJ_FOR_KEY(500, key: kUserTypeStatus)
				}

				if let birthdate = dictUserDetails!["birth_date"].double {
                    
                   let strDate =  NSDate.dateFromTimeInterval(birthdate).getFormattedStringWithFormat()
					SET_OBJ_FOR_KEY(strDate!, key: kUserBirthDate)

				}
				Globals.sharedClient.userID = dictUserDetails!["id"].intValue
				APIManager.manager.header += ["access-token": "\(OBJ_FOR_KEY(kToken)!)"]

				NavigationHelper.helper.reloadMenu()
            
				self.dismissToDashboard()
			} else {
				APIHandler.handler.resendOTP(forUser: dictUserDetails!["id"].intValue, success: { (response) in

					}, failure: { (error) in
					self.navigationItem.rightBarButtonItem!.enabled = true;
				})
				let verifictionCodeVC = loginStoryboard.instantiateViewControllerWithIdentifier(String(VerificationCodeViewController)) as! VerificationCodeViewController
				verifictionCodeVC.UserID = dictUserDetails!["id"].intValue
				self.navigationController?.pushViewController(verifictionCodeVC, animated: true)
			}
		}) { (error) in
			debugPrint("Error \(error)")
			self.navigationItem.rightBarButtonItem!.enabled = true;
			Toast.show(withMessage: INVALID_CREDENTIALS)
		}

	}
	// MARK: Navigation
	func dismissToDashboard() {
		self.navigationController?.dismissViewControllerAnimated(true, completion: nil)

	}
}

extension LoginViewController {

	// MARK: UITableViewDelegate methods
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
	{
		switch indexPath.row {
		case 0:
			return IS_IPAD() ? 430 : 200

		case 1:
			return IS_IPAD() ? 100 : 60
		case 3:
			return IS_IPAD() ? 100 : 60
		case 2:
			return IS_IPAD() ? 120 : 96
		default:
			return IS_IPAD() ? 60 : 40
		}

	}

}

extension LoginViewController {

	// MARK: UITextFieldDelegate methods
	func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        if textField == self.textEmailID{
            self.textPassword.becomeFirstResponder()
        }
        else if textField == self.textPassword
        {
        textField.resignFirstResponder()
            
        }
		
		return true
	}
   
    
    // Google
     func initiateGoogleLoginProtocol(success:(suceed: Bool)->()) {
        Helper.sharedClient.isGoogleSignIn = true
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = googleClientID
        GIDSignIn.sharedInstance().signIn()
        socialLoginSucceed = success
        
    }
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error != nil) {
            socialLoginSucceed(succeed: false)
            debugPrint(error.description)
            return
        }
        
       // SET_OBJ_FOR_KEY(user.userID!, key: kUserSocialID)
        SET_OBJ_FOR_KEY(user.profile.name!, key: kUserName)
        SET_OBJ_FOR_KEY(user.profile.email!, key: kUserEmail)
        // SET_OBJ_FOR_KEY("google",  key: kSocailTypeFacebook)
        
        APIHandler.handler.loginWithWithSocialID(forSocialID: user.userID!, socailType: "google", success: { (response) in
            let dictUserDetails = response.dictionary!["User"]
            
            Globals.sharedClient.userID = dictUserDetails!["id"].intValue
            
            if dictUserDetails!["otp_status"].intValue != 0 {
                SET_OBJ_FOR_KEY(dictUserDetails!["access_token"].string!, key: kToken)
                SET_INTEGER_FOR_KEY(dictUserDetails!["id"].intValue, key: kUserID)
                SET_OBJ_FOR_KEY(dictUserDetails!["name"].string!, key: kUserName)
                SET_OBJ_FOR_KEY(dictUserDetails!["user_type"].string!, key: kUserType)
                SET_OBJ_FOR_KEY(dictUserDetails!["address"].string!, key: kUserAddress)
                SET_OBJ_FOR_KEY(dictUserDetails!["contact_no"].string!, key: kUserContactNumber)
                SET_OBJ_FOR_KEY(dictUserDetails!["about_me"].string!, key: kUserAboutUS)
                SET_OBJ_FOR_KEY(dictUserDetails!["email"].string!, key: kUserEmail)
                APIManager.manager.header += ["access-token": "\(OBJ_FOR_KEY(kToken)!)"]
                Globals.sharedClient.userID = dictUserDetails!["id"].intValue
                
                NavigationHelper.helper.reloadMenu()
                self.dismissToDashboard()
            }else {
                APIHandler.handler.resendOTP(forUser: dictUserDetails!["id"].intValue, success: { (response) in
                    
                    }, failure: { (error) in
                        self.navigationItem.rightBarButtonItem!.enabled = true;
                })
                let verifictionCodeVC = loginStoryboard.instantiateViewControllerWithIdentifier(String(VerificationCodeViewController)) as! VerificationCodeViewController
                verifictionCodeVC.UserID = dictUserDetails!["id"].intValue
                self.navigationController?.pushViewController(verifictionCodeVC, animated: true)
            }
            
            print("Geeting responselsocil ==\(response)")
            
            
            
            },failure: { (error) in
                
                let userRegistrationVC = loginStoryboard.instantiateViewControllerWithIdentifier("UserRegistrationViewController") as! UserRegistrationViewController
                userRegistrationVC.strSocailID = user.userID
                userRegistrationVC.strSocialType = "google"
                self.navigationController?.pushViewController(userRegistrationVC, animated: true)
                
                print("error\(error)")
        })
    }
}



