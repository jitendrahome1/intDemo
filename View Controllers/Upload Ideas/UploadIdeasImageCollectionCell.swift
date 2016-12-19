//
//  UploadIdeasImageCollectionCell.swift
//  Greenply
//
//  Created by Chinmay Das on 22/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class UploadIdeasImageCollectionCell: BaseCollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    override var datasource: AnyObject? {
        didSet{
            if (datasource as! NSData).length != 0 {
                
                imageView.contentMode = .ScaleAspectFill
                imageView.image = UIImage(data: (datasource as? NSData)!)
            } else {
                imageView.contentMode = .Center
                imageView.image = UIImage(named: "AddPictureIcon")
            }
        }
    }
}
