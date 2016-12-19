//
//  GPExtentions.swift
//  Greenply
//
//  Created by Jitendra on 9/6/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import Foundation
import UIKit

extension String
{
	// MARK:- Trimming the whitespace from a string and check empty of string
	public var isBlank: Bool {
		get {
			let trimmed = stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
			return trimmed.isEmpty
		}
	}
    
    //To check String is not null/NULL/nil.
    static func isSafeString(strOpt: AnyObject?) -> Bool {
        var returnVar = true
        if let tempStr = strOpt as? String {
            if tempStr.lowercaseString == "null" || tempStr.lowercaseString == "<null>" {
                returnVar = false
            }
        }
        else {
            returnVar = false
        }
        return returnVar
    }

    

	// MARK:- Verify email address is correct format or not.
	var isValidEmail: Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
		let result = emailTest.evaluateWithObject(self)
		return result

	}
	// MARK:- Show Error Message
	func showErrorMessage(messge: String, textField: UITextField)
	{
		let animation = CABasicAnimation(keyPath: "position")
		animation.duration = 0.07
		animation.repeatCount = 4
		animation.autoreverses = true
		animation.fromValue = NSValue(CGPoint: CGPointMake(textField.center.x - 10, textField.center.y))
		animation.toValue = NSValue(CGPoint: CGPointMake(textField.center.x + 10, textField.center.y))
		textField.layer.addAnimation(animation, forKey: "position")
		let attributes = [
			NSForegroundColorAttributeName: UIColor.redColor(),
			NSFontAttributeName: UIFont(name: FONT_NAME, size: 12)! // Note the !
		]
		textField.attributedPlaceholder = NSAttributedString(string: messge, attributes: attributes)
		textField.text = ""
	}

	func requiredHeight(forWidth width: CGFloat, andFont font: UIFont) -> CGFloat {

		let label: UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
		label.numberOfLines = 0
		label.lineBreakMode = NSLineBreakMode.ByWordWrapping
		label.font = font
		label.text = self
		label.sizeToFit()
		return label.frame.height
	}

	func requiredWidth(forHeight height: CGFloat, andFont font: UIFont) -> CGFloat {

		let label: UILabel = UILabel(frame: CGRectMake(0, 0, CGFloat.max, height))
		label.numberOfLines = 0
		label.lineBreakMode = NSLineBreakMode.ByWordWrapping
		label.font = font
		label.text = self
		label.sizeToFit()
		return label.frame.width
	}

	// MARK: Label Justified
	func labelJustified(labelText: UILabel)
	{
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .Justified
		paragraphStyle.firstLineHeadIndent = 0.001

		let mutableAttrStr = NSMutableAttributedString(attributedString: labelText.attributedText!)
		mutableAttrStr.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, mutableAttrStr.length))
		labelText.attributedText = mutableAttrStr
	}
    
    //MARK: Random String
    static func randomString(length: Int) -> String {
        let charactersString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let charactersArray : [Character] = Array(charactersString.characters)
        
        var string = ""
        for _ in 0..<length {
            string.append(charactersArray[Int(arc4random()) % charactersArray.count])
        }
        return string
    }
   func toDouble() -> Double? {
            return NSNumberFormatter().numberFromString(self)?.doubleValue
        }
    

}

extension UILabel {

	public override func layoutSubviews() {
		super.layoutSubviews()
		if self.superview != nil {
			if self.superview!.isKindOfClass(UIButton) {
				if self.superview!.isKindOfClass(NSClassFromString("UINavigationButton")!) {
					self.font = UIFont(name: FONT_NAME, size: self.font.pointSize)
				}
             else {
					self.font = UIFont(name: FONT_NAME, size: self.font.pointSize)
				}
            }else if self.superview!.isKindOfClass(NSClassFromString("UIDatePickerContentView")!) {
              return
            }else {
				self.font = UIFont(name: FONT_NAME, size: self.font.pointSize)
			}
		}
	}
    
    func requiredHeight() -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, self.frame.width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        return label.frame.height
    }


}

//MARK: Array
extension Array where Element: Comparable {

	mutating func removeObject(object: Element) {
		if let index = self.indexOf(object) {
			self.removeAtIndex(index)
		}
	}

	mutating func removeObjects(objectArray: [Element])
	{
		for object in objectArray {
			self.removeObject(object)
		}
	}
}

extension Array {

	func containsObject(type: AnyClass) -> (isPresent: Bool, index: Int!) {
		for (index, item) in self.enumerate() {
			if (item as! AnyObject).isKindOfClass(type) {
				return (true, index)
			}
		}
		return (false, nil)
	}
}

extension UIButton {
	// MARK Button and image alignment Like tabbar,
	func alignImageAndTitleVertically(padding: CGFloat) {
		let imageSize = self.imageView!.frame.size
		let titleSize = self.titleLabel!.frame.size
		let totalHeight = imageSize.height + titleSize.height + padding

		self.imageEdgeInsets = UIEdgeInsets(
			top: -(totalHeight - imageSize.height),
			left: 0,
			bottom: 0,
			right: -titleSize.width
		)

		self.titleEdgeInsets = UIEdgeInsets(
			top: 0,
			left: -imageSize.width,
			bottom: -(totalHeight - titleSize.height),
			right: 0
		)
	}

}

//MARK:- CALayer

extension CALayer {

	var borderUIColor: UIColor {
		set {
			self.borderColor = newValue.CGColor
		}

		get {
			return UIColor(CGColor: self.borderColor!)
		}
	}
}

//MARK: UIAlertController

extension UIAlertController {

	public class func showStandardAlertWithOnlyOK(title: String, alertText: String, selected_: (index: Int) -> ()) -> UIAlertController {
		let alert = UIAlertController(title: title, message: alertText, preferredStyle: .Alert)
//        alert.view.tintColor = DEFAULT_COLOR
		let doneAction = UIAlertAction(title: OK, style: .Default) { (action) in
			selected_(index: 0)
		}
		alert.addAction(doneAction)
		return alert
	}

	public class func showStandardAlertWith(title: String, alertText: String, selected_: (index: Int) -> ()) -> UIAlertController {
		let alert = UIAlertController(title: title, message: alertText, preferredStyle: .Alert)
//        alert.view.tintColor = DEFAULT_COLOR
		let cancelAction = UIAlertAction(title: CANCEL, style: .Cancel) { (action) in
			selected_(index: 0)
		}
		alert.addAction(cancelAction)
		let doneAction = UIAlertAction(title: OK, style: .Default) { (action) in
			selected_(index: 1)
		}
		alert.addAction(doneAction)
		return alert
	}

	public class func showStandardAlertWith(title: String, alertText: String, positiveButtonText: String?, negativeButtonText: String?, selected_: (index: Int) -> ()) -> UIAlertController {
		let alert = UIAlertController(title: title, message: alertText, preferredStyle: .Alert)
		// alert.view.tintColor = DEFAULT_COLOR
		let cancelAction = UIAlertAction(title: negativeButtonText, style: .Cancel) { (action) in
			selected_(index: 0)
		}
		alert.addAction(cancelAction)
		let doneAction = UIAlertAction(title: positiveButtonText, style: .Default) { (action) in
			selected_(index: 1)
		}
		alert.addAction(doneAction)
		return alert
	}

	public class func showStandardActionSheetWith(title: String, messageText: String, arrayButtons: [String], selectedIndex: (index: Int) -> ()) -> UIAlertController {
		let actionSheet = UIAlertController(title: title, message: messageText, preferredStyle: .ActionSheet)
		let cancelAction = UIAlertAction(title: CANCEL, style: .Cancel) { (action) in

		}
		actionSheet.addAction(cancelAction)
		for (index, item) in arrayButtons.enumerate() {
			let buttonAction = UIAlertAction(title: item, style: .Default, handler: { (action) in
				selectedIndex(index: index)
			})
			actionSheet.addAction(buttonAction)
		}
		return actionSheet
	}

	public class func showStandardAlertWithTextField(title: String, alertText: String, selected_: (index: Int, email: String) -> ()) -> UIAlertController {
		let alert = UIAlertController(title: title, message: alertText, preferredStyle: .Alert)
		alert.addTextFieldWithConfigurationHandler { (textField) in
			textField.placeholder = "Enter email"
			textField.keyboardType = .EmailAddress
		}
//        alert.view.tintColor = DEFAULT_COLOR
		let cancelAction = UIAlertAction(title: CANCEL, style: .Default) { (action) in
			selected_(index: 0, email: "")
		}
		alert.addAction(cancelAction)
		let doneAction = UIAlertAction(title: OK, style: .Default) { (action) in
			selected_(index: 1, email: alert.textFields![0].text!)
		}
		alert.addAction(doneAction)
		return alert
	}
}

//MARK: -  NSDate
extension NSDate {

	func dateToStringWithCustomFormat(format: String) -> String {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = format
		dateFormatter.timeZone = NSTimeZone.localTimeZone()
		return dateFormatter.stringFromDate(self)
	}

	class func dateFromTimeInterval(timeInterval: Double) -> NSDate {
		// Convert to Date
		return NSDate(timeIntervalSince1970: timeInterval)
	}

	func getFormattedStringWithFormat() -> String? {
		return "\(getDay())\(getDateSuffixForDate()!) \(getThreeCharacterMonth()) '\(getTwoDigitYear())"
	}

	func getDateSuffixForDate() -> (String?) {
		let ones = getDay() % 10
		let tens = (getDay() / 10) % 10
		if (tens == 1) {
			return "th"
		} else if (ones == 1) {
			return "st"
		} else if (ones == 2) {
			return "nd"
		} else if (ones == 3) {
			return "rd"
		} else {
			return "th"
		}
	}

	func getDay() -> (Int) {
		let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
		let components = calendar?.components(.Day, fromDate: self)
		return components!.day
	}

	func getMonth() -> (String) {
		let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
		let components = calendar?.components(.Month, fromDate: self)
		let dateFormatter = NSDateFormatter()
		return dateFormatter.monthSymbols[(components?.month)! - 1]
	}

	func getThreeCharacterMonth() -> (String) {
		return getMonth().substringToIndex(getMonth().startIndex.advancedBy(3))
	}

	func getYear() -> (Int) {
		let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
		let components = calendar?.components(.Year, fromDate: self)
		return components!.year
	}

	func getTwoDigitYear() -> (Int) {
		return getYear() % 100
	}
    
   class func convertTimeStampToDate(timeInterval: Double)->String{
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd MMM, YYYY"
        let dateString = dayTimePeriodFormatter.stringFromDate(date)
        return dateString
    }
    
    class func getTimeStamp() -> String{
    return "\(NSDate().timeIntervalSince1970 * 1000)"
  
    }
    
}
extension Array {
    mutating func removeObject<U: Equatable>(object: U) {
        var index: Int?
        for (idx, objectToCompare) in enumerate() {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        
        if(index != nil) {
            self.removeAtIndex(index!)
        }
    }
}


