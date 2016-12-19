//
//  LocationSeacrhViewController.swift
//  Greenply
//
//  Created by Jitendra on 10/6/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//
@objc protocol SelectCityDeleagte{

    optional func didFinishCitySelected(selectCity: String?)
    
}
import UIKit
import MapKit
class LocationSeacrhViewController: BaseViewController {
    @IBOutlet weak var autocompleteTextfield: AutoCompleteTextField!
    
    private var responseData:NSMutableData?
    private var selectedPointAnnotation:MKPointAnnotation?
    private var dataTask:NSURLSessionDataTask?
    var delegateCity: SelectCityDeleagte?

    override func viewDidLoad() {
        super.viewDidLoad()
        autocompleteTextfield.becomeFirstResponder()
        self.backButtonEnabled = true
       self.setNavigationTitle(TITLE_SELECT_CITY)
        configureTextField()
        handleTextFieldInterfaces()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureTextField(){
        autocompleteTextfield.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        autocompleteTextfield.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)!
        autocompleteTextfield.autoCompleteCellHeight = 35.0
        autocompleteTextfield.maximumAutoCompleteCount = 20
        autocompleteTextfield.hidesWhenSelected = true
        autocompleteTextfield.hidesWhenEmpty = true
        autocompleteTextfield.enableAttributedText = true
        
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        autocompleteTextfield.autoCompleteAttributes = attributes
    }
    
    private func handleTextFieldInterfaces(){
        
        autocompleteTextfield.onTextChange = {[weak self] text in
            if !text.isEmpty{
                if let dataTask = self?.dataTask {
                    dataTask.cancel()
                }
                self?.fetchAutocompletePlaces(text)
            }
        }
        
        autocompleteTextfield.onSelect = {[weak self] text, indexpath in
         
            Location.geocodeAddressString(text, completion: { (placemark, error) -> Void in
                self?.view.endEditing(true)
                
                self!.delegateCity?.didFinishCitySelected!(text)
            	self!.navigationController?.popViewControllerAnimated(true)
//                let location: CLLocation = (placemark?.location)!
//                let coordinate: CLLocationCoordinate2D = location.coordinate
              
            })
        }
    }
    
    private func fetchAutocompletePlaces(keyword:String) {
      
        let urlString = "\(GOOGLE_BASE_URL_STRING)?key=\(GOOGLE_MAP_KEY)&input=\(keyword)"
          CDSpinner.show(onViewControllerView:self.view)
        let s = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
        s.addCharactersInString("+&")
        if let encodedString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(s) {
            if let url = NSURL(string: encodedString) {
                let request = NSURLRequest(URL: url)
                dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                    if let data = data{
                        
                        do{
                            let result = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                            
                            if let status = result["status"] as? String{
                                if status == "OK"{
                                    if let predictions = result["predictions"] as? NSArray{
                                        print("filter location ==\(predictions)")
                                        
                                        var locations = [String]()
                                        for dict in predictions as! [NSDictionary]{
                                            let city = (dict["description"] as! String).componentsSeparatedByString(",")
                                            if locations.contains(city[0]) {
                                                //............
                                            } else {
                                                 locations.append(city[0])
                                            }
                                        }
                                        
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                           CDSpinner.hide()
                                            self.autocompleteTextfield.autoCompleteStrings = locations
                                        })
                                        return
                                    }
                                }
                            }
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                 CDSpinner.hide()
                                self.autocompleteTextfield.autoCompleteStrings = nil
                            })
                        }
                        catch let error as NSError{
                             CDSpinner.hide()
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                })
                dataTask?.resume()
            }
        }
    }
}


