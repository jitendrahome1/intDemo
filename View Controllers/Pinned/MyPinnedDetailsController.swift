//
//  MyPinnedDetailsController.swift
//  Greenply
//
//  Created by Shatadru Datta on 02/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MyPinnedDetailsController: BaseViewController {
    
    @IBOutlet weak var pinnedDetailsSearchBar: UISearchBar!
    @IBOutlet weak var collectionViewpinnedDetails: UICollectionView!
     var arrMyPinnedList = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(animated: Bool) {
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: false, isHideMenuButton: false)
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_MY_PINNED
        
        NavigationHelper.helper.tabBarViewController?.hideTabBar()
        
        super.viewWillAppear(animated)
        self.getPinnedDetails()
    }
   
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        collectionViewpinnedDetails.layoutIfNeeded()
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MyPinnedDetailsController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = IS_IPAD() ? 25.0 : 10.0
        collectionViewpinnedDetails.collectionViewLayout = layout
    }
    
    // MARK: UICollectionViewDataSource methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMyPinnedList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(MyPinnedDetailsCollectionViewCell), forIndexPath: indexPath) as! MyPinnedDetailsCollectionViewCell
        cell.datasource = arrMyPinnedList[indexPath.row]
        cell.layer.cornerRadius = IS_IPAD() ? 15.0 : 10.0
        cell.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
        cell.layer.borderColor = UIColorRGB(210.0, g: 210.0, b: 210.0)?.CGColor
        cell.layer.masksToBounds =  true

        
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MyPinnedDetailsCollectionViewCell
        let IdeaDetailsVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(IdeasDetailsController)) as! IdeasDetailsController
        let objIdeaList = cell.datasource
       IdeaDetailsVC.ideaDetailsObj = objIdeaList as! IdeaListing
         IdeaDetailsVC.eIdeaTitleStatus = .ePinnedDetailsTitle
        NavigationHelper.helper.contentNavController!.pushViewController(IdeaDetailsVC, animated: true)
    
    
    }

    
    // MARK: UICollectionViewDelegateFlowLayout methods
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((SCREEN_WIDTH / 2 - (IS_IPAD() ? 20.0 : 15.0)), (SCREEN_WIDTH / 2 - (IS_IPAD() ? 20.0 : 15.0)))
    }
}

// MARK: // API Calling
extension MyPinnedDetailsController {
    func getPinnedDetails(){
      arrMyPinnedList.removeAll()
        APIHandler.handler.getMyPinnedDetailsList({ (response) in
            debugPrint("My Pinned Details ==> \(response)")
            
            if response["Idea"].count > 0{
                for value in response["Idea"].arrayObject! {
                     self.collectionViewpinnedDetails.hidden = false
                   // let objPinned = Pinned(withDictionary: value as! [String : AnyObject])
                    
                     let idesListObj = IdeaListing(withDictionary: value as! [String : AnyObject])
                    //self.arrMyPinnedList.append(objPinned)
                     self.arrMyPinnedList.append(idesListObj)
                }
                self.collectionViewpinnedDetails.reloadData()
            }
            else{
             // Show Toast No Data available
                Toast.show(withMessage: NO_RECORDS_FOUND)
            self.collectionViewpinnedDetails.hidden = true
            }
            
            
        }) { (error) in
            
        }
     
    
    }
 
}


