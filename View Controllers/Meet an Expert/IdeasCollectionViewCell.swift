//
//  IdeasCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 29/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class IdeasCollectionViewCell: BaseCollectionViewCell {

	@IBOutlet weak var imageCollectionIdeas: UIImageView!
    @IBOutlet weak var labelCollectionIdeas: UILabel!
    var ObjIdeaListInfluncer: IdeaListing!
	override var datasource: AnyObject? {
		didSet {
            imageCollectionIdeas.layer.cornerRadius = IS_IPAD() ? 10.0 : 5.0
            imageCollectionIdeas.layer.masksToBounds = true
            
            labelCollectionIdeas.text = "Room"
            
            
            ObjIdeaListInfluncer = datasource as! IdeaListing
            
            imageCollectionIdeas.setImage(withURL: NSURL(string: ObjIdeaListInfluncer.ideaImageThumb!)!, placeHolderImageNamed: "PlaceholderSquare", andImageTransition: .CrossDissolve(0.4))
            labelCollectionIdeas.text = ObjIdeaListInfluncer.roomValue
            

            
            
            
		}
	}
}
