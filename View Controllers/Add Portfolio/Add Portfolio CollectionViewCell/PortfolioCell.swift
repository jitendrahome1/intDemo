//
//  PortfolioCell.swift
//  Greenply
//
//  Created by Chinmay Das on 22/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class PortfolioCell: BaseTableViewCell {

    @IBOutlet weak var textFieldIdeaName: JATextField!
    @IBOutlet weak var buttonCheck: UIButton!
    @IBOutlet weak var textViewDescription: JAPlaceholderTextView!
    @IBOutlet weak var tagViewDescription: KSTokenView!
    
    var indexPath = NSIndexPath()
    var arrayAttributes = [String]()
    //*************//
    var arrayProjType = [String]()
    var arrayStyleType = [String]()
    var arrayWorkType = [String]()
    var arrayProjBudget = [String]()
    //*************//
    
    var arrTagsData = [AnyObject]()
    var arrAllTagsID = [AnyObject]()
    var didTapSave:((sender: UIButton) -> ())?
    var didTapCheckBox:((sender: UIButton, checkedID:String?) -> ())?
    var didChangeText:((dataSource:AnyObject, indexPath: NSIndexPath) -> ())?
    var section: Int?

    override var datasource: AnyObject? {
        didSet {
            if buttonCheck != nil {
                buttonCheck.setTitle(datasource!["name"] as? String, forState: .Normal)
//                if self.arrayAttributes.filter({ (id) -> Bool in return id == (datasource!["id"] as? String) ? true : false}).count > 0 {
//                    buttonCheck.selected = true
//                } else {
//                    buttonCheck.selected = false
//                }
            }
            if textFieldIdeaName != nil {
                textFieldIdeaName.text = datasource as? String
            }
            if textViewDescription != nil {
                textViewDescription.text = datasource as? String
            }
            if tagViewDescription != nil {
               // tagViewDescription.delegate = self
                tagViewDescription.style = .Squared
            }
        }
    }
  

    @IBAction func buttonCheckDidTap(sender: UIButton) {
        if (didTapCheckBox != nil) {
           didTapCheckBox!(sender: sender, checkedID:datasource!["id"] as? String)
        }
    }
    
   @IBAction func buttonSaveDidTap(sender: UIButton) {
    self.contentView.endEditing(true)
        if (didTapSave != nil) {
           didTapSave!(sender: sender)
        }
    }
}

extension PortfolioCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        datasource = textField.text
        if didChangeText != nil {
            didChangeText!(dataSource: datasource!, indexPath: indexPath)
        }
    }
}

extension PortfolioCell: UITextViewDelegate {
    
    func textViewDidEndEditing(textView: UITextView) {
        datasource = textView.text
        if didChangeText != nil {
            didChangeText!(dataSource: datasource!, indexPath: indexPath)
        }
    }
}




