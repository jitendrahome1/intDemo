//
//  TagViewController.swift
//  Greenply
//
//  Created by Shatadru Datta on 08/11/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class TagViewController: BaseViewController {

    @IBOutlet weak var tagViewDescription: KSTokenView!
    var list = [String]()
    var isSearch: Bool?
    var arrTagsResult = [AnyObject]()
    var arrAllTagsID = [AnyObject]()
    var arrSkils = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagViewDescription.style = .Squared
        tagViewDescription.delegate = self
        tagViewDescription.searchResultSize = self.view.frame.size
        getAllSkillsList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(sender: UIButton) {
        
    }
}


//MARK:- Api Call SkillList
extension TagViewController {
    func getAllSkillsList() {
        APIHandler.handler.getSkillList({ (response) in
            
            self.arrTagsResult = response["Skill"].arrayObject!
            if self.arrTagsResult.count > 0 {
                for value in response["Skill"].arrayObject! {
                    let objTags = SkillTags(withDictionary: value as! [String: AnyObject])
                    self.arrSkils.append(objTags)
                    self.list.append(objTags.skillName!)
                }
                debugPrint("AddIdeaTags ==>\(self.arrSkils)")
            }
        }) { (error) in
        }
    }
}



extension TagViewController: KSTokenViewDelegate {
    func tokenView(token: KSTokenView, performSearchWithString string: String, completion: ((results: Array<AnyObject>) -> Void)?) {
        var data: Array<String> = []
        for value: String in list {
            if value.lowercaseString.rangeOfString(string.lowercaseString) != nil {
                data.append(value)
            }
        }
        completion!(results: data)
    }
    
    func tokenView(token: KSTokenView, displayTitleForObject object: AnyObject) -> String {
        let idea = (object as! String).componentsSeparatedByString("+")
        return idea[0]
    }
    
    func tokenView(tokenView: KSTokenView, didAddToken token: KSToken) {
        if isSearch == true {
            self.getTagsID(self.arrTagsResult, keySearch: String(token))
        }
        isSearch = false
        debugPrint(token)
    }
    
    func tokenView(token: KSTokenView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.isSearch = true
        
    }
    
    func tokenView(tokenView: KSTokenView, didDeleteToken token: KSToken) {
        self.removeTagsID(self.arrTagsResult, keySearch: String(token))
        debugPrint(token)
    }
    
    //MARK:- Remove Tags
    func removeTagsID(pArry: [AnyObject], keySearch: String)
    { let name = NSPredicate(format: "skill_name contains[c] %@", keySearch)
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
        let filteredArray = pArry.filter { compoundPredicate.evaluateWithObject($0) }
        let dict = filteredArray.first
        
        if let dictFilter = dict {
            if let _ = dict!["id"] {
                let index = dictFilter["id"] as! Int
                self.arrAllTagsID.removeObject(index)
            }
        }
    }
    
    //MARK:- GetTagIDs
    func getTagsID(pArry: [AnyObject], keySearch: String)
    { let name = NSPredicate(format: "skill_name contains[c] %@", keySearch)
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
        let filteredArray = pArry.filter { compoundPredicate.evaluateWithObject($0) }
        let dict = filteredArray.first
        
        if let dictFilter = dict {
            if let _ = dict!["id"] {
                self.arrAllTagsID.append(dictFilter["id"] as! Int)
            }
        }
    }
}

