//
//  CollectionCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 16/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class CollectionCell: BaseCollectionViewCell {

    @IBOutlet weak var imageLicense: UIImageView!
    override var datasource: AnyObject? {
        didSet {
            debugPrint(datasource)
            if  String(datasource!) == "AddPictureIcon" {
                imageLicense.contentMode = .Center
                imageLicense.image = UIImage(named: "AddPictureIcon")
            } else {
                imageLicense.contentMode = .ScaleAspectFill
                imageLicense.image = datasource as? UIImage//UIImage(data: (datasource as? NSData)!)
            }
        }
    }

}
