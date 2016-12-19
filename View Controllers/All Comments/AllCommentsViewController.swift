//
//  AllCommentsViewController.swift
//  Greenply
//
//  Created by Jitendra on 9/12/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class AllCommentsViewController: BaseViewController {
    
    @IBOutlet weak var buttonComments: UIButton!
    @IBOutlet weak var tblAllComments: UITableView!
    var isReportStatus: Bool?
    var ideaID: Int!
    
    var arrAllCommentsList = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblAllComments.layer.cornerRadius = 5.0
        self.tblAllComments.estimatedRowHeight = 90.0
        self.tblAllComments.rowHeight = UITableViewAutomaticDimension;
       // let pan = UIPanGestureRecognizer(target: self, action: #selector(buttonMove))
        //buttonComments.addGestureRecognizer(pan)
        tblAllComments.layer.masksToBounds = true
        tblAllComments.layer.borderColor = UIBorderColor().CGColor
        tblAllComments.layer.borderWidth = 0.8
    }
    
    override func viewWillAppear(animated: Bool) {
     super.viewWillAppear(animated)
        debugPrint(arrAllCommentsList)
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_All_Comments
        NavigationHelper.helper.tabBarViewController!.hideTabBar()
        if arrAllCommentsList.count > 0{
        self.tblAllComments.hidden = false
        self.tblAllComments.reloadData()
        }
        else{
            self.tblAllComments.hidden = true
            Toast.show(withMessage: NO_RECORDS_FOUND)
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Load All Comments..
   
    
   // MARK:- Table View Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         debugPrint(self.arrAllCommentsList.count)
        return arrAllCommentsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(String(AllCommentsCell)) as! AllCommentsCell
        cell.datasource = arrAllCommentsList[indexPath.row]
      
        cell.actionReportAbusHandler = {(CommentID,isAbusStatus ) in
            self.isReportStatus = isAbusStatus
            if self.isReportStatus == false{
                // call to api
            self.reportAbusWith(forReportID: CommentID, abuseType: kReportAbusComment, cell: cell)
            }
            debugPrint("Commet ID\(CommentID)")
        }
        
        
        return cell
        
    }
    
    @IBAction func actionButtonComments(sender: AnyObject) {
        debugPrint(ideaID)

        Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
            if isLogin == true{
                            CommentPopupController.showAddOrClearPopUp(self, didSubmit: { (text, popUp) in
                                debugPrint("Submit")
                                APIHandler.handler.writeComment(forUser: INTEGER_FOR_KEY(kUserID), ideaID: self.ideaID, comment: text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()), success: { (response) in
                                    self.tblAllComments.hidden = false
                                    debugPrint("UserDetails Response -> \(response)")
                                    let objComments = Comments(withDictionary: response["IdeaComment"].dictionaryObject!)
                                    self.arrAllCommentsList.insert(objComments, atIndex: 0)
                                    debugPrint(self.arrAllCommentsList.count)
                                    popUp?.dismissAnimate()
                                    self.tblAllComments.reloadData()

                
                                }) { (error) in
                                    debugPrint("Error \(error)")
                                }
                                
                            }) {
                                debugPrint("Finish")
                            }
   
            }
        }
        
    }
    
    func buttonMove(pan: UIPanGestureRecognizer) {
        
        let loc = pan.locationInView(self.view)
        self.buttonComments.center = loc
    }
}
extension AllCommentsViewController{
    // call report abus api
    
    // Working on Report abus.
    func reportAbusWith(forReportID typeID: Int?, abuseType: String?, cell: AllCommentsCell?) {
        APIHandler.handler.reportAbuseWithTypeID(forTypeID: typeID!, abuse_type: abuseType!, success: { (response) in
            print("Report Value==\(response)")
           cell?.buttonSpam.setImage(UIImage(named: kReportAbusRedImage), forState:.Normal)
            self.isReportStatus = true
            
        }) { (error) in
         Toast.show(withMessage: "You've already submitted a report for this item")
        }
    }
}

