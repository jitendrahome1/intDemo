//
//  AllCommentsCell.swift
//  Greenply
//
//  Created by Jitendra on 9/12/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class AllCommentsCell: BaseTableViewCell {

	@IBOutlet weak var lableCommentDate: UILabel!
	@IBOutlet weak var labelCommentName: UILabel!
    var actionReportAbusHandler: ((CommentID: Int, isAbusStatus: Bool) -> ())?
	@IBOutlet weak var labelCommentDiscrption: UILabel!
    @IBOutlet weak var buttonSpam: UIButton!
    var objCommentsList: Comments!
    override var datasource: AnyObject? {
		didSet {
			objCommentsList = datasource as! Comments
			labelCommentName.text = objCommentsList.CommentsUserName
			let properString = objCommentsList.commentsDetails!.stringByRemovingPercentEncoding
			labelCommentDiscrption.text = properString
			lableCommentDate.text = NSDate.dateFromTimeInterval(objCommentsList.commentDate!).getFormattedStringWithFormat()
            if objCommentsList.commentReportAbus == true{
            self.buttonSpam.setImage(UIImage(named: kReportAbusRedImage), forState: .Normal)
            }
            else{
            self.buttonSpam.setImage(UIImage(named: kReportAbusGreenImage), forState: .Normal)
            }
    
		}
	}

    @IBAction func actionReportAbus(sender: UIButton) {
   if actionReportAbusHandler != nil {
    actionReportAbusHandler!(CommentID:objCommentsList.commentID!, isAbusStatus: objCommentsList.commentReportAbus!) // For time Bing
        }
    }
}
