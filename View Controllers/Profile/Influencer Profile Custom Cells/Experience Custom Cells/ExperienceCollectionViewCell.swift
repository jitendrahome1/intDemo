//
//  ExperienceCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 15/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class ExperienceCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var tableExp: UITableView!
    
    override var datasource: AnyObject? {
        didSet {
            
        }
    }
}
