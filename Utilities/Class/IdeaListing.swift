//
//  IdeaListing.swift
//  Greenply
//
//  Created by Jitendra on 9/22/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class IdeaListing: NSObject {

    var IdeaID:     Int?
    var IdeaUserID:  Int?
    var ideaName: String?
    var ideaSlud: String?
    var ideaDescription: String?
    var metaDescription: String?
    //var ideaImage : String?
    var ideaImageThumb : String?
    var ideaImageOriginal : String?
    var ideaImageMedium : String?
    var ideaImageBig : String?
    var viewCount:  Int?
    var likeCount: Int?
    var status: String?
    var deleteStatus: String?
    var createAt : String?
    var updateAt: String?
    var ideaURL: String?
    var roomValue: String?
    var styleType: String?
    var styleValue: String?
    var isFollowStatus: Bool?
   var isLikedStatus: Bool?
    var isPinnedStatus: Bool?
    var isReportAbusStatus: Bool?
    init(withDictionary dict: [String: AnyObject]) {
        self.IdeaID = dict["id"] as? Int!
        self.IdeaUserID = dict["user_id"] as? Int!
        self.ideaDescription = dict["description"] as? String
        self.ideaName = dict["idea_name"] as? String
        self.ideaSlud = dict["idea_slug"] as? String
        if let metaDetails = dict["meta_description"]?.stringValue{
            self.metaDescription = metaDetails
        }else{
            self.metaDescription = ""
        }
        
        
        
        print("Dict VAlue\(dict)")
        if let _ = dict["attributeWithValue"]!["room_type"]! {
           self.roomValue = (dict["attributeWithValue"]!["room_type"]!!["value"]!! as? String)!
        }
      
        
        if let _  =  dict["attributeWithValue"]!["style_type"]!{
            self.styleValue = (dict["attributeWithValue"]!["style_type"]!!["value"]!! as? String)!
  
        }
        
        
        self.ideaImageThumb = dict["idea_image"]!["thumb"] as? String
        self.ideaImageMedium = dict["idea_image"]!["medium"] as? String
        self.ideaImageBig = dict["idea_image"]!["big"] as? String
        self.ideaImageOriginal = dict["idea_image"]!["original"] as? String
        self.likeCount = (dict["like_count"] as? Int)!
        self.viewCount = dict["view_count"] as? Int!
        self.ideaName = dict["idea_name"] as? String
    }
    
}

class Comments: NSObject {
    var status: Int?
    var commentID: Int?
    var commentedUserID: Int?
    var CommentsUserName: String?
    var commentsDetails: String?
    var commentIdeaID: Int?
    var commentDate: Double?
    var commentReportAbus: Bool?
    init(withDictionary dictComments: [String: AnyObject]) {
       self.status = dictComments["status"] as? Int!
        self.commentID = dictComments["id"] as? Int!
        self.commentedUserID = dictComments["user_id"] as? Int!
        self.CommentsUserName = dictComments["user_name"] as? String
        self.commentsDetails = dictComments["comment"] as? String
        self.commentIdeaID = dictComments["idea_id"] as? Int!
        self.commentDate = dictComments["created_at"] as? Double
        self.commentReportAbus = dictComments["abused"] as? Bool
        
    }
}

class Ratings: NSObject {
    var rating: Int?
    var comment: String?
    var createdAt: Int?
    var serviceTaken: String?
    var name: String?
    var title: String?
    init(withDictionary dictComments: [String: AnyObject]) {
        self.rating = dictComments["rating"] as? Int
        
   self.comment  = Helper.sharedClient.checkNullValue(dictComments["description"] as? String, nillStringReplaceWith: "N/A") as? String
   self.createdAt  = Helper.sharedClient.checkNullValue(dictComments["created_at"] as? Int, nillStringReplaceWith: "N/A") as? Int
        
  
    
   let serverValue = Helper.sharedClient.checkNullValue(dictComments["service_taken"] as? Int, nillStringReplaceWith: "N/A") as? Int
        if serverValue == 0{
          serviceTaken = "Service taken"
        }else{
           serviceTaken = "Service is not taken"
        }
    self.title  = Helper.sharedClient.checkNullValue(dictComments["title"] as? String, nillStringReplaceWith: "N/A") as? String
    self.name  = Helper.sharedClient.checkNullValue(dictComments["review_by"]!["name"] as? String, nillStringReplaceWith: "N/A") as? String
        
        
    //Helper.sharedClient.checkNullValue(dictComments["title"] as? String, nillStringReplaceWith: "N/A") as? String
        //self.comment = dictComments["comment"] as? String
        //self.createdAt = dictComments["created_at"] as? Int
        //self.serviceTaken = dictComments["service_taken"] as? Int
        //self.name = dictComments["review_by"]!["name"] as? String
    }
}

class InfluencerType: NSObject {
    var influencerType: String?
    var influencerTypeId: Int?
    init(withDictionary dictComments: [String: AnyObject]) {
        self.influencerType = dictComments["influencer_type"] as? String
        self.influencerTypeId = dictComments["influencer_type_id"] as? Int
    }
}


