//
//  MyPortfolioListing.swift
//  Greenply
//
//  Created by Jitendra on 9/23/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class Portfolio: NSObject {
	var portfolioID: Int?
	var likeCount: Int?
	var projectName: String?
	var metaDescription: String?
	var portfolioDescription: String?
	// var attributeValue_Name: String?
	// var arrtibute_Name: String?

	var isFollowStatus: Bool?
	var isLikedStatus: Bool?
	var isPinnedStatus: Bool?

	var viewCount: Int?
	var slugName: String?
	var arrPortFolioImages = [ProfileImage]()
	var arrPortfolioTags = [AnyObject]()
	var arrProjectAttribute = [AnyObject]()
	init(withDictionary dict: [String: AnyObject]) {
		self.slugName = dict["slug"] as? String
		self.projectName = dict["name"] as? String
		self.likeCount = (dict["like_count"] as? Int)!
		self.viewCount = dict["view_count"] as? Int!
		self.portfolioID = dict["id"] as? Int!
		self.metaDescription = dict["meta_description"] as? String
		self.portfolioDescription = dict["description"] as? String

		let arrAttribut = dict["attribute_name"] as! [AnyObject]
      

            for index in 0..<arrAttribut.count {
                let dictAttr = arrAttribut[index] as! [String: AnyObject]
                    let objProjectAttribute = ProjectAttribute(withDictionary: dictAttr)
                    arrProjectAttribute.append(objProjectAttribute)
                
               
            }
        
        
        
		
		// MARK:-  Image parse
		let arrImages = dict["portfolioImages"] as! [AnyObject]
		for index in 0..<arrImages.count {
			let dictImages = arrImages[index]
			let objPortfolioImages = ProfileImage(withDictionary: dictImages as! [String: AnyObject])
			arrPortFolioImages.append(objPortfolioImages)
		}
		// MARk:- Tags Parse
		let arrTags = dict["tags"] as! [AnyObject]
		for index in 0..<arrTags.count {
			let dictTags = arrTags[index]
			let objPortfolioTags = ProfileTags(withDictionary: dictTags as! [String: AnyObject])
			arrPortfolioTags.append(objPortfolioTags)
		}
	}
}
// MARK:- Store Portfolio Images.
class ProfileImage: NSObject {
	var roomDescription: String?
	var roomType: String?
	var projectImageThumb: String?
	var projectImageMedium: String?
	var projectImageBig: String?
	var projectImageID: String?
	var porjectImageLikeStaus: Bool?
    var likeCount: String?

	init(withDictionary dictImagesDetails: [String: AnyObject]) {
		self.projectImageThumb = dictImagesDetails["thumb_image"] as? String
		self.projectImageMedium = dictImagesDetails["medium_image"] as? String
		self.projectImageBig = dictImagesDetails["big_image"] as? String
		self.roomDescription = dictImagesDetails["description"] as? String
		self.roomType = dictImagesDetails["room_type"] as? String
        self.projectImageID = dictImagesDetails["id"] as? String
        self.porjectImageLikeStaus = dictImagesDetails["is_liked"] as? Bool
        self.likeCount = dictImagesDetails["like_count"] as? String
	}
}

// MARK:- Store Portfolio Images.
class ProfileTags: NSObject {
	var tagName: String?
	var tagID: Int?

	init(withDictionary dictTagsDetails: [String: AnyObject]) {
		self.tagName = dictTagsDetails["tag_name"] as? String
		self.tagID = dictTagsDetails["tag_id"] as? Int

	}
}


// MARK:- AddIdeasTags
class AddIdeaTags: NSObject {
    var tagName: String?
    var tagID: Int?
    
    init(withDictionary dictTagsDetails: [String: AnyObject]) {
        self.tagName = dictTagsDetails["tag_name"] as? String
        self.tagID = dictTagsDetails["id"] as? Int
    }
}

//MARK:- SkillsTags
class SkillTags: NSObject {
    var skillName: String?
    var skillSlug: String?
    var tagID: Int?
    
    init(withDictionary dictTagsDetails: [String: AnyObject]) {
        self.skillSlug = dictTagsDetails["skill_slug"] as? String
        self.skillName = dictTagsDetails["skill_name"] as? String
        self.tagID = dictTagsDetails["id"] as? Int
    }
}

// MARK:- Store Attribute Name:
class ProjectAttribute {
	var attributeValue_Name: String?
	var arrtibute_Name: String?

	init(withDictionary dictAttributeDetails: [String: AnyObject]) {
		self.attributeValue_Name = dictAttributeDetails["attribute_value_name"] as? String
		self.arrtibute_Name = dictAttributeDetails["attribute_name"] as? String

	}

}

