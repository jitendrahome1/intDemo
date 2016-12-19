//
//  GPPickerViewController.swift
//  Greenply
//
//  Created by Chinmay Das on 26/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

public enum PickerPosition {
    case Center
    case Bottom
}

class GPPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var pickerView: UIView!
    @IBOutlet var labelSetDate: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet weak var listPicker: UIPickerView!
    var listPickerArray = [String]()
    var pickerSelected: ((value: AnyObject!, index: Int!) -> ())?
    var selectedValue: AnyObject!
    var selectedIndex: Int!
    var isDatePicker = false
    var preValue: String?
    var preIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTap(_:))))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    internal class func showPickerController(sourceViewController: UIViewController, isDatePicker: Bool, pickerArray: [String], position: PickerPosition, pickerTitle: String, preSelected: String, selected: (value: AnyObject!, index: Int!) -> ()) {
        if !isDatePicker && pickerArray.count == 0 {
            Toast.show(withMessage: NO_LISTING)
            return
        }
        let viewController = otherStoryboard.instantiateViewControllerWithIdentifier(String(GPPickerViewController)) as! GPPickerViewController
        viewController.pickerSelected = selected
        viewController.isDatePicker = isDatePicker
        viewController.presentPickerWith(sourceViewController, isDatePicker: isDatePicker, pickerArray: pickerArray,position:position, pickerTitle: pickerTitle, preSelected: preSelected)
    }
    
    func presentPickerWith(sourceController: UIViewController, isDatePicker: Bool, pickerArray: [String], position: PickerPosition, pickerTitle: String, preSelected: String) {
        self.view.frame = UIScreen.mainScreen().bounds
        UIApplication.sharedApplication().windows.first!.addSubview(self.view)
        sourceController.addChildViewController(self)
        self.didMoveToParentViewController(sourceController)
        sourceController.view.bringSubviewToFront(self.view)
        pickerView.translatesAutoresizingMaskIntoConstraints = true
        labelSetDate.text = pickerTitle
        if isDatePicker {
            datePicker.hidden = false
            listPicker.hidden = true
            selectedIndex = 0
            getDatePickerDate()
        } else {
            datePicker.hidden = true
            listPicker.hidden = false
            listPicker.delegate = self
            listPicker.dataSource = self
            listPickerArray.removeAll()
            listPickerArray = pickerArray
            selectedValue = listPickerArray[0]
            selectedIndex = 0
        }
        
                if !isDatePicker {
                    preValue = preSelected
                    if pickerArray.contains(preSelected) {
                        preIndex = pickerArray.indexOf(preSelected)!
                        listPicker.selectRow(pickerArray.indexOf(preSelected)!, inComponent: 0, animated: false)
                    }
                }
        if !IS_IPAD() {
            pickerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200.0)
        }
        pickerView.center = CGPoint(x: CGRectGetMidX(self.view.frame), y: IS_IPAD() ? CGRectGetMidY(self.view.frame) : (SCREEN_HEIGHT - (CGRectGetHeight(pickerView.frame)/2)))
        //presentAnimationToView()
        
        
        
//        if !isDatePicker {
//            preValue = preSelected
//            if pickerArray.contains(preSelected) {
//                preIndex = pickerArray.indexOf(preSelected)!
//                listPicker.selectRow(pickerArray.indexOf(preSelected)!, inComponent: 0, animated: false)
//            }
//        }
//        if !IS_IPAD() {
//            if position == .Center {
//                pickerView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 50 , 200.0)
//                pickerView.layer.cornerRadius = 10.0
//                pickerView.layer.masksToBounds = true
//            }else{
//                pickerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200.0)
//            }
//        }else{
//            pickerView.layer.cornerRadius = 10.0
//            pickerView.layer.masksToBounds = true
//        }
//        if position == .Center {
//            pickerView.center = CGPoint(x: CGRectGetMidX(self.view.frame), y:CGRectGetMidY(self.view.frame))
//        }else if position == .Bottom{
//            pickerView.center = CGPoint(x: CGRectGetMidX(self.view.frame), y: (SCREEN_HEIGHT - (CGRectGetHeight(pickerView.frame) / 2)))
//        }
//        
        
        
        // Old Code
        
        //		if !IS_IPAD() {
        //			pickerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200.0)
        //		}
        //		pickerView.center = CGPoint(x: CGRectGetMidX(self.view.frame), y: IS_IPAD() ? CGRectGetMidY(self.view.frame) : (SCREEN_HEIGHT - (CGRectGetHeight(pickerView.frame) / 2)))
        
        
        // End Old Code
        presentAnimationToView()
    }
    
    // MARK: - Picker View Delegate & Datasource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listPickerArray.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: IS_IPAD() ? 24 : 16)
        let listArr = listPickerArray[row].componentsSeparatedByString("+")
        pickerLabel.text = listArr[0]
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = listPickerArray[row]
        selectedIndex = row
    }
    
    // MARK: - Animation
    func presentAnimationToView() {
        pickerView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT)
        UIView.animateWithDuration(0.25, animations: {
            self.pickerView.transform = CGAffineTransformIdentity
        }) { (complete) in
        }
    }
    
    func dismissAnimate() {
        UIView.animateWithDuration(0.25, animations: {
            self.pickerView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT)
        }) { (true) in
            self.view.removeFromSuperview();
            self.removeFromParentViewController()
        }
    }
    
    func getDatePickerDate() {
        selectedValue = datePicker.date.dateToStringWithCustomFormat("dd MMM yyyy")
        labelSetDate.text = selectedValue as? String
    }
    
    // MARK: IBAction
    func didTap(gesture: UITapGestureRecognizer) {
        pickerSelected!(value: preValue, index: preIndex)
        dismissAnimate()
    }
    
    @IBAction func dateSelectAction(sender: AnyObject) {
        pickerSelected!(value: selectedValue, index: selectedIndex)
        dismissAnimate()
    }
    
    @IBAction func datePickerAction(sender: AnyObject) {
        getDatePickerDate()
    }
}
