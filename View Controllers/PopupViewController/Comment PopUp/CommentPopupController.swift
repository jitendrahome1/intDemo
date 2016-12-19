//
//  CommentPopupController.swift
//  Greenply
//
//  Created by Jitendra on 9/20/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class CommentPopupController: BaseViewController {
 @IBOutlet weak var viewBG: UIView!
 @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var viewPopUp: UIView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textViewComment: JAPlaceholderTextView!
    
    var didSubmitButton:((text: String, popUp: CommentPopupController?) -> ())?
    var didRemove:(() -> ())?
    
    @IBOutlet weak var textViewDescription: JAPlaceholderTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CommentPopupController.tapDismissPopUp))
        self.viewBG.addGestureRecognizer(tapGesture)
        textViewDescription.layer.cornerRadius = 6.0
        textViewDescription.layer.borderWidth = 1.0
        textViewDescription.layer.borderColor = UIBorderColor().CGColor
        buttonSubmit.addTarget(self, action: #selector(CommentPopupController.buttonComments(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentPopupController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentPopupController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonComments(sender: UIButton) {
        self.view.endEditing(true)
        if textViewComment.text!.isBlank{
        Toast.show(withMessage: ENTER_COMMENT)
        }
        else{
            if didSubmitButton != nil {
            didSubmitButton!(text: textViewComment.text, popUp: self)
            }
        }
    }

    internal class func showAddOrClearPopUp(sourceViewController: UIViewController, didSubmit: ((text: String, popUp: CommentPopupController?) -> ()), didFinish: (() -> ())) {
        
        let commentPopVC = otherStoryboard.instantiateViewControllerWithIdentifier(String(CommentPopupController)) as! CommentPopupController
        commentPopVC.didSubmitButton = didSubmit
        commentPopVC.didRemove = didFinish
        commentPopVC.presentAddOrClearPopUpWith(sourceViewController)
    }
    
     func presentAddOrClearPopUpWith(sourceController: UIViewController) {
     self.view.frame = sourceController.view.bounds
        sourceController.view.addSubview(self.view)
        sourceController.addChildViewController(self)
        sourceController.view.bringSubviewToFront(self.view)
        presentAnimationToView()
    }
    
    // MARK: - Animation
    func presentAnimationToView() {
        viewBG.alpha = 0.0
        self.viewPopUp.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT)
        UIView.animateWithDuration(0.25) {
            self.viewBG.alpha = 0.5
            self.viewPopUp.transform = CGAffineTransformIdentity
        }
    }
    
    func dismissAnimate() {
        
        if didRemove != nil {
            didRemove!()
        }
        
        UIView.animateWithDuration(0.25, animations: {
            self.viewBG.alpha = 0.0
            self.viewPopUp.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT)
        }) { (true) in
            self.view.removeFromSuperview();
            self.removeFromParentViewController()
        }
    }
    
    func tapDismissPopUp(){
        if textViewComment.isFirstResponder() {
            self.view.endEditing(true)
        } else {
            self.dismissAnimate()
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            UIView.animateWithDuration(0.25) {
                self.viewPopUp.transform = IS_IPAD() ? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(0, -(keyboardSize.height / 2))
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.25) {
            self.viewPopUp.transform = CGAffineTransformIdentity
        }
    }
}
