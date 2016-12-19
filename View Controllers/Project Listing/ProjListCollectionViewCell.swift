//
//  ProjListCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 30/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class ProjListCollectionViewCell: BaseCollectionViewCell {

	@IBOutlet weak var imageProjList: UIImageView!
	@IBOutlet weak var imageBottomProjList: UIImageView!
	@IBOutlet weak var labelProjTitle: UILabel!
	@IBOutlet weak var labelSubtitle: UILabel!
	@IBOutlet weak var labelDrawing: UILabel!
	@IBOutlet weak var buttonLikes: UIButton!
	@IBOutlet weak var buttonViews: UIButton!
	@IBOutlet weak var buttonShare: UIButton!
	@IBOutlet weak var buttonAdd: UIButton!
    var objPortfolio: Portfolio!
  var editButtonHandler:((projectID: Int)->())?
	override var datasource: AnyObject? {
		didSet {

			 objPortfolio = datasource as! Portfolio
			let objPortFolioImages = objPortfolio.arrPortFolioImages[0] 
			imageProjList.setImage(withURL: NSURL(string: objPortFolioImages.projectImageThumb!)!, placeHolderImageNamed: "PlaceholderSquare", andImageTransition: .CrossDissolve(0.4))
			buttonLikes.setTitle("\(objPortfolio.likeCount! as Int)", forState: .Normal)
			labelProjTitle.text = objPortfolio.projectName
			let objAttribute = objPortfolio.arrProjectAttribute[0] as! ProjectAttribute

			labelSubtitle.text = objAttribute.attributeValue_Name
			buttonViews.setTitle("\(objPortfolio.viewCount! as Int)", forState: .Normal)
		}
	}
    
    @IBAction func actionEditProject(sender: UIButton) {
        if editButtonHandler != nil{
            editButtonHandler!(projectID: Int((objPortfolio.portfolioID!)))
            
        }
    }
    
}
