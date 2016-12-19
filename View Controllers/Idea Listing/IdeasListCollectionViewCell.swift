//
//  ProjListCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 30/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class IdeasListCollectionViewCell: BaseCollectionViewCell {
   
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var imageProjList: UIImageView!
    @IBOutlet weak var imageBottomProjList: UIImageView!
    @IBOutlet weak var labelIdeasTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var labelDrawing: UILabel!
    @IBOutlet weak var buttonLikes: UIButton!
    @IBOutlet weak var buttonViews: UIButton!
    @IBOutlet weak var buttonShare: UIButton!
    var ideaListObj: IdeaListing!
    var editButtonHandler:((ideaID: Int)->())?
    override var datasource: AnyObject? {
        didSet {
            
        ideaListObj = datasource as! IdeaListing
       labelIdeasTitle.text = ideaListObj.ideaName
        buttonLikes.setTitle("\(ideaListObj.likeCount! as Int)" , forState: .Normal)
        buttonViews.setTitle("\(ideaListObj.viewCount! as Int)", forState: .Normal)
        labelSubtitle.text = ideaListObj.styleValue
        labelDrawing.text = ideaListObj.roomValue
        imageProjList.setImage(withURL: NSURL(string: ideaListObj.ideaImageThumb!)!, placeHolderImageNamed: "PlaceholderSquare", andImageTransition: .CrossDissolve(0.4))
           
            
        }
    }
    
    @IBAction func actionEdit(sender: UIButton) {
        if editButtonHandler != nil{
            editButtonHandler!(ideaID: Int((ideaListObj.IdeaID!)))
        
        }
    
    }

}
