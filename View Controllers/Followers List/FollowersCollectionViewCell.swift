//
//  FollowersCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 08/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class FollowersCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var imageCollectionView: UIImageView!
    @IBOutlet weak var viewCoverTotalImage: UIView!
    
    @IBOutlet weak var labelTotalRestImage: UILabel!
    override var datasource: AnyObject? {
        didSet {
            
            if let ImageProfile = datasource!["idea_image"]!!["thumb"] as? String{
                self.imageCollectionView.setImage(withURL: NSURL(string: ImageProfile)!, placeHolderImageNamed: "PlaceholderRectangle", andImageTransition: .CrossDissolve(0.4))
                
            }
            
            
           
        }
    }
}
