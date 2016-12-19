//
//  UploadIdeasImageCell.swift
//  Greenply
//
//  Created by Chinmay Das on 22/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class UploadIdeasImageCell: BaseTableViewCell {

    @IBOutlet weak var collectionimage: UICollectionView!
    
    var strDatasourceType: String = ""
    var didSelectCollectionCell:(() -> ())?
    
    var dataSource: AnyObject?{
        didSet{
           
            collectionimage.reloadData()
        }
    }
}

extension UploadIdeasImageCell: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataSource != nil {
            return (dataSource?.count)!
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell: BaseCollectionViewCell?
        
        cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(UploadIdeasImageCollectionCell), forIndexPath: indexPath) as! UploadIdeasImageCollectionCell
        cell?.datasource = dataSource![indexPath.item]
        cell?.backgroundColor = .clearColor()
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(CGRectGetHeight(collectionView.bounds), CGRectGetHeight(collectionView.bounds))
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       if didSelectCollectionCell != nil {
            didSelectCollectionCell!()
        }
    }
}
