//
//  CDSpinner.swift
//  SpinnerMaterial
//
//  Created by Chinmay Das on 26/09/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

import UIKit

let SPINER_HEIGHT = CGFloat(60.0)
let LOADER_IMAGE = ""

class CDSpinner: UIView {

	var circleLayer: CAShapeLayer?
	var isAnimating = false

	static var tempSelf: CDSpinner? = CDSpinner()
	static var tempImage: UIImageView?
	static var tempBlurView: UIView?

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInIt()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInIt()
	}

	func commonInIt() {
		circleLayer = CAShapeLayer()
		self.layer.addSublayer(circleLayer!)

		circleLayer?.fillColor = nil
		circleLayer?.lineCap = kCALineCapRound
		circleLayer?.lineWidth = 1.5

		circleLayer?.strokeColor = UIColor.orangeColor().CGColor
		circleLayer?.strokeStart = 0.0
		circleLayer?.strokeEnd = 0.0
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		if !CGRectEqualToRect(circleLayer!.frame, self.bounds) {
			self.updateCircleLayer()
		}
	}

	func updateCircleLayer() {
		let center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0)
		let radius = CGRectGetHeight(self.bounds) / 2.0 - circleLayer!.lineWidth / 2.0
		let startAngle = CGFloat(0.0)
		let endAngle = CGFloat(2 * M_PI)

		let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

		circleLayer?.path = path.CGPath
		circleLayer?.frame = self.bounds
	}

	func forceBeginRefreshing() {
		isAnimating = false
		beginRefreshing()
	}

	func beginRefreshing() {
		if isAnimating {
			return
		}

		isAnimating = true

		let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
		rotateAnimation.values = [0, M_PI, 2 * M_PI]

		let headAnimation = CABasicAnimation()
		headAnimation.keyPath = "strokeStart"
		headAnimation.duration = 1.0;
		headAnimation.fromValue = 0.0;
		headAnimation.toValue = 0.25;

		let tailAnimation = CABasicAnimation()
		tailAnimation.keyPath = "strokeEnd"
		tailAnimation.duration = 1.0
		tailAnimation.fromValue = 0.0
		tailAnimation.toValue = 1.0

		let endHeadAnimation = CABasicAnimation()
		endHeadAnimation.keyPath = "strokeStart"
		endHeadAnimation.beginTime = 1.0
		endHeadAnimation.duration = 1.0
		endHeadAnimation.fromValue = 0.25
		endHeadAnimation.toValue = 1.0;

		let endTailAnimation = CABasicAnimation()
		endTailAnimation.keyPath = "strokeEnd"
		endTailAnimation.beginTime = 1.0
		endTailAnimation.duration = 1.0
		endTailAnimation.fromValue = 1.0
		endTailAnimation.toValue = 1.0

		let animations = CAAnimationGroup()
		animations.duration = 2.0
		animations.animations = [rotateAnimation, headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]
		animations.repeatCount = Float.infinity;

		circleLayer?.addAnimation(animations, forKey: "animations")
	}

	func endRefreshing() {
		isAnimating = false
		circleLayer?.removeAnimationForKey("animations")
	}

	class func show() {
        CDSpinner.show(onViewControllerView: NavigationHelper.helper.mainContainerViewController!.view, withFrame: CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64))
	}

    class func show(onViewControllerView view: UIView)
    {
        CDSpinner.show(onViewControllerView: view, withFrame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
    }
    
    class func show(onViewControllerView view: UIView, withFrame frameBlurView:CGRect) {
        var spiner: CDSpinner?
        var imageView: UIImageView?
        let bothFrame = CGRectMake(100, 100, SPINER_HEIGHT, SPINER_HEIGHT)
        var backLayer: UIView?
        
        if (CDSpinner.tempSelf)!.isAnimating {
            spiner = CDSpinner.tempSelf
            imageView = CDSpinner.tempImage
            backLayer = CDSpinner.tempBlurView
        } else {
            spiner = CDSpinner()
            imageView = UIImageView(frame: bothFrame)
            backLayer = UIView(frame: frameBlurView)
        }
        
        
        imageView!.image = UIImage(named: LOADER_IMAGE)
        imageView?.layer.cornerRadius = SPINER_HEIGHT / 2
        imageView?.layer.masksToBounds = true
        
        spiner!.circleLayer!.lineWidth = 2.0;
        spiner!.circleLayer!.strokeColor = UIColor.greenColor().CGColor;
        
        spiner!.frame = imageView!.bounds
        
        backLayer?.backgroundColor = UIColorRGBA(0, g: 0, b: 0, a: 0.5)
        imageView?.frame = CGRectMake((CGRectGetWidth(backLayer!.bounds) / 2) - (SPINER_HEIGHT / 2), (CGRectGetHeight(backLayer!.bounds) / 2) - (SPINER_HEIGHT / 2), SPINER_HEIGHT, SPINER_HEIGHT)
        imageView!.addSubview(spiner!)
        backLayer!.addSubview(imageView!)
        
        if !(CDSpinner.tempSelf)!.isAnimating {
            view.addSubview(backLayer!)
        }
        
        CDSpinner.tempImage = imageView
        CDSpinner.tempSelf = spiner
        CDSpinner.tempBlurView = backLayer
        spiner!.beginRefreshing()
    }
    
	class func hide() {
		if CDSpinner.tempSelf != nil && CDSpinner.tempBlurView != nil {
			CDSpinner.tempSelf?.endRefreshing()
			CDSpinner.tempBlurView!.removeFromSuperview()
		}
	}
}
