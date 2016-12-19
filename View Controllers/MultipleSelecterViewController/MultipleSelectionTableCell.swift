//
//  MultipleSelectionTableCell.swift
//  Greenply
//
//  Created by Jitendra on 9/15/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MultipleSelectionTableCell: BaseTableViewCell {

    @IBOutlet weak var labelTitleName: UILabel!
    @IBOutlet weak var buttonCheckBox: UIButton!
    var item: Int!
    var check: Bool!
    
    override var datasource: AnyObject? {
        didSet {
            
                buttonCheckBox.selected = true
        }
    }

}
