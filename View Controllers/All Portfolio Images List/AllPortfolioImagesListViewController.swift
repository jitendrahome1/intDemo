//
//  AllPortfolioImagesListViewController.swift
//  Greenply
//
//  Created by Jitendra on 25/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class AllPortfolioImagesListViewController: BaseViewController {

    @IBOutlet weak var allCollectionImagsList: UICollectionView!
    var arrPortfolioImageList =  [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_Project_Details
        NavigationHelper.helper.tabBarViewController?.hideTabBar()
    }
}

extension AllPortfolioImagesListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = IS_IPAD() ? 20.0 : 10.0
        allCollectionImagsList.collectionViewLayout = layout
    }
    
    // MARK: UICollectionViewDataSource methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPortfolioImageList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(AllPortfolioImagesListCell), forIndexPath: indexPath) as! AllPortfolioImagesListCell
        cell.datasource = arrPortfolioImageList[indexPath.row]
        //cell.actionLikeHandler
        
        cell.layer.cornerRadius = IS_IPAD() ? 15.0 : 10.0
        cell.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
        cell.layer.borderColor = UIColor(red: 210.0 / 255.0, green: 210.0 / 255.0, blue: 210.0 / 255.0, alpha: 1.0).CGColor
        cell.layer.masksToBounds = true
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout methods
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((SCREEN_WIDTH / 2 - (IS_IPAD() ? 20.0 : 15.0)), (SCREEN_WIDTH / 2 - (IS_IPAD() ? 20.0 : 15.0)))
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let ProjectDetailsViewVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(ProjectDetailsViewController)) as! ProjectDetailsViewController
        ProjectDetailsViewVC.arrProjectDetailsImageList = arrPortfolioImageList
        ProjectDetailsViewVC.indexpath = indexPath
        NavigationHelper.helper.contentNavController!.pushViewController(ProjectDetailsViewVC, animated: true)
        
    }
}
