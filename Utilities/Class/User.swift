//
//  FollowerAndFollowing.swift
//  Greenply
//
//  Created by Jitendra on 9/29/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class User: NSObject {

    var userName: String?
    var userEmail: String?
    var userContactNumber: String?
    var userLikeCount: Int?
    var userAddress: String?
    var userAboume: String?
    var UserViewCount: Int?
    var profileImage: String?
    var profileImageOriginal: String?
    var profileImageThumb: String?
    var profileImageMedium: String?
     init(withDictionary dict: [String: AnyObject]) {
        userName = dict["username"] as? String
        userEmail = dict["email"] as? String
        userContactNumber = dict["contact_no"] as? String
        userLikeCount = dict["like_count"] as? Int
        userAddress = dict["address"] as? String
        userAboume = dict["about_me"] as? String
        UserViewCount = dict["UserViewCount"] as? Int
    }
    
}
