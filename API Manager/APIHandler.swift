//
//  GPAPIHandler.swift
//  Greenply
//
//  Created by Jitendra on 9/6/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
import SwiftyJSON

class APIHandler: NSObject {
    static let handler = APIHandler()
    private override init() { }
    
    // MARK:- General Login
    func login(email: String?, password: String?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        
        let params = ["LoginForm": ["email": email!, "password": password!, "device_type": "mobile", "device_token": String(Helper.sharedClient.deviceID)]]
        
        APIManager.manager.postRequestJSON(LOGIN, parameters: params, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            failure(error: error)
        }
    }
    
    // MARK:- User Registration
    func userRegistration(username: String?, password: String?, email: String?, contact_no: String?, city: String?, pincode: String?, socialID: String?, socialType: String?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        
        let params = ["User": ["name": username!, "email": email!, "password": password!, "contact_no": contact_no!, "user_type": "seeker", "status": "1", "address": city!, "city": city!, "zip": pincode!, "social_id": socialID!, "social_type": socialType!]]
        
        APIManager.manager.postRequestJSON(USER_REGISTRATION, parameters: params, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            failure(error: error)
        }
    }
    
    // MARK:- User Forgot And Reset Password
    func forgotAndResetPassword(email: String?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        
        let params = ["User": ["email": email!]]
        
        APIManager.manager.postRequestJSON(FORGOT_RESET_PASSWORD, parameters: params, headers: nil, success: { (response) in
            
            let statusCode = response["statusCode"].intValue
            
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            failure(error: error)
        }
    }
    // MARK:- verify OTP Forgot password
    func verifyOTPForgotPassword(forUser userID: Int?, otp: String?, password: String?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        
        let params = ["User": ["otp": otp!, "password": password!]]
        
        APIManager.manager.putRequestJSON(VERIFY_FORGOT_PASSWORD_OTP(forUser: userID!), parameters: params, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
            
        }) { (error) in
            failure(error: error)
        }
    }
    // MARK:- verify OTP USE Registration
    func verifyOTPUserRegistration(forUser userID: Int?, otp: String?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        let params = ["User": ["otp": otp!]]
        APIManager.manager.putRequestJSON(VERIFY_REGISTRATION_OTP(forUser: userID!), parameters: params, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
            
        }) { (error) in
            failure(error: error)
        }
    }
    
    // MARK:- verify OTP USE Registration
    func resendOTP(forUser userID: Int?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        APIManager.manager.putRequestJSON(RESEND_OTP(forUser: userID!), parameters: nil, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
                Toast.show(withMessage: response["statusText"].stringValue)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
            
        }) { (error) in
            failure(error: error)
        }
    }
    
    // MARK:- Change password
    func changePassword(forUser userID: Int?, old_password: String?, new_password: String?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        
        let params = ["User": ["old_password": old_password!, "password": new_password!]]
        
        APIManager.manager.putRequestJSON(CHANGE_PASSWORD(forUser: userID!), parameters: params, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            failure(error: error)
        }
    }
    
    // MARK:- InfluencerUserType
    func userType(success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        APIManager.manager.getRequest(INFLUENCER_TYPE, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
        }
    }
    
    // MARK:- UserFilterAttribute
    func userFilterAttribute(success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        APIManager.manager.getRequest(FILTER_ATTRIBUTE, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
        }
    }
    
    // MARK:- InfluencerFilter
    func influencerFilter(forUser user_type: String?, influencer_type: String?, work_experience: String?, ratings: String?, typical_job_cost: String?, skills: String?, distance: String?, influencer_filter: String?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        
        //        let INFLUENCER_FILTER = "/users?UserSearch[user_type]=influencer&UserSearch[influencer_type]=architect&UserSearch[work_experience][]=less-2&UserSearch[work_experience][]=6-10&UserSearch[ratings][]=1&UserSearch[ratings][]=2&UserSearch[typical_job_cost][]=28&UserSearch[skills][]=1&UserSearch[skills][]=2&UserSearch[distance][]=less-1"
        
        APIManager.manager.getRequest(influencer_filter!, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
        }
    }
    
    
    
    // MARK:- BecomeInfluencer
    func becomeInfluencer(forUser userID: Int?, name: String?, email: String?, contact_no: Int?, address: String?, aboutme: String?, user_type: String?, influencer_type_id: Int?, filetype: String?, filename: String?, base64: String?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        
        let params = ["User": ["name": name!, "email": email!, "contact_no": contact_no!, "address": address!, "about_me": aboutme!, "user_type": user_type!], "Profile": ["influencer_type_id": influencer_type_id!, "filename": ["filetype": filetype!, "filename": filename!, "base64": base64!]]]
        APIManager.manager.putRequestJSON(BECOME_INFLUENCER(forUser: userID!), parameters: params, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
        }
    }
    
    
    
    // MARK:- Edit Influncer Profile
    func editInfluencerProfile(forUser userID: Int?, forUserName name: String?, contactNumber: String?, email: String?, birthDate: String?, address: String?, aboutUs: String?, userEducation: [AnyObject]?, userTraining: [AnyObject]?, UserExperience: [AnyObject]?, UserCertification: [AnyObject]?, serviceArea: String?, skillID: [AnyObject]?,base64: String?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        print("UserEductiuon\(userEducation!)")
        
        
        let param = [
            "User": [
                "name": name!,
                "contact_no": contactNumber!,
                "email": email!,
                "birth_date": "16-Nov-1990",
                "address": address!,
                "about_me": aboutUs!,
                "city": "Kolkata",
                "zip": "700028",
                "display_profile":[
                    "filename": "best_empl.jpg",
                    "filesize": 25841,
                    "base64": base64!
                ],
                "cover_profile":[
                    "filename": "best_empl.jpg",
                    "filesize": 25841,
                    "base64": base64!
                ]
            ],
            "UserEducation": userEducation!,
            "UserTraining": userTraining!,
            "UserExperience": UserExperience!,
            "UserSkill": ["skill_id": [
            "1",
            "2",
            "floor designer"
            ]],
            "UserCertification": UserCertification!,
            "Profile": [
                 "service_area": serviceArea!
              ]
            ]
        
        //    let params = ["User": ["name": name!, "contact_no": contactNumber!, "birth_date": "01-05-1989", "address": address!, "about_me": aboutUs!, "UserEducation": userEducation!, "UserTraining": userTraining!, "UserExperience": UserExperience!, "UserCertification": UserCertification!, "Profile": ["service_area": serviceArea!], "UserSkill": ["skill_id": skillID!]]]
        APIManager.manager.putRequestJSON(EDIT_INFLUENCER(forUserId: userID!), parameters: param as? [String : AnyObject], headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
                Toast.show(withMessage: PROFILE_SUCCESS)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
        }
        
    }
    
    // MARK:- WriteComment
    func writeComment(forUser userID: Int?, ideaID: Int?, comment: String?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        
        let params = ["IdeaComment": ["user_id": userID!, "idea_id": ideaID!, "comment": comment!]]
        
        APIManager.manager.postRequestJSON(WRITE_COMMENT, parameters: params, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            failure(error: error)
        }
    }
    
    // MARK:- ExpertRateAndReview
    func rateAndReview(forUser userID: Int?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        
        APIManager.manager.getRequest(RATE_REVIEW(forUser: userID!), headers: nil, parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            failure(error: error)
        }
    }
    
    // MARK:- Dashboard
    func getDashboard(success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        APIManager.manager.getRequest(DASHBOARD, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            failure(error: error)
        }
    }
    
    // MARK:- IDEA LISTING
    func getIdeaListingList(success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        APIManager.manager.getRequest(IDEA_LIST, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            failure(error: error)
        }
    }
    
    // MARK:- IDEA Details.
    func getIdeaDetails(ideaID: Int?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        APIManager.manager.getRequest(IDEA_DETAILS(forIdeaID: ideaID!), headers: nil, parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            failure(error: error)
        }
    }
    
    // MARK Get My Pinned List And Pinned Details..
    func getMyPinnedDetailsList(success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        
        APIManager.manager.getRequest(MY_PINNED, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            failure(error: error)
        }
        
    }
    // MARK:-// Get My Portfolio Listing
    func getMyPortfolioListing(userID: Int?, pageNumber: String?, perPage: String?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        
        // let params = ["user_id": userID]
        APIManager.manager.getRequest(MY_PORTFOLIO(forUser: userID!, pageNumber: pageNumber!, perPage: perPage!), headers: nil, parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            
        }
    }
    
    // MARK:- Get My Portfolio Details.
    func getPortFolioDetails(forPortFolioID portFolioID: Int?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ())
    {
        APIManager.manager.getRequest(PORTFOLIO_DETAILS(forPortFolioID: portFolioID!), headers: nil, parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            
        }
        
    }
    // MARK:- PortFolio Like:-
    func portfolioLike(forUserID userID: Int?, portfolioID: Int?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        let params = ["Portfoliolike": ["user_id": userID!, "portfolio_id": portfolioID!]]
        APIManager.manager.postRequestJSON(PORTFOLIO_LIKE, parameters: params, headers: nil, success: { (response) in
            
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            
        }
        
    }
    
    func getFollowersAndFollowingList(success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        APIManager.manager.getRequest(FOLLOWS_LIST, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            
        }
    }
    
    func getAttributesForProjrcts(success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        
        APIManager.manager.getRequest(ATTRIBUTES_FOR_PROJECTS, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            
        }
    }
    
    // MARK:- ADD Pin To Idea.
    func addIdeaPin(withIdeaID ideaID: Int?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        let params = ["Pin": ["idea_id": ideaID!]]
        
        APIManager.manager.postRequestJSON(ADD_IDEA_PIN, parameters: params, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            case 409:
                Toast.show(withMessage: response["statusText"].stringValue)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            
        }
    }
    
    // MARK:- Upload Ideas
    func uploadIdea(ideaName: String?, description: String?, fileType: String?, fileName: String?, fileSize: String?, base64: String?, IdeaTag: [AnyObject]?, attributeValues: String?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        
        let params = ["Idea": ["idea_name": ideaName!, "description": description!, "image": ["filename": fileName!, "filetype": fileType!, "base64": base64!]], "IdeaAttributeValue": ["attribute_value_id": attributeValues!], "IdeaTag": ["tag_id": IdeaTag!]]
        
        debugPrint(params)
        
        APIManager.manager.postRequestJSON(ADD_IDEAS, parameters: params, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            debugPrint(error.debugDescription)
        }
    }
    
    // MARK:- UpLoad Project
    func uploadProject(userID: Int?, projectName: String?, description: String?, projectTypeID: String?, stypeTypeID: String?, workTypeID: String?, budgetTypeID: String?, arrTags: [AnyObject]?, imageData: [AnyObject]?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        
        let params = ["Portfolio": ["name": projectName!, "description": description!, "user_id": userID!], "attribute_value_id": ["style_type": stypeTypeID!, "projectType": projectTypeID!, "workType": workTypeID!, "projectBudget": budgetTypeID!], "PortfolioTag": ["tag_id": arrTags!]]
        let JsonFormattedData = JSON(params).rawString()!
        let postData = ["portfolios": JsonFormattedData]
        APIManager.manager.uploadFileMultipartFormDataWithParams(UPLOAD_PROJECT, headers: ["upload-from": "mobile"], uploadImageList: imageData!, fileName: "filetype", parameters: postData, success: { (response) in
            
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            debugPrint(error.debugDescription)
        }
    }
    // Edit Project. 
    func editUploadProject(userID: Int?, projectName: String?, description: String?, projectTypeID: Int?, stypeTypeID: String?, workTypeID: String?, budgetTypeID: String?, arrTags: [AnyObject]?, imageData: [AnyObject]?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        
        let params = ["Portfolio": ["name": projectName!, "description": description!, "user_id": userID!], "attribute_value_id": ["style_type": stypeTypeID!, "projectType": projectTypeID!, "workType": workTypeID!, "projectBudget": budgetTypeID!], "PortfolioTag": ["tag_id": arrTags!]]
        let JsonFormattedData = JSON(params).rawString()!
        let postData = ["portfolios": JsonFormattedData]
        APIManager.manager.uploadFileMultipartFormDataWithParams(EDIT_PORJECT(forProjectID:projectTypeID!) , headers: ["upload-from": "mobile"], uploadImageList: imageData!, fileName: "filetype", parameters: postData, success: { (response) in
            
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            debugPrint(error.debugDescription)
        }
    }
    
    //Portfolio image edit
    
        func editProjectImage(imageID: Int?, attribute_value_id: String?, description: String?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
            let params = ["PortfolioImages": ["attribute_value_id": attribute_value_id!, "description": description!]]
            
            debugPrint(params)
            
            APIManager.manager.putRequestJSON(EDIT_PROJECT_IMAGE(forPortfolioImageID: imageID!), parameters: params, headers: nil, success: { (response) in
                let statusCode = response["statusCode"].intValue
                switch (statusCode) {
                case 200:
                    success(response: response)
                default:
                    Toast.show(withMessage: response["statusText"].stringValue)
                }
            }) { (error) in
                debugPrint(error.debugDescription)
            }
    }

    
    // Edit Idea
    func editUploadIdea(forIdeaId ideaID: Int?, ideaName: String?, description: String?, fileType: String?, fileName: String?, fileSize: String?, base64: String?, IdeaTag: [AnyObject]?, attributeValues: String?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        
        let params = ["Idea": ["idea_name": ideaName!, "description": description!, "image": ["filename": fileName!, "filetype": fileType!, "base64": base64!]], "IdeaAttributeValue": ["attribute_value_id": attributeValues!], "IdeaTag": ["tag_id": IdeaTag!]]
        
        debugPrint(params)
        
        APIManager.manager.putRequestJSON(EDIT_IDEA(forIdeaID: ideaID!), parameters: params, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            debugPrint(error.debugDescription)
        }
    }
    
    // MARK:- UnFollow
    func unFollow(forUnfollowrID followerID: Int?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        APIManager.manager.deleteRequestJSON(UNFOLLOW(forFollowID: followerID!), parameters: nil, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
        }
    }
    
    // MARK:- Write A review
    func writeReview(userID: Int?, rated_by: Int?, rating: Float?, description: String?, title: String?, service_taken: Int?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        let params = ["Rating": ["user_id": userID!, "rated_by": rated_by!, "rating": rating!, "description": description!, "title": title!, "service_taken": service_taken!]]
        
        APIManager.manager.postRequestJSON(WRITE_REVIEW, parameters: params, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            
        }
    }
    
    // MARK:- REMOVE IDEA PIN
    func removeIdeaPin(forIdeaID ideaID: Int?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        APIManager.manager.deleteRequestJSON(REMOVE_IDEA_PIN(forIDEAID: ideaID!), parameters: nil, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
        }
    }
    // MARK:- Set Follow
    func addFollow(forFollowerID followerID: Int?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        let params = ["Follow": ["follower_id": followerID!]]
        
        APIManager.manager.postRequestJSON(ADD_FOLLOW, parameters: params, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
        }
        
    }
    // MARK:- Influencer Like
    func addInfluencerLike(forUserID userID: Int?, influencerID: Int?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        let params = ["InfluencerLike": ["user_id": userID!, "influencer_id": influencerID!]]
        APIManager.manager.postRequestJSON(INFLUENCER_LIKE, parameters: params, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
        }
        
    }
    
    // MARK:- Idea Like-
    func addIdeaLike(forUserID userID: Int?, IdeaID: Int?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        let params = ["IdeaLike": ["user_id": userID!, "idea_id": IdeaID!]]
        APIManager.manager.postRequestJSON(IDEA_LIKE, parameters: params, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
        }
    }
    // MARK:- Portfolio Image Like
    func addPortfolioImageLike(forUserID userID: Int?, ImageID: String?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        let params = ["PortfolioImageLike": ["user_id": userID!, "image_id": ImageID!]]
        APIManager.manager.postRequestJSON(PORTFOLIO_IMAGE_LIKE, parameters: params, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
        }
    }
    // MARK:- Influencer Dislike
    func influencerDislike(forinfluencerID influencerID: Int?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        APIManager.manager.deleteRequestJSON(INFLUENCERDISLIKE(forInfluencerID: influencerID!), parameters: nil, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
        }
    }
    //MARK:-  Portfolio image Dislike
    func portfolioImageDislike(forPortfolioImageID imageID: Int?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        APIManager.manager.deleteRequestJSON(PORTFOLIOIMAGEDISLIKE(forPortfolioImageID: imageID!), parameters: nil, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
        }
    }
    
    // MARK- Idea Dislike
    func ideaDislike(forIdeaID ideaID: Int?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        APIManager.manager.deleteRequestJSON(IDEADISLIKE(forIdeaID: ideaID!), parameters: nil, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
        }
    }
    
    // MARK:- Seeker Profile Edit
    func editSeekerProfileWith(forUserID userID: Int?, userName: String?, userContactnumber: String?, userAddress: String?, aboutMe: String?, userBirthDate: String?, zipCode:String?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        let params = ["User": ["name": userName!, "contact_no": userContactnumber!, "city": userAddress!, "about_me": aboutMe!, "birth_date": userBirthDate!,"zip":zipCode!]]
        
        APIManager.manager.putRequestJSON(EDITSEEKERPROFILE(forUserID: userID!), parameters: params, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
            
        }) { (error) in
            failure(error: error)
        }
    }
    
    // MARK:- Influencer List
    func getInfluencerList(foruser UserType: String?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        
        let endPoint = "\(INFLUENCER_LIST)\(UserType!)"
        APIManager.manager.getRequest(endPoint, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                if response["User"].count > 0 {
                    success(response: response)
                } else {
                    Toast.show(withMessage: "No result found")
                }
                
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            failure(error: error)
        }
    }
    
    // MARK:- Get InfluncerIdea List.
    func getIdeaListingWithUserID(forUserID userID: Int?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ())
    {
        APIManager.manager.getRequest(IDEALISTWITH(forUserID: userID!), headers: nil, parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            
        }
        
    }
    // MARK:- GEt Incluncer Details.
    func getInfluencerDetails(forUserID userID: Int?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        
        APIManager.manager.getRequest(INFLUENCERDETAILS(forUserID: userID!), headers: nil, parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            
        }
    }
    
    // MARK:- GEt All tags..
    func getTagsList(success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        APIManager.manager.getRequest(TAGS_LIST, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            
        }
    }
    // MARK:- get Skill List
    
    func getSkillList(success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        APIManager.manager.getRequest(SKILLS_LIST, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            failure(error: error)
        }
    }
    
    // MARK:- Get Attributes  (This Attributes gives workType value, and projectBudget )
    func getAttributes(success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        APIManager.manager.getRequest(ATTRIBUTES, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
        }
    }
    
    // MARK:- GET NotiFications
    func getNotifications(success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        APIManager.manager.getRequest(NOTIFICATIONS, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
                if response["statusText"].stringValue == "No result found" {
                    Toast.show(withMessage: response["statusText"].stringValue)
                }
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            
        }
    }
    
    // MARK:- Report and  Abuse
    func reportAbuseWithTypeID(forTypeID typeID: Int?, abuse_type: String?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        let params = ["Abuse": ["type_id": typeID!, "abuse_type": abuse_type!,]]
        APIManager.manager.postRequestJSON(REPORT_ABUSE, parameters: params, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
            
        }) { (error) in
            failure(error: error)
        }
    }
    
    // MARK:- get About Us-
    func getAboutUS(success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        APIManager.manager.getRequest(ABOUT_US, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
                if response["statusText"].stringValue == "No result found" {
                    Toast.show(withMessage: response["statusText"].stringValue)
                }
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            
        }
    }
    // MARK:- get How its Work -
    func getHowItsWork(success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        APIManager.manager.getRequest(HOW_ITS_WORK, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
                if response["statusText"].stringValue == "No result found" {
                    Toast.show(withMessage: response["statusText"].stringValue)
                }
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            
        }
    }
    
    // MARK:- Login With Facebook
    func loginWithWithSocialID(forSocialID socialID: String?, socailType: String?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        let params = ["User": ["social_id": socialID!, "social_type": socailType!]]
        APIManager.manager.postRequestJSON(SOCIAL_LOGIN, parameters: params, headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
                
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            
            failure(error: error)
            
        }
        
    }
    
    //
    
}

