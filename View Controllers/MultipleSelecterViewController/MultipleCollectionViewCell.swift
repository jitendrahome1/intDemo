//
//  MultipleSelectionCell.swift
//  Greenply
//
//  Created by Jitendra on 9/15/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MultipleCollectionViewCell: BaseCollectionViewCell {

	@IBOutlet weak var tblMultpleSelection: UITableView!
    var arrayName = [String]()
    var arrayValueCode = [String]()
    var dataFilter: ((item: Int, index: NSIndexPath, valuecode: String)->())?

    var dataSource: [AnyObject]? {
		didSet {
            debugPrint(dataSource)
            arrayName.removeAll()
            arrayValueCode.removeAll()
            for value in dataSource! {
                let objFilter = value as! UserFilterAttribute
                arrayName.append(objFilter.name!)
                arrayValueCode.append(objFilter.value_Code!)
                
            }
			tblMultpleSelection.tableFooterView = UIView()
			tblMultpleSelection.reloadData()
		}
	}
    
    override var datasource: AnyObject? {
        didSet {
            
        }
    }
}


extension MultipleCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource != nil {
            return dataSource!.count
        } else {
            return 0
        }
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: BaseTableViewCell?
		cell = tableView.dequeueReusableCellWithIdentifier(String(MultipleSelectionTableCell)) as! MultipleSelectionTableCell
       // (cell as? MultipleSelectionTableCell)?.item =
		(cell as? MultipleSelectionTableCell)?.labelTitleName.text = arrayName[indexPath.row]
		return cell!

	}

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
	{
		return IS_IPAD() ? 55 : 50

	}
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var currentCell: BaseTableViewCell?
        currentCell = tableView.cellForRowAtIndexPath(indexPath)! as! MultipleSelectionTableCell
        (currentCell as? MultipleSelectionTableCell)?.datasource = true
        self.dataFilter!(item: datasource as! Int, index: indexPath, valuecode: arrayValueCode[indexPath.row])
        
	}

	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		cell.backgroundColor = .clearColor()
	}
}
