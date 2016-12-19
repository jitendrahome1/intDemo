//
//  ViewController.swift
//  DemoSave
//
//  Created by Jitendra on 12/16/16.
//  Copyright © 2016 Jitendra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.data_request()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func data_request()
    {
        let url:NSURL = NSURL(string: "http://10.0.8.97:8888/API/save.php")!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let paramString = "name=jitendra,password=123456,email=rahul@gmail.com"
//        let params:[String: AnyObject] = [
//            "name" : "jitu9999",
//            "password" : "usr",
//            "email" : "abc@gmail.com" ]
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(dataString)
            
        }
        
        task.resume()
        
    }

}

