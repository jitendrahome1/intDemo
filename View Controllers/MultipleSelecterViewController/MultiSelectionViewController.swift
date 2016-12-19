//
//  MultiSelectionViewController.swift
//  Greenply
//
//  Created by Jitendra on 9/15/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MultiSelectionViewController: BaseViewController {
    @IBOutlet weak var viewMainBG: UIView!
     
    @IBOutlet var selectionBarButtons: [UIButton]!
    @IBOutlet weak var viewContainerBG: UIView!
    var currenttemp = Int()
    @IBOutlet weak var collectionMultiple: UICollectionView!
    @IBOutlet weak var collectionHeader: UICollectionView!
    var arrDataList = [AnyObject]()
    var arrheaderList = [AnyObject]()
    var array = [AnyObject]()
    var visibleIndexPath: NSIndexPath!
    var pageIndex: NSInteger!
    var work_exp: String?
    var ratings: String?
    var typical_job_cost: String?
    var skills: String?
    var distance: String?
    
    
    override func viewDidLoad() {
      super.viewDidLoad()
        
        APIHandler.handler.userFilterAttribute({ (response) in
            debugPrint(response)

            for value in response["Attributes"].arrayValue {
                for data in value["attributeValues"].arrayObject! {
                    let objFilterAttribute = UserFilterAttribute(withDictionary: data as! [String : AnyObject])
                    self.array.append(objFilterAttribute)
                }
                self.arrDataList.append(self.array)
                self.array.removeAll()
            }
            
            
            if response["Attributes"].count > 0 {
                    for value in response["Attributes"].arrayObject! {
                    let objHeaderFilterAttribute = HeaderFilterAttribute(withDictionary: value as! [String : AnyObject])
                    self.arrheaderList.append(objHeaderFilterAttribute)
                }
            }
            self.collectionHeader.reloadData()
            self.collectionMultiple.reloadData()
        }) { (error) in
            debugPrint(error)
        }

        
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MultiSelectionViewController.tapDismissView))
        self.viewMainBG.addGestureRecognizer(tapGesture)
        //loadArray()
    }
    @IBAction func actionFilter(sender: UIButton) {
        self.userFilterAPI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MArk:- Action
    @IBAction func didTapButtonAction(sender: UIButton) {
       self.unSelectButton(sender)
       self.resetIndexPath(selectionBarButtons.indexOf(sender)!)
    }
    
    func unSelectButton(exceptionButton: UIButton)
    {
        for button in selectionBarButtons {
            if button != exceptionButton {
                button.selected = false
            }
            else{
                button.selected = true
            }
        }
    }
    
    func loadArray() {
        //arrDataList = [["Interior Decorators", "Architects", "Carpenters"],["0-2 yrs", "2-4 yrs", "5-7 yrs", "8-10 yrs"],["1 star", "2 star", "3 star", "4 star", "5 star"],["Kolkata", "Mumbai", "Delhi", "Chennai"]]
        //arrheaderList = ["Work Experience","Distance","Typical Job Cost","Ratings"]
    }
    
    // MARK: PopUp ViewController Function.
    internal class func showMultipleSelectionView(sourceViewController: UIViewController) {
        let viewController = otherStoryboard.instantiateViewControllerWithIdentifier(String(MultiSelectionViewController)) as! MultiSelectionViewController
        viewController.presentAddOrClearPopUpWith(sourceViewController)
    }
    func presentAddOrClearPopUpWith(sourceController: UIViewController) {
    UIApplication.sharedApplication().keyWindow?.addSubview(self.view)
    sourceController.addChildViewController(self)
    presentAnimationToView()
        
    }
    
    // MARK: - Animation
    func presentAnimationToView() {
        self.viewContainerBG.transform = CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT)
        self.viewMainBG.alpha = 0
        UIView.animateWithDuration(0.25, animations: {
            self.viewContainerBG.transform = CGAffineTransformMakeTranslation(0, 0)
            self.viewMainBG.alpha = 0.5
        }) { (true) in
        }
    }
    func dismissAnimate() {
        UIView.animateWithDuration(0.25, animations: {
            self.viewContainerBG.transform = CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT)
            self.viewMainBG.alpha = 0
        }) { (true) in
            self.view.removeFromSuperview();
            self.removeFromParentViewController()
        }
    }
    func tapDismissView()
    {
        self.dismissAnimate()
    }
    
}
extension MultiSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionMultiple {
            return arrDataList.count
        } else {
            return arrheaderList.count
        }
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        if collectionView == collectionMultiple {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(MultipleCollectionViewCell), forIndexPath: indexPath) as! MultipleCollectionViewCell
            cell.backgroundColor = UIColor.clearColor()
            cell.datasource = indexPath.item
            cell.dataSource = arrDataList[indexPath.item] as? [AnyObject]
            
            cell.dataFilter = { item, index, valueCode in
                if item == 0 {
                    self.work_exp = "UserSearch[work_experience][]=\(valueCode)"
                } else if item == 1 {
                    self.distance = "UserSearch[distance][]=\(valueCode)"
                } else if item == 2 {
                    self.typical_job_cost = "UserSearch[typical_job_cost][]=\(valueCode)"
                } else {
                    self.ratings = "UserSearch[ratings][]=\(valueCode)"
                }
            }
            
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(MultipleCollectionHeaderCell), forIndexPath: indexPath) as! MultipleCollectionHeaderCell
            cell.datasource = arrheaderList[indexPath.item] 
            return cell
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        currenttemp = Int(collectionMultiple.contentOffset.x / CGRectGetWidth(collectionMultiple.frame))
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView == collectionMultiple {
            return CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds) - 16, CGRectGetHeight(collectionView.frame))
        } else {
            return CGSizeMake(100, 40.0)
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == collectionHeader {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(MultipleCollectionHeaderCell), forIndexPath: indexPath) as! MultipleCollectionHeaderCell
            cell.imageBorder.backgroundColor = UIColor.greenColor()
            self.resetIndexPath(indexPath.item)
        }
    }
}


extension MultiSelectionViewController {
    func resetIndexPath(indexPath: Int) {
        debugPrint("Indexpath\(indexPath)")
        collectionMultiple.scrollToItemAtIndexPath(NSIndexPath(forItem: indexPath, inSection: 0), atScrollPosition: .Left, animated: true)
    }
}


extension MultiSelectionViewController {
    func userFilterAPI() {
        
//        if let _ = self.work_exp! {
//            
//        }
     //   let influencer_filter_data = "/users?UserSearch[user_type]=influencer&UserSearch[influencer_type]=architect&\(self.work_exp!)&\(self.ratings!)&\(self.typical_job_cost!)&\(self.skills!)"
        
        let influencer = "/users?UserSearch[user_type]=influencer&UserSearch[influencer_type]=architect&UserSearch[work-experience][]=less-2&UserSearch[work-experience][]=2-5&UserSearch[distance][]=1-5&UserSearch[distance][]=5-10&UserSearch[work-experience][]=6-10"
        
        APIHandler.handler.influencerFilter(forUser: "influencer", influencer_type: "architect", work_experience: self.work_exp, ratings: self.ratings, typical_job_cost: self.typical_job_cost, skills: self.skills, distance: "test", influencer_filter: influencer, success: { (response) in
            debugPrint(response)
            }) { (error) in
                debugPrint(error)
        }
    }
}



