//
//  ProjectsCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 29/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class ProjectsCollectionViewCell: BaseCollectionViewCell {

	@IBOutlet weak var imageCollectionProjects: UIImageView!
    @IBOutlet weak var labelCollectionProjects: UILabel!
    
	override var datasource: AnyObject? {
		didSet {
           
			let objPortFolio = datasource as! ProfileImage
			imageCollectionProjects.layer.cornerRadius = IS_IPAD() ? 10.0 : 5.0
			imageCollectionProjects.layer.masksToBounds = true
            
            if let _ =  labelCollectionProjects{
                if let _ = objPortFolio.roomType{
                    labelCollectionProjects.text = objPortFolio.roomType
                }
            }
          
            
       

		imageCollectionProjects.setImage(withURL: NSURL(string: objPortFolio.projectImageMedium!)!, placeHolderImageNamed: "PlaceholderRectangle", andImageTransition: .CrossDissolve(0.4))
		}
	}
}
