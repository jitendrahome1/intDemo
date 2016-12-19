//
//  FollowersTableViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 31/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class FollowersTableViewCell: BaseTableViewCell {

	let ImageLimt: Int = 4
	@IBOutlet weak var labelIdea: UILabel!
	@IBOutlet weak var labelDesignerType: UILabel!
	@IBOutlet weak var viewFollowers: UIView!
	@IBOutlet weak var imageFollowers: UIImageView!
	@IBOutlet weak var labelName: UILabel!
	@IBOutlet weak var buttonUnfollow: UIButton!
	@IBOutlet weak var buttonLikes: UIButton!
    var arrFollwingIdeaList = [AnyObject]()
	var totalRowCount: Int?
	var restImageCount: Int?
	@IBOutlet weak var collectionViewFollowers: UICollectionView!
	var arrIdeasImage = [AnyObject]()
	var actionUnfollowHandler: ((followerID: Int) -> ())?

	override var datasource: AnyObject? {
		didSet {
			if let name = datasource!["User"]!!["name"] as? String {
				labelName.text = name
			}
            arrFollwingIdeaList.removeAll()
			self.arrIdeasImage.removeAll()
        
            if let arrIdea = datasource!["Idea"] as? [AnyObject] {
            
                for value in arrIdea {
                    let idesListObj = IdeaListing(withDictionary: value as! [String : AnyObject])
                   self.arrFollwingIdeaList.append(idesListObj)
                }
                
                for dictImageList in arrIdea {
					let dict: [String: AnyObject] = dictImageList as! [String: AnyObject]
					self.arrIdeasImage.append(dict)
				}
				if self.arrIdeasImage.count > ImageLimt {
                   
					self.restImageCount = self.arrIdeasImage.count - ImageLimt
				
				}
                self.collectionViewFollowers.reloadData()
			}

			if let ImageProfile = datasource!["User"]!!["images"]!!["cover_profile"] as? String {
				self.imageFollowers.setImage(withURL: NSURL(string: ImageProfile)!, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .CrossDissolve(0.4))

			}
			buttonLikes.setTitle("\(datasource!["User"]!!["like_count"]! as! Int)", forState: .Normal)

		}
	}

	@IBAction func actionLike(sender: UIButton) {
	}
	@IBAction func actionUnfollow(sender: UIButton) {
		if actionUnfollowHandler != nil {
			actionUnfollowHandler!(followerID: Int((datasource!["User"]!!["id"] as? Int)!))
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		viewFollowers.layer.cornerRadius = IS_IPAD() ? 10 : 5
		viewFollowers.layer.borderWidth = IS_IPAD() ? 2 : 1
		viewFollowers.layer.borderColor = UIColor(red: 198.0 / 255.0, green: 220.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0).CGColor
		viewFollowers.layer.masksToBounds = true

		buttonUnfollow.layer.borderWidth = IS_IPAD() ? 2 : 1
		buttonUnfollow.layer.cornerRadius = IS_IPAD() ? 20.0 : 15.0
		buttonUnfollow.layer.borderColor = UIColor(red: 198.0 / 255.0, green: 220.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0).CGColor
		buttonUnfollow.layer.masksToBounds = true

		imageFollowers.layoutIfNeeded()
		imageFollowers.layer.cornerRadius = imageFollowers.frame.size.width / 2
		imageFollowers.layer.masksToBounds = true

		buttonLikes.setTitleColor(UIColor.blackColor(), forState: .Normal)
		buttonLikes.imageEdgeInsets = UIEdgeInsetsMake(4, IS_IPAD() ? 18 : 9, 36, 0)
		buttonLikes.titleEdgeInsets = UIEdgeInsetsMake(IS_IPAD() ? 30 : 22, IS_IPAD() ? -29 : -19, IS_IPAD() ? -2 : 1, IS_IPAD() ? 16 : 14)
	}
}

extension FollowersTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if self.arrIdeasImage.count >= ImageLimt {
			self.totalRowCount = ImageLimt
		}
		else {
			self.totalRowCount = self.arrIdeasImage.count
		}
		return self.totalRowCount!
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(FollowersCollectionViewCell), forIndexPath: indexPath) as! FollowersCollectionViewCell
	
        cell.datasource = self.arrIdeasImage[indexPath.row]
        if self.totalRowCount! - 1 == indexPath.row {
			cell.viewCoverTotalImage.hidden = false
            if let imgCount = restImageCount{
               cell.labelTotalRestImage.text = "+" + String(imgCount)
            }else{
                cell.labelTotalRestImage.text = String("")
            }
           
		
        }
        else{
            cell.viewCoverTotalImage.hidden = true
        }

		return cell
	}
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
      
        let ideaListVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(IdeaListingController)) as! IdeaListingController
       ideaListVC.arrIdeasList = self.arrFollwingIdeaList
        ideaListVC.eIdeaListApiCallStatus = .eNotCallIdeaListApi
        NavigationHelper.helper.contentNavController?.pushViewController(ideaListVC, animated: true)
        
        
        
        
    }

	// MARK: UICollectionViewDelegateFlowLayout methods
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSizeMake(IS_IPAD() ? 85 : 55, IS_IPAD() ? 85 : 55)
	}
}

