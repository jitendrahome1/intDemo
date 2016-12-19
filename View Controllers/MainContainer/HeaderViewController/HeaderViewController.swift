//
//  MenuViewController.swift
//  Greenply
//
//  Created by Jitendra on 9/9/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//
@objc protocol HeaderButtonDeleagte {
	optional func didTapMenuButton(strButtonType: String)
}
import UIKit

class HeaderViewController: UIViewController {

    @IBOutlet weak var buttonSearch: UIButton!
	@IBOutlet weak var buttonFilter: UIButton!
	@IBOutlet weak var buttonNotification: UIButton!
	@IBOutlet weak var buttonBack: UIButton!
	@IBOutlet weak var buttonMenu: UIButton!
	@IBOutlet weak var nsConstBackBtnWidth: NSLayoutConstraint!
	@IBOutlet weak var nsConstNotificationWidth: NSLayoutConstraint!
	@IBOutlet weak var labelHeaderTitle: UILabel!
    @IBOutlet weak var textSearch: UITextField!
    @IBOutlet weak var leadingImgBorder: NSLayoutConstraint!
    @IBOutlet weak var imgBorder: UIImageView!
    @IBOutlet weak var lblNotification: UILabel!
    
	var strButtonType: String = ""
	var delegateButton: HeaderButtonDeleagte?
	override func viewDidLoad() {
		super.viewDidLoad()
        lblNotification.layer.cornerRadius = lblNotification.frame.size.width/2
        imgBorder.alpha = 0
        leadingImgBorder.constant = 130
		NavigationHelper.helper.headerViewController = self
        textSearch.attributedPlaceholder = NSAttributedString(string:"Search",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
		// MARK:- Action
		buttonMenu.addTarget(self, action: #selector(self.didSelectMenuAction(_:)), forControlEvents: .TouchUpInside)
		buttonBack.addTarget(self, action: #selector(self.didBackAction(_:)), forControlEvents: .TouchUpInside)
		buttonNotification.addTarget(self, action: #selector(self.didNotificationAction(_:)), forControlEvents: .TouchUpInside)
		buttonFilter.addTarget(self, action: #selector(self.didFilterAction(_:)), forControlEvents: .TouchUpInside)
        buttonSearch.addTarget(self, action: #selector(self.didTapSearch(_:)), forControlEvents: .TouchUpInside)
	}
	override func viewDidLayoutSubviews() {
		labelHeaderTitle.font = labelHeaderTitle.font.fontWithSize(IS_IPAD() ? 26 : 18)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
        buttonSearch.hidden = true
        labelHeaderTitle.alpha = 1.0
        textSearch.hidden = true

	}
    
    
    func hideUnhideSearch(){
         self.textSearch.text = ""
        self.labelHeaderTitle.alpha = 1.0
        self.textSearch.hidden = true
        
    }
    func didTapSearch(sender: UIButton) {
        
        if sender.selected {
            imgBorder.alpha = 1.0
            textSearch.resignFirstResponder()
            leadingImgBorder.constant = imgBorder.frame.size.width
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.view.layoutIfNeeded()
                }, completion: { (finished: Bool) in
                    self.labelHeaderTitle.alpha = 1.0
                    self.textSearch.hidden = true
            })
            sender.selected = false
        } else {
            imgBorder.alpha = 1.0
            leadingImgBorder.constant = 0
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.view.layoutIfNeeded()
                }, completion: { (finished: Bool) in
                    self.labelHeaderTitle.alpha = 0
                    self.textSearch.hidden = false
            })
            sender.selected = true
        }
    }

	func didSelectMenuAction(sender: UIButton)
	{
//        if NavigationHelper.helper.contentNavController!.viewControllers.containsObject(ProjectListingController).isPresent {
//            let addPortfolioVC = otherStoryboard.instantiateViewControllerWithIdentifier(String(AddPortfolioViewController)) as! AddPortfolioViewController
//            NavigationHelper.helper.tabBarViewController!.hideTabBar()
//            NavigationHelper.helper.contentNavController!.pushViewController(addPortfolioVC, animated: true)
//        } else {
//            NavigationHelper.helper.openSidePanel(!NavigationHelper.helper.isOpen)
//        }
		if strButtonType == kPluseButton {
			self.delegateButton?.didTapMenuButton!(kPluseButton)
		} else if strButtonType == KHeaderTickButton {
			self.delegateButton?.didTapMenuButton!(KHeaderTickButton)
		}
		else {
			NavigationHelper.helper.openSidePanel(!NavigationHelper.helper.isOpen)
		}

	}

	func didBackAction(sender: UIButton)
	{
		CDSpinner.hide()
        self.hideUnhideSearch()
		NavigationHelper.helper.openSidePanel(false)
        NavigationHelper.helper.contentNavController!.popViewControllerAnimated(true)
    
	}
	func didNotificationAction(sender: UIButton)
	{
		NavigationHelper.helper.openSidePanel(false)
		debugPrint("controller \(NavigationHelper.helper.contentNavController!.viewControllers.last)")
		let notificationVC = otherStoryboard.instantiateViewControllerWithIdentifier(String(NotificationViewController)) as! NotificationViewController
		// NavigationHelper.helper.currentViewController = notificationVC
		NavigationHelper.helper.tabBarViewController!.hideTabBar()
		NavigationHelper.helper.contentNavController!.pushViewController(notificationVC, animated: true)

	}

	func didFilterAction(sender: UIButton) {
		NavigationHelper.helper.openSidePanel(false)
		MultiSelectionViewController.showMultipleSelectionView(self)

	}

	// MARK:- chnage button Image
	func addHeaderButton(addButtonName: String)
	{ var image = UIImage()
		if addButtonName == kPluseButton {
            NavigationHelper.helper.enableSideMenuSwipe = false
			image = UIImage(named: kPluseImage)!
			buttonMenu.setImage(image, forState: UIControlState.Normal)
			strButtonType = kPluseButton
		}
		else if addButtonName == KHeaderTickButton {
              NavigationHelper.helper.enableSideMenuSwipe = false
			image = UIImage(named: kHeaderTickImage)!
			buttonMenu.setImage(image, forState: UIControlState.Normal)
			strButtonType = KHeaderTickButton
		} else {
            NavigationHelper.helper.enableSideMenuSwipe = true
			image = UIImage(named: kMenuImage)!
			buttonMenu.setImage(image, forState: UIControlState.Normal)
			strButtonType = kPluseButton
			strButtonType = KMenuButton
		}

	}

//    // MARK:- add plus button.
	func addPlusButton() {

		var imageBtn = UIImage()
		imageBtn = UIImage(named: "MenuIcon.png")!
		buttonMenu.setImage(imageBtn, forState: UIControlState.Normal)
          NavigationHelper.helper.enableSideMenuSwipe = true
		// }
	}
	// MARK:- Add Search And Filter Button.
	func addSearchAndFiltterButton() {
		if NavigationHelper.helper.contentNavController!.viewControllers.containsObject(IdeaListingController).isPresent || NavigationHelper.helper.contentNavController!.viewControllers.containsObject(MeetAnExpertViewController).isPresent {
			buttonFilter.setImage(UIImage(named: "FilterIcon.png"), forState: UIControlState.Normal)
		}
		else {
			buttonFilter.setImage(UIImage(named: "SearchIcone.png"), forState: UIControlState.Normal)
		}
	}

	// MARK:- Set Header Bar Buttons Function
	func setHeaderBarButtonsWith(isHideBackButton isHideBackButton: Bool, isHideFilterButton: Bool, isHidenotification: Bool, isHideMenuButton: Bool) {
		strButtonType = ""
        labelHeaderTitle.alpha = 1.0
        textSearch.hidden = true
		self.addPlusButton()
		self.addSearchAndFiltterButton()
		// Set buttons Status...
		self.setHeaderBarButtonsWith(isHideBackButton: isHideBackButton, isHideFilterButton: isHideFilterButton, isHidenotification: isHidenotification, isHideMenuButton: isHideMenuButton, animation: true)
	}
    
    // MARK:- Set Header Bar Button for Normal Controller

	func setHeaderBarButtonsWith(isHideBackButton isHideBackButton: Bool, isHideFilterButton: Bool, isHidenotification: Bool, isHideMenuButton: Bool, animation: Bool) {
        buttonSearch.hidden = true
		if isHideBackButton == true {
			NavigationHelper.helper.headerViewController!.view.layoutIfNeeded()
			if animation {
				UIView.animateWithDuration(0.4, animations: {
					NavigationHelper.helper.headerViewController!.nsConstBackBtnWidth.constant = 0.0
					NavigationHelper.helper.headerViewController!.view.layoutIfNeeded()
				})
			} else {
				NavigationHelper.helper.headerViewController!.nsConstBackBtnWidth.constant = 0.0
				NavigationHelper.helper.headerViewController!.view.layoutIfNeeded()
			}
		}
		if isHideBackButton == false {
			if animation {
				UIView.animateWithDuration(0.4, animations: {
					NavigationHelper.helper.headerViewController!.nsConstBackBtnWidth.constant = 42
					NavigationHelper.helper.headerViewController!.view.layoutIfNeeded()
				})
			} else {
				NavigationHelper.helper.headerViewController!.nsConstBackBtnWidth.constant = 42
				NavigationHelper.helper.headerViewController!.view.layoutIfNeeded()
			}
		}
        
        if INTEGER_FOR_KEY(kUserID) != 0{
            if isHidenotification == true {
                lblNotification.hidden = true
                NavigationHelper.helper.headerViewController!.nsConstNotificationWidth.constant = 0.0
            }
            if isHidenotification == false {
                 lblNotification.hidden = false
                NavigationHelper.helper.headerViewController!.nsConstNotificationWidth.constant = 42
            }
        }
        else{
             lblNotification.hidden = true
            NavigationHelper.helper.headerViewController!.nsConstNotificationWidth.constant = 0.0
        }
		
     
        
            
        

		buttonFilter.hidden = isHideFilterButton
		buttonMenu.hidden = isHideMenuButton
	}
    
    // MARK:- Set Header Bar Button for IdeasListingController
    
    func setHeaderBarButtonsWithIdeas(isHideBackButton isHideBackButton: Bool, isHideFilterButton: Bool, isHidenotification: Bool, isHideMenuButton: Bool, isHideSearchButton: Bool) {
        strButtonType = ""
        self.addPlusButton()
        self.addSearchAndFiltterButton()
        // Set buttons Status...
        self.setHeaderBarButtonsWithIdeas(isHideBackButton: isHideBackButton, isHideFilterButton: isHideFilterButton, isHidenotification: isHidenotification, isHideMenuButton: isHideMenuButton, isHideSearchButton: isHideSearchButton, animation: true)
    }
    
    func setHeaderBarButtonsWithIdeas(isHideBackButton isHideBackButton: Bool, isHideFilterButton: Bool, isHidenotification: Bool, isHideMenuButton: Bool, isHideSearchButton: Bool, animation: Bool) {
        if isHideBackButton == true {
            NavigationHelper.helper.headerViewController!.view.layoutIfNeeded()
            if animation {
                UIView.animateWithDuration(0.4, animations: {
                    NavigationHelper.helper.headerViewController!.nsConstBackBtnWidth.constant = 0.0
                    NavigationHelper.helper.headerViewController!.view.layoutIfNeeded()
                })
            } else {
                NavigationHelper.helper.headerViewController!.nsConstBackBtnWidth.constant = 0.0
                NavigationHelper.helper.headerViewController!.view.layoutIfNeeded()
            }
        }
        if isHideBackButton == false {
            if animation {
                UIView.animateWithDuration(0.4, animations: {
                    NavigationHelper.helper.headerViewController!.nsConstBackBtnWidth.constant = 42
                    NavigationHelper.helper.headerViewController!.view.layoutIfNeeded()
                })
            } else {
                NavigationHelper.helper.headerViewController!.nsConstBackBtnWidth.constant = 42
                NavigationHelper.helper.headerViewController!.view.layoutIfNeeded()
            }
        }
        if isHideSearchButton == false {
            NavigationHelper.helper.headerViewController!.view.layoutIfNeeded()
            buttonSearch.hidden = false
        }
        
        if INTEGER_FOR_KEY(kUserID) != 0{
            if isHidenotification == true {
                 lblNotification.hidden = true
                NavigationHelper.helper.headerViewController!.nsConstNotificationWidth.constant = 0.0
            }
            if isHidenotification == false {
                lblNotification.hidden = false
                NavigationHelper.helper.headerViewController!.nsConstNotificationWidth.constant = 42
            }
        }
        else{
             lblNotification.hidden = true
            NavigationHelper.helper.headerViewController!.nsConstNotificationWidth.constant = 0.0
        }
        
        
        buttonFilter.hidden = isHideFilterButton
        
     
        buttonMenu.hidden = isHideMenuButton
        
    }

}
