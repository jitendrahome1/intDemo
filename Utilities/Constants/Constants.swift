//
//  Constants.swift
//  Greenply
//
//  Created by Rupam Mitra on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import Foundation
import UIKit

let SYSTEM_VERSION = UIDevice.currentDevice().systemVersion

let SCREEN_WIDTH = CGRectGetWidth(UIScreen.mainScreen().bounds)
let SCREEN_HEIGHT = CGRectGetHeight(UIScreen.mainScreen().bounds)
let MAIN_WINDOW = UIApplication.sharedApplication().windows.first

func IS_OF_4_INCH() -> Bool {
	switch UIDevice.currentDevice().modelName {
	case .iPhone5, .iPhone5S, .iPhone5C, .iPhoneSE:
		return true
	default:
		return false
	}
}



// GOOGLE LOCATION SEARCH KYE
let GOOGLE_MAP_KEY = "AIzaSyDZqJOc5iSvCMkNStGStX0_KioP1yB4E3M" // THIS KYE USER ONLY FOR TESTING USED CHANGE WHEN YOU GET CLIENT GOOGLE AP KYE.
let GOOGLE_BASE_URL_STRING = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
//let  GOOGLE_BASE_URL_STRING = "https://maps.googleapis.com/maps/api/geocode/json?components=country:IN"
//MARK:- User Type
let kSeeker = "seeker"
let kInfluencer = "influencer"
// Image Like And Un Like
let kImageLikeSelected = "ProjectDetailsLikeSelect"
let kImageLikeDeselected = "ProjectLikeDeselected"

// Image Pinned Selected or DeSeleted
let kImagePinnedSelected = "ProjectPinSelected"
let kImagePinnedDselected = "ProjectPinDeselected"

// FeveritIocn Selected And Dsleted
let kFevImageSeleted = "FeveritIcon"
let kFevImageDeSeleted = "FeveritIconDeseleted"

// Header Button Type

let kPLusButtonType = "addPlus"
let kMenuButtonType = "addMenu"

//EmailExists
let kEmailExists = "Email already exists"

//MARK: API Endpoints
let LOGIN = "/users/login"
let USER_REGISTRATION = "/users"
let FORGOT_RESET_PASSWORD = "/users/forgot-password"
let DASHBOARD = "/dashboards"
let IDEA_LIST = "/ideas"
let WRITE_COMMENT = "/comments"
let INFLUENCER_TYPE = "/influencers"
let FILTER_ATTRIBUTE = "/attributes?AttributesSearch[moduleType]=user"
//let INFLUENCER_FILTER = "/users?UserSearch[user_type]=influencer"
let MY_PINNED = "/pins"
let WRITE_REVIEW = "/ratings"
let ADD_IDEA_PIN = "/pins"
let INFLUENCER_LIKE = "/influencerlikes"
let IDEA_LIKE = "/idealikes"
let PORTFOLIO_IMAGE_LIKE = "/portfolioimagelikes"
let FOLLOWS_LIST = "/follows"
let ATTRIBUTES_FOR_PROJECTS = "/attributes?expand=attributeValues"
let ADD_IDEAS = "/ideas"
let NOTIFICATIONS = "/notifications"
let ABOUT_US = "/pages/page/about-us"
let HOW_ITS_WORK = "/pages/page/how-it-works"
let ADD_FOLLOW = "/follows"
let PORTFOLIO_LIKE = "/portfoliolikes"
let INFLUENCER_LIST = "/users?UserSearch[user_type]="
let PORTFOLIO_LIST = "/portfolios"
let TAGS_LIST = "/tags"
let SKILLS_LIST = "/skills"
let UPLOAD_PROJECT = "/portfolios"


let ATTRIBUTES = "/attributes?AttributesSearch[moduleType]=portfolios"
let REPORT_ABUSE = "/abuses"
let SOCIAL_LOGIN = "/users/social-login"
func CHANGE_PASSWORD(forUser userID: Int) -> String {
	return "/users/\(userID)"
}
func BECOME_INFLUENCER(forUser userID: Int) -> String {
	return "/users/\(userID)"

}
func EDIT_INFLUENCER(forUserId userID: Int) -> String {
	return "/users/\(userID)"
}

//func RATE_REVIEW(forUser userID: Int) -> String {
//	return "/ratings/user-rating/\(userID)?lat=29.46786&long=-98.53506"
//}
func RATE_REVIEW(forUser userID: Int) -> String {
	return "/ratings/user-rating/\(userID)"
}

func VERIFY_FORGOT_PASSWORD_OTP(forUser userID: Int) -> String {
	return "/users/\(userID)/otp-password-verify"
}
func VERIFY_REGISTRATION_OTP(forUser userID: Int) -> String
{
	return "/users/\(userID)/otp-verify"
}
func RESEND_OTP(forUser userID: Int) -> String
{
	return "/users/\(userID)/resend-otp"
}
func IDEA_DETAILS(forIdeaID ideaID: Int) -> String {
	return "/ideas/\(ideaID)?expand=user,comments"
}
func REMOVE_IDEA_PIN(forIDEAID ideaID: Int) -> String {
	return "/pins/\(ideaID)"
}
func UNFOLLOW(forFollowID followerID: Int) -> String {
	return "/follows/\(followerID)"
}
func INFLUENCERDISLIKE(forInfluencerID influencerID: Int) -> String {
	return "/influencerlikes/\(influencerID)"
}
func PORTFOLIOIMAGEDISLIKE(forPortfolioImageID imageID: Int) -> String {
	return "/portfolioimagelikes/\(imageID)"
}
func IDEADISLIKE(forIdeaID ideaID: Int) -> String {
	return "/idealikes/\(ideaID)"
}
func EDITSEEKERPROFILE(forUserID ideaID: Int) -> String {
	return "/users/\(ideaID)"
}
func MY_PORTFOLIO(forUser userID: Int?, pageNumber: String, perPage: String) -> String {
// return "/portfolios/?PortfolioSearch[user_id]=\(userID)&page=\(pageNumber)&per-page\(perPage)"
	return "/portfolios?PortfolioSearch[user_id]=\(userID!)"
}

func IDEALISTWITH(forUserID userID: Int?) -> String {
	return "/ideas?IdeaSearch[user_id]=\(userID!)"

}

func PORTFOLIO_DETAILS(forPortFolioID portFolioID: Int?) -> String {
	return "/portfolios/\(portFolioID!)?expand=user"
}

func INFLUENCERDETAILS(forUserID userID: Int?) -> String {
	return "/users/\(userID!)"

}
func EDIT_IDEA(forIdeaID ideaID: Int?) -> String {
	return "/ideas/\(ideaID!)"
}
func EDIT_PORJECT(forProjectID projectID: Int?) -> String {
 
return "/portfolios/portfolio-update/\(projectID)"
}

func EDIT_PROJECT_IMAGE(forPortfolioImageID ImageID: Int?) -> String {
    return "/portfolioimages/\(ImageID!)"
}


// MARK: Storyboard
let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
let otherStoryboard: UIStoryboard = UIStoryboard(name: "Others", bundle: nil)
// MARK:- Font
let FONT_NAME = "Roboto-Regular"
let kTableViewBackgroundImage = "BackgroundImage"
// Header Button Image Name
let kSearchButton = "SearchButton"
let kFilterBttton = "FilterBttton"
let kPluseImage = "HeaderPlus"
let kMenuImage = "MenuIcon"
let kHeaderTickImage = "HeaderTick"

// Add plus Button.
let kPluseButton = "PlusButton"
let KMenuButton = "menuButton"
let KHeaderTickButton = "headerTick"
// MARK:- APP Text
let APP_TITLE = "Greenply"
//MARK:- Message Successfully
let PROFILE_SUCCESS = "Profile updated successfully"

// MARK: User Defaults Keys
let kUserID = "userID"
let kToken = "token"
let kUserName = "userName"
let kUserType = "userType"
let kUserContactNumber = "UserContactNumber"
let kUserAddress = "userAddress"
let kUserEmail = "userEmail"
let kUserAboutUS = "aboutUs"
let kUserBirthDate = "birthDate"
let kUserTypeStatus = "userTypeStatus"
let kUserSocialID = "socialID"
let kUserZipCode = "zipCode"
let kUserTotalNotification = "totalNotification"
let kSocailTypeFacebook = "facebookLogin"
let kSocailTypeGmail = "Google"
// REport AND Abus
let kReportAbusIdea = "idea"
let kReportAbusComment = "comment"
let kReportAbusPortfolio = "portfolio"
let kReportAbusUser = "user"
// Report abus Image

let mReportAlredy = "You've already submitted a report for this item"

let kReportAbusGreenImage = "ProjectDetailsAlertIconGreen"
let kReportAbusRedImage = "ProjectDetailsAlertIcon"

func IS_IPAD() -> Bool {

	switch UIDevice.currentDevice().userInterfaceIdiom {
	case .Phone: // It's an iPhone
		return false
	case .Pad: // It's an iPad
		return true
	case .Unspecified: // undefined
		return false
	default:
		return false
	}
}

func SET_OBJ_FOR_KEY(obj: AnyObject, key: String) {
	NSUserDefaults.standardUserDefaults().setObject(obj, forKey: key)
}

func OBJ_FOR_KEY(key: String) -> AnyObject? {
	if NSUserDefaults.standardUserDefaults().objectForKey(key) != nil {
		return NSUserDefaults.standardUserDefaults().objectForKey(key)!
	}
	return nil
}

func SET_INTEGER_FOR_KEY(integer: Int, key: String) {
	NSUserDefaults.standardUserDefaults().setInteger(integer, forKey: key)
}

func INTEGER_FOR_KEY(key: String) -> Int? {
	return NSUserDefaults.standardUserDefaults().integerForKey(key)
}

func SET_FLOAT_FOR_KEY(float: Float, key: String) {
	NSUserDefaults.standardUserDefaults().setFloat(float, forKey: key)
}

func FLOAT_FOR_KEY(key: String) -> Float? {
	return NSUserDefaults.standardUserDefaults().floatForKey(key)
}

func SET_BOOL_FOR_KEY(bool: Bool, key: String) {
	NSUserDefaults.standardUserDefaults().setBool(bool, forKey: key)
}

func BOOL_FOR_KEY(key: String) -> Bool? {
	return NSUserDefaults.standardUserDefaults().boolForKey(key)
}

func REMOVE_OBJ_FOR_KEY(key: String) {
	NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
}

func UIColorRGB(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor? {
	return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
}
func UIBorderColor() -> UIColor {
	return UIColor(red: 212.0 / 255.0, green: 212.0 / 255.0, blue: 212.0 / 255.0, alpha: 1.0)
}

func UIColorRGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor? {
	return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

func FIRST_WINDOW() -> AnyObject? {
	return UIApplication.sharedApplication().windows.first!
}

func APP_DELEGATE() -> AppDelegate? {
	return UIApplication.sharedApplication().delegate as? AppDelegate
}

func SWIFT_CLASS_STRING(className: String) -> String? {
	return "\(NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String).\(className)";
}

func PRIMARY_FONT(size: CGFloat) -> UIFont? {
	return UIFont(name: FONT_NAME, size: size)
}

//func SECONDARY_FONT(size: CGFloat) -> UIFont? {
// return UIFont(name: "Roboto-Regular", size: size)!
//}

/*
 if #available(iOS 9.0, *)
 {
 //System version is more than 9.0
 }
 else
 {

 }
 */