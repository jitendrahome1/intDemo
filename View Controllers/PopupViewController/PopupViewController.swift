//
//  PopupViewController.swift
//  Greenply
//
//  Created by Jitendra on 9/12/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//
@objc protocol PopupEditProject {
    optional func didTapSubmit(isTap: Bool)
    
}
import UIKit

class PopupViewController: BaseViewController {
    
    @IBOutlet weak var viewMainBG: UIView!
   
    @IBOutlet weak var nsContSelectType: NSLayoutConstraint!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var buttonSelectType: UIButton!
    var imageEditID: Int?
    var deleagteEditImage: PopupEditProject?
    var arrStypeType: [AnyObject]?
    var data: [AnyObject]?
    @IBOutlet weak var textViewDescription: JAPlaceholderTextView!
    
    @IBOutlet weak var buttonSave: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UISetup()
        // Do any additional setup after loading the view.
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
    
    func UISetup()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PopupViewController.tapDismissPopUp))
        self.viewMainBG.addGestureRecognizer(tapGesture)
        buttonSelectType.layer.cornerRadius = 5.0;
        buttonSelectType.layer.borderWidth = 0.8;
        buttonSelectType.layer.borderColor = UIBorderColor().CGColor
        
        // buttonSelectType.imageEdgeInsets = UIEdgeInsetsMake(0, CGRectGetWidth(buttonSelectType.frame), 0, 0)
        
        // buttonSelectType.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
        textViewDescription.layer.cornerRadius = 5.0;
        textViewDescription.layer.borderWidth = 0.8;
        textViewDescription.layer.borderColor = UIBorderColor().CGColor
        viewBG.layer.cornerRadius = 7.0
        
        let imageSize: CGSize = buttonSelectType.imageView!.frame.size;
        let width =  IS_IPAD() ? CGRectGetWidth(buttonSelectType.frame) : 248
        buttonSelectType.titleEdgeInsets = UIEdgeInsetsMake(0, IS_IPAD() ? -40 : -10, 0, 40)
        buttonSelectType.imageEdgeInsets = UIEdgeInsetsMake(0, width - imageSize.width - 5, 0,0)
    }
    
    internal class func showAddOrClearPopUp(sourceViewController: UIViewController, Title: String, showRoomButtonType: Bool, arrData: [AnyObject]?, imageID: Int?) {
        
        let viewController = otherStoryboard.instantiateViewControllerWithIdentifier(String(PopupViewController)) as! PopupViewController
       
        viewController.presentAddOrClearPopUpWith(sourceViewController, Title: Title, showRoomButtonType: showRoomButtonType,arrData:arrData, imageValue: imageID!)
    }
    
    func presentAddOrClearPopUpWith(sourceController: UIViewController , Title: String, showRoomButtonType: Bool, arrData: [AnyObject]?, imageValue: Int?) {
       
        self.arrStypeType = arrData
        self.view.frame = sourceController.view.bounds
        labelTitle.text = Title
        self.imageEditID = imageValue
        //buttonSelectType.translatesAutoresizingMaskIntoConstraints = true
        if showRoomButtonType == true{
        nsContSelectType.constant = 45.0
    
        }
        else{
        nsContSelectType.constant = 0.0
       // buttonSelectType.hidden = true
        }
        
        buttonSelectType.setNeedsUpdateConstraints();
        buttonSelectType.setNeedsLayout();
       buttonSelectType.layoutIfNeeded()
      
        sourceController.view.addSubview(self.view)
        sourceController.addChildViewController(self)
        sourceController.view.bringSubviewToFront(self.view)
        presentAnimationToView()
        
    }
    
    // MARK: - Animation
    func presentAnimationToView() {
        viewMainBG.alpha = 0.0
        self.viewBG.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT)
        UIView.animateWithDuration(0.25) {
            self.viewMainBG.alpha = 0.5
            self.viewBG.transform = CGAffineTransformIdentity
        }
    }
    
    func dismissAnimate() {
//        if didRemove != nil {
//            didRemove!()
//        }
        
        UIView.animateWithDuration(0.25, animations: {
            self.viewMainBG.alpha = 0.0
            self.viewBG.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT)
        }) { (true) in
            self.view.removeFromSuperview();
            self.removeFromParentViewController()
        }
    }
    func tapDismissPopUp(){
        self.dismissAnimate()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            UIView.animateWithDuration(0.25) {
                self.viewBG.transform = IS_IPAD() ? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(0, -(keyboardSize.height / 2))
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.25) {
            self.viewBG.transform = CGAffineTransformIdentity
        }
    }
    
    @IBAction func actionSelectType(sender: UIButton) {
        self.view.endEditing(true)
        var arrValue = [String]()
        for value in self.arrStypeType! {
        
            let styleName = value["name"] as! String
            let styleTypeId = value["id"] as! String
            let stypeData = "\(styleName)+\(styleTypeId)"
            arrValue.append(stypeData)
        }
        GPPickerViewController.showPickerController(self, isDatePicker: false, pickerArray: arrValue, position: .Bottom, pickerTitle: "", preSelected: "") { (value, index) in
            
         self.data = value.componentsSeparatedByString("+")
            self.buttonSelectType.setTitle(self.data![0] as? String, forState: .Normal)
            print("Value\(value)")
        }
        
        
    }
    @IBAction func actionSave(sender: AnyObject) {
        
        if !(self.ValidateFields())
        {
            print(" some thing is missing")
            return;
        }
        self.dismissAnimate()
        // Call Api
        
        self.editImageApi()
    }
    // mark-  ValidateFields
    func ValidateFields() -> Bool
    {
        self.view.endEditing(true)
        let result = true
        if !(self.data?.count > 0){
            Toast.show(withMessage: SELECT_STYLE_TYPE)
            return false
        }
        else if self.textViewDescription.text == "" {
            Toast.show(withMessage: ENTER_DESCRIPTION)
            return false
        }
        
        return result
    }
 
}
// Api Calling
extension PopupViewController{
 // api calling
    
    func editImageApi(){
        APIHandler.handler.editProjectImage(self.imageEditID!, attribute_value_id: self.data![1] as? String, description: self.textViewDescription.text, success: { (response) in
            print("Response Edit Image\(response)")
        }) { (error) in
            
        }
    }

}
