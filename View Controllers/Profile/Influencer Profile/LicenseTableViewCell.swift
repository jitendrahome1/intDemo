//
//  LicenseTableViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 16/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class LicenseTableViewCell: BaseTableViewCell {

    @IBOutlet weak var collectionViewLicense: UICollectionView!
    var didSelectCollectionCell:(() -> ())?
    var isFirstTime: Bool?

    var dataSource: [AnyObject]? {
        didSet {
            debugPrint(self.dataSource)
            collectionViewLicense.reloadData()
        }
    }
    
    override var datasource: AnyObject? {
        didSet {
            debugPrint(isFirstTime)
            collectionViewLicense.reloadData()
        }
    }
}


extension LicenseTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.dataSource != nil {
            return self.dataSource!.count
        } else {
            return 1
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(CollectionCell), forIndexPath: indexPath) as! CollectionCell
        if self.dataSource != nil {
            cell.datasource = dataSource![indexPath.item]
        }
        cell.layer.cornerRadius = IS_IPAD() ? 15.0 : 10.0
        cell.layer.borderWidth = IS_IPAD() ? 2.0 : 3.0
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.masksToBounds =  true
      
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
       return CGSizeMake(CGRectGetHeight(collectionView.bounds), CGRectGetHeight(collectionView.bounds))
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 && String(dataSource![0]) == "AddPictureIcon" {
            if didSelectCollectionCell != nil {
                didSelectCollectionCell!()
            }
        }
    }

}