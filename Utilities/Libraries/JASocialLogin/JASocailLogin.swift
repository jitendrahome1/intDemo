//
//  JASocailLogin.swift
//  GreenPlay
//
//  Created by Jitendra on 05/09/16.
//  Copyright © 2016 Jitendra. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
class JASocailLogin: NSObject {
  

}

extension JASocailLogin
{
    class func JALoginWithFacebook(delegate delegate:UIViewController ,  sucessData:(sucessData: AnyObject)->Void ,  failure:(failure: NSError)->Void)
    {
        
         let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logInWithReadPermissions(["email", "public_profile"], fromViewController: delegate) { (result, error) -> Void in
            if (error != nil){
            sucessData(sucessData:false)
            }else if result.isCancelled {
               sucessData(sucessData: false)
            }
            else{
             let fbloginresult : FBSDKLoginManagerLoginResult = result
                
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData({ (FBuserData) -> Void in
                     sucessData(sucessData: FBuserData)
                    })
                   
                }
            }
            }
        
    
    }
    
    class func getFBUserData(FBuserData:(FBuserData: AnyObject)->Void) {
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    FBuserData(FBuserData: result)
                    
                }
            })
        }
    }
    
  
    
}


