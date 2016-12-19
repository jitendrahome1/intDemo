//
//  InfluencerProfileDetailsController.swift
//  Greenply
//
//  Created by Shatadru Datta on 19/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//


import UIKit
enum identifySection {
    case eExperience
    case eTraining
    case eEducation
}
class InfluencerProfileDetailsController: BaseTableViewController {

    @IBOutlet weak var buttonSave: UIButton!
    var influencerDetailsArray: Array<AnyObject>?
    var influencerDetailsArray2: Array<AnyObject>?
    var identifykeyStatus:identifySection!
    var didSaveInfluencerDetails:((array: [AnyObject], datasource: [String: AnyObject]?) -> ())?
    var didChangedFinalValue:((dataSource: [String: AnyObject]?,dataSource2: [String: AnyObject]?, index: Int?) -> ())?
    var dict: [String: AnyObject]?
    var dict2: [String: AnyObject]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if self.identifykeyStatus == .eExperience {
//            identifykeyStatus = .eExperience
//        } else if self.identifykeyStatus == .eTraining {
//            identifykeyStatus = .eTraining
//        } else {
//            identifykeyStatus = .eEducation
//        }
        
        tableView.backgroundView = nil
        buttonSave.layer.cornerRadius = IS_IPAD() ? 10.0 : 8.0
        buttonSave.layer.masksToBounds =  true
        if influencerDetailsArray?.count == 0 {
            influencerDetailsArray =  Helper.sharedClient.readPlist(forName: "InfluencerDetails").map({$0})
            influencerDetailsArray2 =  Helper.sharedClient.readPlist(forName: "InfluencerDetails").map({$0})
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonSave(sender: UIButton) {
        
        self.view.endEditing(true)
        if didSaveInfluencerDetails != nil {
            didSaveInfluencerDetails!(array: self.influencerDetailsArray!, datasource: self.dict2)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
}


extension InfluencerProfileDetailsController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = influencerDetailsArray {
            return array.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(InfluencerTableCell), forIndexPath: indexPath) as! InfluencerTableCell
        cell.index = indexPath.row
        cell.datasource = influencerDetailsArray![indexPath.row]
        var dict = [String: String]()
//        if self.identifykeyStatus == .eEducation{
//            dict = ["degree": "", "stream": "", "start_date": "", "end_date": ""]
//            cell.strDictStaus = "education"
//        }
//        else if self.identifykeyStatus == .eTraining{
//            dict = ["training_name": "", "start_date": "", "end_date": ""]
//            cell.strDictStaus = "training"
//        }
//        else if self.identifykeyStatus == .eExperience{
//            dict = ["organisation_name": "", "start_date": "", "end_date": ""]
//             cell.strDictStaus = "experience"
//        }
        
        dict = ["Title": "", "Description": "", "From": "", "To": ""]
        
        cell.addCell = {(button, index) in
            if index == 0 {
                //let dict = ["Title": "", "Description": "", "From": "", "To": ""]
               
                self.influencerDetailsArray?.append(dict)
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: (self.influencerDetailsArray?.count)! - 1, inSection: indexPath.section)], withRowAnimation: .Top)
            } else {
                let point = button.convertPoint(CGPointZero, toView: tableView)
                let indexPathTemp = tableView.indexPathForRowAtPoint(point)
                self.influencerDetailsArray?.removeAtIndex(indexPathTemp!.row)
                tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: (indexPathTemp?.row)!, inSection: 0)], withRowAnimation: .Top)
                let seconds = 0.3
                let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                    // here code perfomed with delay
                    tableView.reloadData()
                })
                debugPrint(index)
            }
        }
        cell.didChangedValue = {(datasource, index) in
            debugPrint(datasource)
            debugPrint(index)
            self.influencerDetailsArray?[index!] = datasource!
            debugPrint(self.influencerDetailsArray)
        }
        
        self.didChangedFinalValue = {(datasource, datasource2, index) in
            debugPrint(datasource)
            debugPrint(index)
            self.influencerDetailsArray?[index!] = datasource!
            debugPrint(self.influencerDetailsArray)
        }
        
        cell.didSelectFromDate = {(pTextField, textTitle, textDesc, textFrom, index, dictStatus) in
            self.view.endEditing(true)
            
            GPPickerViewController.showPickerController(self, isDatePicker: true, pickerArray: [], position: .Bottom, pickerTitle: "", preSelected: "") { (value, index) in
                
                if let strDateValue = value {
                     pTextField!.text! = (strDateValue as? String)!
                    self.dict = ["Title": textTitle!.text!, "Description": textDesc!.text!, "From": textFrom!.text!, "To": pTextField!.text!]
//                    if dictStatus == "education"{
//                        self.dict2 = ["degree": textTitle!.text!, "stream": textDesc!.text!, "start_date": textFrom!.text!, "end_date": pTextField!.text!]
//                    }else if dictStatus == "training"{
//                        self.dict2 = ["training_name": textTitle!.text!,  "start_date": textFrom!.text!, "end_date": pTextField!.text!]
//                    }
//                    else{
//                        self.dict2 = ["organisation_name": textTitle!.text!, "start_date": textFrom!.text!, "end_date": pTextField!.text!]
//                    }
                    self.didChangedFinalValue!(dataSource: self.dict ,dataSource2: self.dict2, index: index)
                }
            }
        }
        
        cell.didSelectToDate =  {(pTextField, textTitle, textDesc, textFrom, index, dictStatus) in
            self.view.endEditing(true)
            
            GPPickerViewController.showPickerController(self, isDatePicker: true, pickerArray: [], position: .Bottom, pickerTitle: "", preSelected: "") { (value, indexx) in
                
                if let strDateValue = value {
                    pTextField!.text! = (strDateValue as? String)!
                    self.dict = ["Title": textTitle!.text!, "Description": textDesc!.text!, "From": textFrom!.text!, "To": pTextField!.text!]
//                    if dictStatus == "education"{
//                    self.dict2 = ["degree": textTitle!.text!, "stream": textDesc!.text!, "start_date": textFrom!.text!, "end_date": pTextField!.text!]
//                    }else if dictStatus == "training"{
//                      self.dict2 = ["training_name": textTitle!.text!,  "start_date": textFrom!.text!, "end_date": pTextField!.text!]
//                    }
//                    else{
//                    self.dict2 = ["organisation_name": textTitle!.text!, "start_date": textFrom!.text!, "end_date": pTextField!.text!]
//                    }
                    self.didChangedFinalValue!(dataSource: self.dict,dataSource2: self.dict2, index: index)
                }
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return IS_IPAD() ? 210.0 : 155.0
    }
}