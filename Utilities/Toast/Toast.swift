//
//  Toast.swift
//  Greenply
//
//  Created by Chinmay Das on 21/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class Toast: UIView {
    
    class func show(withMessage message:String){
        //calculated height of toast with full width
        let tempHeight = message.requiredHeight(forWidth: SCREEN_WIDTH - (40 * 2), andFont: PRIMARY_FONT(IS_IPAD() ? 22 : 18)!)
        //height of toast
        let height = tempHeight > 40 ? tempHeight + 20 : 40
        
        Toast.show(withMessage: message, andAtYPosition: SCREEN_HEIGHT - (IS_IPAD() ? 80 : 40) - height)
    }
    
    class func show(withMessage message:String, andAtYPosition y: CGFloat){
        
        //calculated height of toast with full width
        let tempHeight = message.requiredHeight(forWidth: SCREEN_WIDTH - (40 * 2), andFont: PRIMARY_FONT(IS_IPAD() ? 22 : 18)!)
        //height of toast
        let height = tempHeight > 40 ? tempHeight + 20 : 40
        //calculated width of toast with respect to height
        let width = tempHeight <= 30 ? message.requiredWidth(forHeight: 30, andFont: PRIMARY_FONT(IS_IPAD() ? 22 : 18)!) + 40 : SCREEN_WIDTH - (20 * 2)
        
        //Main toast configuration which is clearcolor with shadow without corner radious
        let toast = Toast(frame: CGRectMake((SCREEN_WIDTH / 2) - (width / 2), y, width, height))
        toast.alpha = 0
        toast.layer.shadowColor = UIColor.blackColor().CGColor;
        toast.layer.shadowOffset = CGSizeMake(0.0, 5.0);
        toast.layer.shadowOpacity = 0.5;
        toast.backgroundColor = .clearColor()
        
        //configuration of View inside main toast view having black color and corner radious 5
        let insideView = UIView(frame: toast.bounds)
        insideView.backgroundColor = UIColorRGBA(0, g: 0, b: 0, a: 0.9)
        insideView.layer.cornerRadius = 5
        insideView.clipsToBounds = true
        
        //configuration the label of toast in the inside view
        let label = UILabel(frame: CGRectMake(20, 0, CGRectGetWidth(toast.bounds) - 40, CGRectGetHeight(toast.bounds)))
        label.textColor = .whiteColor()
        label.textAlignment = .Center
        label.text = message
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        
        insideView.addSubview(label)//adding label in inside view
        toast.addSubview(insideView)//adding inside view in main toast
        
        MAIN_WINDOW?.addSubview(toast)
        UIView.animateWithDuration(0.1) {
            toast.alpha = 1
        }
        let seconds = 3.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            // here code perfomed with delay
            UIView.animateWithDuration(0.1, animations: {
                toast.alpha = 0
                }, completion: { (completed) in
                    toast.removeFromSuperview()
            })
        })
    }
}
