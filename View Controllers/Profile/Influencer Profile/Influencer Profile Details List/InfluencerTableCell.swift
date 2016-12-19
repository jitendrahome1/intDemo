//
//  InfluencerTableCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 19/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class InfluencerTableCell: BaseTableViewCell {

    @IBOutlet weak var textTitle: JATextField!
    @IBOutlet weak var textDescription: JATextField!
    @IBOutlet weak var textFrom: JATextField!
    @IBOutlet weak var textTo: JATextField!
    var strDictStaus: String?
    @IBOutlet weak var buttonAdd: UIButton!
    var index: Int?
    var dict: [String: AnyObject]?
    var addCell:((sender: UIButton, index: Int) -> ())!
    var didSelectFromDate:((pTextField: UITextField?, textTitle: UITextField?, textDesc: UITextField?, textFrom: UITextField?, index: Int?, dictStatus: String?)->())?
    var didSelectToDate:((pTextField: UITextField?, textTitle: UITextField?, textDesc: UITextField?, textFrom: UITextField?, index: Int?, dictStatus: String?)->())?
    var didChangedValue:((dataSource: [String: AnyObject]?, index: Int?) -> ())?
    override var datasource: AnyObject? {
        didSet {
            if index == 0 {
                 buttonAdd.setBackgroundImage(UIImage(named: "ProjectFormPlusIcon"), forState: .Normal)
            } else {
                 buttonAdd.setBackgroundImage(UIImage(named: "ProjectFormMinusIcon"), forState: .Normal)
            }

//            if strDictStaus == "education" {
//                textTitle.text = datasource!["degree"] as? String
//                textDescription.text = datasource!["stream"] as? String
//                textFrom.text = datasource!["start_date"] as? String
//                textTo.text = datasource!["end_date"] as? String
//            } else if strDictStaus == "training" {
//                textTitle.text = datasource!["training_name"] as? String
//               // textDescription.text = datasource!["stream"] as? String
//                textFrom.text = datasource!["start_date"] as? String
//                textTo.text = datasource!["end_date"] as? String
//            } else {
//                textTitle.text = datasource!["organisation_name"] as? String
//               // textDescription.text = datasource!["stream"] as? String
//                textFrom.text = datasource!["start_date"] as? String
//                textTo.text = datasource!["end_date"] as? String
//            }
            
            
            textTitle.text = datasource!["Title"] as? String
            textDescription.text = datasource!["Description"] as? String
            textFrom.text = datasource!["From"] as? String
            textTo.text = datasource!["To"] as? String
        
        }
    }
}


extension InfluencerTableCell: UITextFieldDelegate {
    
    @IBAction func buttonAdd(sender: UIButton) {
        if addCell != nil {
            addCell(sender: sender, index: index!)
        }
    }
    
    
    @IBAction func actionFromDate(sender: UIButton) {
        if didSelectFromDate != nil {
           didSelectFromDate!(pTextField: textFrom, textTitle: textTitle, textDesc: textDescription, textFrom: textFrom, index: index, dictStatus: strDictStaus)
        }
    }
    
    @IBAction func actionToDate(sender: UIButton) {
        if didSelectToDate != nil {
            didSelectToDate!(pTextField: textTo, textTitle: textTitle, textDesc: textDescription, textFrom: textFrom, index: index, dictStatus: strDictStaus)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == textTitle {
            if textTitle.text != "" {
                textDescription.becomeFirstResponder()
            } else {
                textTitle.becomeFirstResponder()
            }
        } else if textField == textDescription {
            if textDescription.text != "" {
                textFrom.becomeFirstResponder()
            } else {
                textDescription.becomeFirstResponder()
            }
        } else if textField == textFrom {
            if textFrom.text != "" {
                textTo.becomeFirstResponder()
            } else {
                textFrom.becomeFirstResponder()
            }
        } else {
            if textTo.text != "" {
                textTo.resignFirstResponder()
            } else {
                textTo.becomeFirstResponder()
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        dict = ["Title": textTitle.text!, "Description": textDescription.text!, "From": textFrom.text!, "To": textTo.text!]
        
//        if strDictStaus == "education"{
//            dict = ["degree": textTitle.text!, "stream": textDescription.text!, "start_date": textFrom.text!, "end_date": textTo.text!]
//        }else if strDictStaus == "training"{
//              dict = ["training_name": textTitle.text!,  "start_date": textFrom.text!, "end_date": textTo.text!]
//        }
//        else{
//            dict = ["organisation_name": textTitle.text!, "start_date": textFrom.text!, "end_date": textTo.text!]
//  
//        }
       
        if didChangedValue != nil {
            didChangedValue!(dataSource: dict, index: index)
            
        }
    }
   
}

