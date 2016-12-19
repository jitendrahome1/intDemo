//
//  Helper.swift
//  Greenply
//
//  Created by Rupam Mitra on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
import CoreLocation
class Helper: NSObject {
	var deviceID: String?
	var UserID: String?
	var UserType: String?
    var isGoogleSignIn = false
    var navigationController: UINavigationController!
	static let sharedClient = Helper()
	private override init() { }

    func readPlist(forName name: String?) -> [AnyObject] {
        let url = NSBundle.mainBundle().URLForResource(name, withExtension: "plist")!
        let array = NSMutableArray(contentsOfURL: url)?.mutableCopy() as? [AnyObject]
        
        var plistArray = [AnyObject]()
        for item in array! {
            plistArray.append(item)
        }
        
        return plistArray
    }
    
    func dateToLong(date:NSDate) -> Double {
        let timeInSeconds : NSTimeInterval  = date.timeIntervalSince1970
        return timeInSeconds
    }
    
    // MARK:- Check User Login In OR Not Function..
    func checkUserAlredyLogin(inViewControler presentViewController: UIViewController, isLogin: (isLogin: Bool!) -> ()) {
            if INTEGER_FOR_KEY(kUserID) != 0 {
                isLogin(isLogin: true)
            }
            else {
                
                presentViewController.presentViewController(UIAlertController.showStandardAlertWith(kAppTitle, alertText: WANT_TO_LOGIN, positiveButtonText: TEXT_YES, negativeButtonText: TEXT_NO, selected_: { (index) in
                    if index == 1 {
                        let loginControllerNavigation = loginStoryboard.instantiateViewControllerWithIdentifier("LoginNavigationalController") as! UINavigationController
                        presentViewController.presentViewController(loginControllerNavigation, animated: true, completion: nil)
                    }
                }), animated: true, completion: nil)
                
            }
        }
 
    
    
    // Present Login view controller
    func presentLoginView(withIndexValue indexValue: Int?){
      
        if(indexValue == 1){
        let loginControllerNavigation = loginStoryboard.instantiateViewControllerWithIdentifier("LoginNavigationalController") as! UINavigationController
        
          NavigationHelper.helper.contentNavController!.presentViewController(loginControllerNavigation, animated: true, completion: nil)
            
        
               // presentViewController.presentViewController(loginControllerNavigation, animated: true, completion: nil)
            }
      
    }
    // Mark:- Check Null Value
    func checkNullValue(pStringdata: AnyObject?, nillStringReplaceWith: String?)->AnyObject{
        var strResult: AnyObject = ""
        if let pResult = pStringdata{
            strResult = pResult
        }
        else{
            strResult = nillStringReplaceWith!
        }
        return strResult
    }
   //Mark:- Calculating Distance between two coordinates
    func distanceBetweenTwoLocations(sourceLatitude: Double? , sourceLongitude: Double?, result:(result: Double)->()){
     
     CurrentLocation.sharedInstance.fetchCurrentUserLocation(onSuccess: { (latitude, longitude) in
        let myLocation = CLLocation(latitude: latitude, longitude: longitude)
        let myBuddysLocation = CLLocation(latitude: sourceLatitude!, longitude: sourceLongitude!)
        let distance = myLocation.distanceFromLocation(myBuddysLocation) / 1000
         let roundedTwoDigit = distance.roundedTwoDigit
        result(result: roundedTwoDigit)
        }) { (message) in
            
        }
       

    }
}
extension Double{
    
    var roundedTwoDigit:Double{
        
        return Double(round(100*self)/100)
        
    }
}
