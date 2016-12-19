//
//  FieldTableViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 16/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class FieldTableViewCell: BaseTableViewCell {

    @IBOutlet weak var txtField: JATextField!
    var textValue: ((text: String,  index: NSIndexPath)->())?
    var index: NSIndexPath?
    var strTextValue: String?
    
    override var datasource: AnyObject? {
        didSet {
            debugPrint(datasource)
            txtField.placeholder = datasource!["placeholder"] as? String
            txtField.iconImageView.image = UIImage(named: (datasource!["image"] as? String)!)
            
            txtField.text = strTextValue
        }
    }
}


extension FieldTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(textField: UITextField){
        textValue!(text: txtField!.text!, index: index!)
    }
}



