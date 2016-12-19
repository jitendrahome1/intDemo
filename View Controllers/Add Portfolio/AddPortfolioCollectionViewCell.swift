//
//  AddPortfolioCollectionViewCell.swift
//  Greenply
//
//  Created by Jitendra on 8/31/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class AddPortfolioCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    var didTapEditImage:((imageID:Int?) -> ())?
     var didTapCrossImage:((imageID:Int?) -> ())?
    @IBOutlet weak var buttonEditImag: UIButton!
    @IBOutlet weak var buttonCrossImage: UIButton!
    var indexImageID: [AnyObject]?
    var indexValue: Int?
    override var datasource: AnyObject? {
        didSet{
            if  String(datasource!) == "AddPictureIcon" {
                imageView.contentMode = .Center
                imageView.image = UIImage(named: "AddPictureIcon")
            }
            else {
                imageView.contentMode = .ScaleAspectFill
                print("ImageIds\(indexImageID)")
                imageView.image = datasource as? UIImage
            }
        }
    }

@IBAction func actionEditImage(sender: UIButton) {
    
   if (didTapEditImage != nil) {
    let value = self.indexImageID![indexValue!]
    didTapEditImage!(imageID: Int(value as! String))
        }
    
    }
    
    @IBAction func actionCrossImage(sender: UIButton) {
        if (didTapCrossImage != nil) {
            let value = self.indexImageID![indexValue!]
            didTapCrossImage!(imageID: Int(value as! String))
        }
    }
}
