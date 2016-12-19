//
//  PDFloating.Swift
//  PDFloating
//
//  Created by Priyam Dutta on 27/08/16.
//  Copyright © 2016 Priyam Dutta. All rights reserved.
//

import UIKit

enum ButtonPosition {
	case center
	case topLeft
	case topRight
	case bottomLeft
	case bottomRight
	case midTop
	case midBottom
	case midLeft
	case midRight
}

func getRadian(degree: CGFloat) -> CGFloat {
	return CGFloat(degree * CGFloat(M_PI) / 180)
}

class PDFloating: UIButton {

	private let childButtonSize: CGFloat = 30.0
	private let delayInterval = 0.0
	private let duration = 0.25
	private let damping: CGFloat = 0.9
	private let initialVelocity: CGFloat = 0.9
	private var anchorPoint: CGPoint!

	private var xPadding: CGFloat = 10.0
	private var yPadding: CGFloat = 10.0
	private var buttonSize: CGFloat = 0.0
	private var childButtons = 0
	private var buttonPosition: ButtonPosition = .center
	private var childButtonsArray = [UIButton]()
	private var childLabelsArray = [UILabel]()
	private var imageArray = [String]()
	private var textArray = [String]()
	private var spacing: CGFloat = 40.0
	private var labelPadding: CGFloat = 20.0
	private var backView = UIView()

	var isOpen = false
	var buttonActionDidSelected: ((indexSelected: Int) -> ())!

	convenience init(withPosition position: ButtonPosition, size: CGFloat, numberOfPetals: Int, images: [String], labelStrings: [String]) {

		self.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
		self.layer.cornerRadius = size / 2.0

		childButtons = numberOfPetals
		buttonPosition = position
		imageArray = images
		textArray = labelStrings

		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.01 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {

			switch position {
			case .topLeft:
				self.center = CGPoint(x: (self.superview?.frame)!.minX + (size / 2.0) + self.xPadding, y: (self.superview?.frame)!.minY + (size / 2.0) + self.yPadding)
			case .topRight:
				self.center = CGPoint(x: (self.superview?.frame)!.maxX - (size / 2.0) - self.xPadding, y: (self.superview?.frame)!.minY + (size / 2.0) + self.yPadding)
			case .bottomLeft:
				self.center = CGPoint(x: (self.superview?.frame)!.minX + (size / 2.0) + self.xPadding, y: (self.superview?.frame)!.maxY - (size / 2.0) - self.yPadding)
			case .bottomRight:
				self.center = CGPoint(x: (self.superview?.frame)!.maxX - (size / 2.0) - self.xPadding, y: (self.superview?.frame)!.maxY - (size / 2.0) - self.yPadding)
			case .midTop:
				self.center = CGPoint(x: (self.superview?.frame)!.midX, y: (self.superview?.frame)!.minY + (size / 2.0) + self.yPadding)
			case .midBottom:
				self.center = CGPoint(x: (self.superview?.frame)!.midX, y: (self.superview?.frame)!.maxY - (size / 2.0) - self.yPadding)
			case .midLeft:
				self.center = CGPoint(x: (self.superview?.frame)!.minX + (size / 2.0) + self.xPadding, y: (self.superview?.frame)!.midY)
			case .midRight:
				self.center = CGPoint(x: (self.superview?.frame)!.maxX - (size / 2.0) - (self.xPadding), y: (self.superview?.frame)!.midY)
			default:
				self.center = CGPoint(x: (self.superview?.frame)!.midX, y: (self.superview?.frame)!.midY)
			}
			self.anchorPoint = self.center
			self.createButtonsWithLabels(numberOfPetals)
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
//		backgroundColor = .brownColor()
		self.addTarget(self, action: #selector(self.animateChildButtons(_:)), forControlEvents: .TouchUpInside)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// Create Buttons
	private func createButtonsWithLabels(numbers: Int) {

		for index in 0..<numbers {
			let petal = UIButton(frame: CGRect(x: 0, y: 0, width: childButtonSize, height: childButtonSize))
			petal.center = self.center
			petal.layer.cornerRadius = childButtonSize / 2.0
//            petal.backgroundColor = UIColor.cyanColor()
			petal.setTitleColor(UIColor.blackColor(), forState: UIControlState())
			petal.tag = index + 1
			if index < imageArray.count {
				petal.setBackgroundImage(UIImage(named: imageArray[index]), forState: UIControlState())
			}
//            petal.setTitle(String(index), forState: UIControlState())
			petal.addTarget(self, action: #selector(self.buttonAction(_:)), forControlEvents: .TouchUpInside)

			let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: childButtonSize))
			label.center = CGPointMake(CGRectGetMinX(petal.frame) - (CGRectGetWidth(label.frame) / 2.0) - labelPadding, CGRectGetMidY(petal.frame))
			label.textAlignment = .Right
//            label.alpha = 0.0
			label.hidden = true
			label.textColor = .whiteColor()
			label.font = PRIMARY_FONT(IS_IPAD() ? 18.0 : 15.0)
			if index < textArray.count {
				label.text = textArray[index]
			}
			self.superview?.addSubview(label)
			self.superview?.bringSubviewToFront(self)
			self.superview?.addSubview(petal)
			self.superview?.bringSubviewToFront(self)
			childButtonsArray.append(petal)
			childLabelsArray.append(label)
		}
	}

	// Present Buttons
	@IBAction func animateChildButtons(sender: UIButton) {
		scaleAnimate(sender)
		self.userInteractionEnabled = false
		if !isOpen {
			self.presentationFloatingButtons()
		} else {
			closeButtons()
		}
	}

	// Simple Scale
	private func scaleAnimate(sender: UIView) {
		UIView.animateWithDuration(self.duration, animations: {
			sender.transform = CGAffineTransformMakeScale(1.1, 1.1)
		}) { (complete) in
			UIView.animateWithDuration(self.duration, animations: {
				sender.transform = CGAffineTransformIdentity
			})
		}
	}

	// Presentation
	private func presentationFloatingButtons() {
		createBack()
		for (index, item) in self.childButtonsArray.enumerate() {
			item.transform = CGAffineTransformMakeScale(0.01, 0.01)
			childLabelsArray[index].hidden = false
			childLabelsArray[index].transform = CGAffineTransformMakeScale(0.01, 0.01)
			UIView.animateWithDuration(self.duration, delay: self.delayInterval + (Double(index) / 10), usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: UIViewAnimationOptions(), animations: {
				self.childLabelsArray[index].alpha = 1.0
				self.childLabelsArray[index].transform = CGAffineTransformMakeTranslation(0, -CGFloat((CGFloat(item.tag) + self.spacing) * CGFloat(item.tag)))
				item.transform = CGAffineTransformMakeTranslation(0, -CGFloat((CGFloat(item.tag) + self.spacing) * CGFloat(item.tag)))
				}, completion: { (completion) in
				self.isOpen = true
				if index == self.childButtonsArray.count - 1 {
					self.userInteractionEnabled = true
				}
			})
		}
	}

	// Close Button
	@objc func closeButtons() {
		UIView.animateWithDuration(self.duration, animations: {
			for (index, item) in self.childButtonsArray.enumerate() {
				self.childLabelsArray[index].alpha = 0.0
				self.childLabelsArray[index].transform = CGAffineTransformIdentity
				item.transform = CGAffineTransformIdentity
			}
			}, completion: { (completion) in
			self.isOpen = false
			self.userInteractionEnabled = true
			self.backView.removeFromSuperview()
		})
	}

    func removeButton() {
        for item in self.childButtonsArray {
            item.removeFromSuperview()
        }
        self.removeFromSuperview()
    }
    
	func createBack() {
		backView = UIView(frame: UIScreen.mainScreen().bounds)
		backView.backgroundColor = .blackColor()
		backView.alpha = 0.4
		backView.addGestureRecognizer(UITapGestureRecognizer (target: self, action: #selector(PDFloating.closeButtons)))
		self.superview!.addSubview(backView)
		self.superview?.insertSubview(backView, belowSubview: childLabelsArray[0])
	}

	@IBAction func buttonAction(sender: UIButton) {
		if isOpen {
			closeButtons()
		}
		if buttonActionDidSelected != nil {
			buttonActionDidSelected(indexSelected: sender.tag - 1)
		}
	}

}
