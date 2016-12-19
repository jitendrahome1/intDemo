//
//  JobCostTableViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 16/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class JobCostTableViewCell: BaseTableViewCell {

    @IBOutlet weak var buttonCost: UIButton!
    override var datasource: AnyObject? {
        didSet {
            buttonCost.setTitle((self.datasource as? String), forState: .Normal)
            buttonCost.addTarget(self, action: #selector(JobCostTableViewCell.buttonCheck(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
}


extension JobCostTableViewCell {
    
    func buttonCheck(sender: UIButton!) {
        if sender.selected {
            sender.selected = false
        } else {
            sender.selected = true
        }
    }
}


