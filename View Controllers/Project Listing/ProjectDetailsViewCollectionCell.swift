//
//  ProjectDetailsViewCollectionCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 26/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class ProjectDetailsViewCollectionCell: BaseCollectionViewCell {
    @IBOutlet weak var imageProjectDetails: UIImageView!
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var txtViewDetails: UITextView!
    var actionLikeHandler: ((imageID: String, imageLikeStatus: Bool)->())?
    @IBOutlet weak var labelLikeCount: UILabel!
    var objProjDetails: ProfileImage!
    @IBOutlet weak var buttonLike: UIButton!
    override var datasource: AnyObject? {
        didSet {
           objProjDetails = datasource as! ProfileImage
            imageProjectDetails.setImage(withURL: NSURL(string: objProjDetails.projectImageMedium!)!, placeHolderImageNamed: "PlaceholderRectangle", andImageTransition: .CrossDissolve(0.4))
            labelHeader.text = objProjDetails.roomType
            txtViewDetails.text = objProjDetails.roomDescription
            self.labelLikeCount.text = objProjDetails.likeCount
            if objProjDetails.porjectImageLikeStaus == true{
                buttonLike.setImage(UIImage(named: kFevImageSeleted), forState: UIControlState.Normal)
            }
            else{
                buttonLike.setImage(UIImage(named: kFevImageDeSeleted), forState: UIControlState.Normal)
                }
         
            
        }
    
    }
  
    
    @IBAction func actionLike(sender: UIButton) {
        if actionLikeHandler != nil{
            if let _ = objProjDetails.projectImageID{
            actionLikeHandler!(imageID: objProjDetails.projectImageID! , imageLikeStatus: objProjDetails.porjectImageLikeStaus!)
            }
        }
    
    }
   
    
}
