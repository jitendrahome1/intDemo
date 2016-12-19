//
//  ProfileViewTableViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 16/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class ProfileViewTableViewCell: BaseTableViewCell {

    @IBOutlet weak var imageBackgroundProfile: UIImageView!
    @IBOutlet weak var imageProfile: UIImageView!
    var didSelectImage:(() -> ())?
    var didSelectBackgroundImage:(() -> ())?
    override var datasource: AnyObject? {
        didSet {
            if self.datasource != nil {
                //imageProfile.layoutIfNeeded()
                //imageBackgroundProfile.layer.cornerRadius = imageProfile.frame.size.width/2
                //imageBackgroundProfile.layer.masksToBounds = true
                imageBackgroundProfile.image = datasource as? UIImage
                makeBlurImage(imageBackgroundProfile)
            }
        }
    }
    
    @IBAction func imageAction(sender: UIButton) {
        if didSelectImage != nil {
            didSelectImage!()
        }

    }
    
    @IBAction func imageBackgroundAction(sender: UIButton) {
        if didSelectBackgroundImage != nil {
            didSelectBackgroundImage!()
        }
    }
    
}

extension ProfileViewTableViewCell {
    
    func makeBlurImage(imageView:UIImageView?)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = imageView!.bounds
        
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        imageView?.addSubview(blurEffectView)
    }
    
}
