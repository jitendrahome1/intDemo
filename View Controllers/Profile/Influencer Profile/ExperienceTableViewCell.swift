//
//  ExperienceTableViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 16/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class ExperienceTableViewCell: BaseTableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var labelFrom: UILabel!
    @IBOutlet weak var labelTo: UILabel!
    @IBOutlet weak var viewTitle: UIView!
    override var datasource: AnyObject? {
        didSet {
            debugPrint(datasource)
//            labelTitle.text = datasource!["degree"] as? String
//            labelDesc.text = datasource!["stream"] as? String
//            labelFrom.text = datasource!["start_date"] as? String
//            labelTo.text = datasource!["end_date"] as? String
            
            labelTitle.text = datasource!["Title"] as? String
            labelDesc.text = datasource!["Description"] as? String
            labelFrom.text = datasource!["From"] as? String
            labelTo.text = datasource!["To"] as? String

            debugPrint(datasource?.count)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       // viewTitle.layer.cornerRadius = IS_IPAD() ? 10.0 : 5.0
    }
}

