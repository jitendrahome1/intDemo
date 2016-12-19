//
//  ChangePasswordViewController.swift
//  Greenply
//
//  Created by Jitendra on 8/29/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseTableViewController {

	@IBOutlet weak var txtOldPassword: JATextField!
	@IBOutlet weak var txtNewPassword: JATextField!
	@IBOutlet weak var txtConfirmPassword: JATextField!
	override func viewDidLoad() {
		super.viewDidLoad()
        self.txtNewPassword.returnKeyType = .Next
        self.txtOldPassword.returnKeyType = .Next
        self.txtConfirmPassword.returnKeyType = .Default
		debugPrint(INTEGER_FOR_KEY(kUserID))
        txtOldPassword.placeholder = "Old Password"
		// Do any additional setup after loading the view.
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
		NavigationHelper.helper.tabBarViewController!.hideTabBar()
		NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_CHANGE_PASSWORD
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK:- Update Password
	@IBAction func Update(sender: UIButton) {
		self.view.endEditing(true)
        guard txtOldPassword.hasText() && txtNewPassword.hasText() && txtConfirmPassword.hasText() && txtNewPassword.text == txtConfirmPassword.text  else {
			if txtOldPassword.text!.isBlank {
				Toast.show(withMessage: ENTER_OLD_PASSWORD)
			}
			else if txtNewPassword.text!.isBlank {
				Toast.show(withMessage: ENTER_NEW_PASSWORD)
			}
			else if txtConfirmPassword.text!.isBlank {

				Toast.show(withMessage: ENTER_CONFIRM_PASSWORD)
			}
            else if !(txtNewPassword.text! == txtConfirmPassword.text!) {
                Toast.show(withMessage: PASSWORD_NOT_MATCH)
            }
            else{
                
            }
			return
		}

		// API Calling
		APIHandler.handler.changePassword(forUser: INTEGER_FOR_KEY(kUserID), old_password: txtOldPassword.text, new_password: txtNewPassword.text, success: { (response) in
			debugPrint("UserDetails Response -> \(response)")
			// Toast.show(withMessage: response["statusText"].stringValue)
            Toast.show(withMessage:PASSWORD_CHANGE)
			self.navigationController?.popViewControllerAnimated(true)
		}) { (error) in
			debugPrint("Error \(error)")
		}
	}
}

extension ChangePasswordViewController
{
	// MARK: UITableViewDelegate methods
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
	{
		switch indexPath.row {
		case 0:
			return (SCREEN_HEIGHT - (150 + 20)) / 2
		case 4:
			return (SCREEN_HEIGHT - 360) / 2
		default:
			return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
		}
	}
}

//extension ChangePasswordViewController {
//
//	// MARK: UITextFieldDelegate methods
//	func textFieldShouldReturn(textField: UITextField!) -> Bool {
//		if textField == txtOldPassword {
//			if txtOldPassword.hasText() {
//				txtNewPassword.becomeFirstResponder()
//			} else {
//				txtOldPassword.becomeFirstResponder()
//			}
//		} else if textField == txtNewPassword {
//			if txtNewPassword.hasText() {
//				txtConfirmPassword.becomeFirstResponder()
//			} else {
//				txtNewPassword.becomeFirstResponder()
//			}
//		} else {
//			if txtConfirmPassword.hasText() {
//				txtConfirmPassword.resignFirstResponder()
//			} else {
//				txtConfirmPassword.becomeFirstResponder()
//			}
//		}
//		return true
//	}
//
//}
extension ChangePasswordViewController {
    
    // MARK: UITextFieldDelegate methods
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if textField == txtOldPassword {
            self.txtNewPassword.becomeFirstResponder()
        } else if textField == txtNewPassword {
        self.txtConfirmPassword.becomeFirstResponder()
        }
        else if textField ==  self.txtConfirmPassword{
            self.txtConfirmPassword.resignFirstResponder()
        }
        return true
    }
    
}
