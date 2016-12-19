//
//  ImageViewController.swift
//  Greenply
//
//  Created by Jitendra on 10/6/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class ImageViewController: BaseViewController {
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var imageView: UIImageView!
	var objIdeaDetails: IdeaListing!
	override func viewDidLoad() {
		super.viewDidLoad()
		
        self.scrollView.minimumZoomScale = 1.0;
		self.scrollView.maximumZoomScale = 8.0;

        //imageView.contentMode = .ScaleAspectFit
		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: true)
		NavigationHelper.helper.headerViewController?.labelHeaderTitle.text = objIdeaDetails.ideaName!
		
		NavigationHelper.helper.enableSideMenuSwipe = false
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
	override func viewWillDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		NavigationHelper.helper.enableSideMenuSwipe = true
	}
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
        imageView.setImage(withURL: NSURL(string: objIdeaDetails.ideaImageOriginal!)!, placeHolderImageNamed: "PlaceholderRectangle", andImageTransition: .CrossDissolve(0.4))
    }
}



extension ImageViewController {
//MARK:- UIScrollViewDelegate Delegate

	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
	{
		return self.imageView
	}
}