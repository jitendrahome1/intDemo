//
//  InfluencerList.swift
//  Greenply
//
//  Created by Jitendra on 10/7/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class Influencer: NSObject {

	var influencerUserName: String?
	var influencerCoverProfle: String?
	var influencerContactNo: String?
	var influencerLikeCount: Int?
	var influencerID: Int?
	var influencerAddress: String?
	var influencerCoverPicOriginal: String?
	var influencerCoverPicThumb: String?
	var influencerCoverPicMedium: String?
	var influencerViewCount: Int?
	var influencerTypeID: Int?
	var aboutUs: String?
	var influencerAccessToken: String?
	var influencerserviceArea: String?
	var influencerType: String?
	var influencerExperiences: String = ""
	var influencerTotalExperiences: String?
	var influencerEducations: String = ""
	var isFollowStatus: Bool?
	var isLikedStatus: Bool?
	var abusedStatus: Bool?
    var longitude: String?
    var latitude: String?
    var arrEducationList = [AnyObject]()
    var arrExperienceList = [AnyObject]()
    var influencerDistance: String?
    
	init(withDictionary dict: [String: AnyObject]) {

		self.influencerID = dict["id"] as? Int!
		self.influencerUserName = dict["name"] as? String
		let likeCout = dict["like_count"] as? Int
        if likeCout > 0{
         self.influencerLikeCount = dict["like_count"] as? Int
        }else{
            self.influencerLikeCount = 0
        }
   
		self.influencerAddress = dict["address"] as? String
		self.influencerContactNo = dict["contact_no"] as? String
		self.influencerAccessToken = dict["access_token"] as? String
        self.latitude = dict["latitude"] as? String
        self.longitude = dict["longitude"] as? String
   
        self.isFollowStatus = dict["isFollwed"] as? Bool
        self.isLikedStatus = dict["isLiked"] as? Bool
		self.influencerserviceArea = Helper.sharedClient.checkNullValue(dict["profile"]!["service_area"] as? String, nillStringReplaceWith: "N/A") as? String
		self.influencerType = Helper.sharedClient.checkNullValue(dict["profile"]!["influencer_type"]!!["influencer_type"] as? String, nillStringReplaceWith: "N/A") as? String
		if dict["about_me"] as? String == "" {
			self.aboutUs = "N/A"
		} else {
			self.aboutUs = dict["about_me"] as? String
		}
		
        let expValue = dict["profile"]!["total_experience"] as? String
        if expValue == "0.00"{
         influencerTotalExperiences = "0"
        }else{
            influencerTotalExperiences = dict["profile"]!["total_experience"] as? String   
        }
     
        
        
        
		self.influencerViewCount = Helper.sharedClient.checkNullValue(dict["view_count"] as? Int, nillStringReplaceWith: "0") as? Int
		self.influencerTypeID = dict["profile"]!["influencer_type"]!!["influencer_type_id"] as? Int
		self.influencerCoverProfle = Helper.sharedClient.checkNullValue(dict["cover_profile"] as? String, nillStringReplaceWith: "") as? String

		// MARK:-  experiences
		let arrExpValue = dict["experiences"] as! [AnyObject]
            if arrExpValue.count > 0 {
            let objExprience = Experience(withDictionary: arrExpValue)
            self.arrExperienceList.append(objExprience)
        }
//		if arrExperiences.count > 0 {
//			for index in 0..<arrExperiences.count {
//				let dictExperiences = arrExperiences[index]
//				influencerExperiences = influencerExperiences + (dictExperiences["organisation_name"]! as? String)!
//				if index < arrExperiences.count - 1 {
//					influencerExperiences = influencerExperiences + ","
//				}
//			}
//		}
//		else
//		{
//			influencerExperiences = "N/A"
//		}

	
	// MARK: - Education
	let arrEduResult = dict["educations"] as! [AnyObject]
	if arrEduResult.count > 0 {
        let objEducation = Education(withDictionary: arrEduResult)
        self.arrEducationList.append(objEducation)
        }

	}

}


// Parse Education.
class Education: NSObject{
    var organisation_name: String?
    var startDate: String?
    var endDate: String?
     init(withDictionary arrEducation: [AnyObject]) {
        for index in 0..<arrEducation.count {
            let dictEducations = arrEducation[index]
            self.organisation_name = (dictEducations["degree"]! as? String)!
            self.startDate = String((dictEducations["start_date"]! as? Double)!)
            self.startDate = String((dictEducations["end_date"]! as? Double)!)
            
            }
    }
}

// Parse Experience.
class Experience: NSObject{
    var organisation_name: String?
    var startDate: Double?
    var endDate: Double?
    init(withDictionary arrExperience: [AnyObject]) {
        for index in 0..<arrExperience.count {
            let dictExperience = arrExperience[index]
            self.organisation_name = (dictExperience["organisation_name"]! as? String)!
            self.startDate = (dictExperience["start_date"]! as? Double)!
            if let _ = dictExperience["end_date"] as? Double{
           
            self.endDate = (dictExperience["end_date"]! as? Double)!
            
            
            }
           
            
        }
    }
}


//Notification List
class Notification: NSObject{
    var notification_id: Int?
    var notification_title: String?
    var date: Int?
    var notification_type: String?
    var desc: String?
    init(withDictionary dict: [String: AnyObject]) {
        
            self.notification_id = (dict["notification_type_id"]! as? Int)!
            self.notification_title = (dict["user"]!["username"]! as? String)!
            self.date = (dict["created"]! as? Int)!
//            self.notification_type = (dictExperience["notification_type"]! as? String)!
            self.desc = (dict["notification_text"]! as? String)!
        
    }
}


//UserFilterAttribute
class UserFilterAttribute: NSObject {
    var id: Int?
    var name: String?
    var value_Code: String?
    var count: Int?
    init(withDictionary dict: [String : AnyObject]) {
            self.id = (dict["id"]! as? Int)!
            self.name = (dict["name"]! as? String)!
            self.value_Code = (dict["value_code"]! as? String)!
            self.count = (dict["count"]! as? Int)!
    }
}


//HeaderFilterAttribute
class HeaderFilterAttribute: NSObject {
    var id: Int?
    var attribute_name: String?
    init(withDictionary dict: [String: AnyObject]) {
        self.id = dict["id"] as? Int!
        self.attribute_name = dict["attribute_name"] as? String!
    }
}


