//
//  MoreDetailsCell.swift
//  Greenply
//
//  Created by Jitendra on 10/26/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
enum eDataType {
    case eEducation
    case eExperience
}
class MoreDetailsCell: BaseTableViewCell {

    var eItemsStaus:eDataType = .eExperience
  
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var labelFromDate: UILabel!
    @IBOutlet weak var lableTitle: UILabel!

    @IBOutlet weak var labelToDate: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    override var datasource: AnyObject? {
        didSet {
            if eItemsStaus == .eExperience{
                self.labelDescription.hidden = true
                let objItems = datasource as! Experience
                self.lableTitle.text = objItems.organisation_name!
                self.labelToDate.text = NSDate.dateFromTimeInterval(objItems.startDate!).getFormattedStringWithFormat()
                self.labelFromDate.text = NSDate.dateFromTimeInterval(objItems.endDate!).getFormattedStringWithFormat()
            }
            else{
                self.labelDescription.hidden = false
                 let objItems = datasource as! Education
            }
            
            
        }
    }
}
