//
//  AddPortfolioImageCell.swift
//  Greenply
//
//  Created by Chinmay Das on 22/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class AddPortfolioImageCell: BaseTableViewCell {

    @IBOutlet weak var collectionimage: UICollectionView!
    var isEditImagShowHide: Bool = false
    var textValue: String? = ""
    var arrGetImageId: [AnyObject]?
      var didGetImageID:((imageValue:Int?) -> ())?
    var didCrossImageID:((imageValue:Int?) -> ())?
    var didSelectCollectionCell:(() -> ())?
    
  
    var dataSource: AnyObject?{
        didSet{
           
            collectionimage.reloadData()
        }
    }

}

extension AddPortfolioImageCell: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataSource != nil {
            return (dataSource?.count)!
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell: BaseCollectionViewCell?
        
        cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(AddPortfolioCollectionViewCell), forIndexPath: indexPath) as! AddPortfolioCollectionViewCell
        (cell as! AddPortfolioCollectionViewCell).indexValue = indexPath.row
        
        if isEditImagShowHide == true{
            (cell as! AddPortfolioCollectionViewCell).indexImageID = arrGetImageId
            if indexPath.row >= 1{
                (cell as! AddPortfolioCollectionViewCell).buttonEditImag.hidden = false
                (cell as! AddPortfolioCollectionViewCell).buttonCrossImage.hidden = false
            }
            else{
                  (cell as! AddPortfolioCollectionViewCell).buttonEditImag.hidden  = true
              (cell as! AddPortfolioCollectionViewCell).buttonCrossImage.hidden  = true
            }
            
//            (cell as! AddPortfolioCollectionViewCell).buttonEditImag.hidden = false
//               (cell as! AddPortfolioCollectionViewCell).buttonCrossImage.hidden = false
        }else{
          (cell as! AddPortfolioCollectionViewCell).buttonEditImag.hidden  = true
               (cell as! AddPortfolioCollectionViewCell).buttonCrossImage.hidden  = true
        }
        
        // Edit image Button handler
        (cell as! AddPortfolioCollectionViewCell).didTapEditImage = { (imageID) in
            self.didGetImageID!(imageValue: imageID)
            }
        // Cross Image
        
        (cell as! AddPortfolioCollectionViewCell).didTapCrossImage = { (imageID) in
            self.didCrossImageID!(imageValue: imageID)
        }
        cell?.datasource = dataSource![indexPath.item]
        cell?.backgroundColor = .clearColor()
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(CGRectGetHeight(collectionView.bounds), CGRectGetHeight(collectionView.bounds))
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            if didSelectCollectionCell != nil {
                didSelectCollectionCell!()
            }

        }
    }
}