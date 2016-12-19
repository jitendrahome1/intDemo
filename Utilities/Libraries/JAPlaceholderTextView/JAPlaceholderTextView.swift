//
//  JAPlaceholderTextView.swift
//  TextViewPlaceholder
//
//  Created by Jitendra on 9/2/16.
//  Copyright © 2016 Jitendra. All rights reserved.
//

import UIKit
@IBDesignable
class JAPlaceholderTextView: UITextView {

	// MARK: - Private Zone
	var placeholderLabel = UILabel()
	var labelHeight = CGFloat()
	var labelWidth: CGFloat = 250.0
	let fontSize: CGFloat = 20.0
	var xPadding = CGFloat()
	var yPadding = CGFloat()

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		self.createTextViewPlaceholder()
	}
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)

		self.createTextViewPlaceholder()
	}
	// MARK:- Used For set the Placeholder text
	@IBInspectable var placeholder: String = "" {
		didSet {
			if !self.hasText() {
				placeholderLabel.text = placeholder
			}
		}
	}
	// MARK:- placeholder Padding for X  axis
	@IBInspectable var paddingX: CGFloat = 0 {
		didSet {
			xPadding = paddingX
			placeholderLabel.frame.origin.x = xPadding
		}
	}
	// MARK: - placeholder Padding for Y  axis
	@IBInspectable var paddingY: CGFloat = 0 {
		didSet {
			yPadding = paddingX
			placeholderLabel.frame.origin.y = paddingY
		}
	}
	// MARK: - Set placeholder Color
	@IBInspectable var placeholderTextColor: UIColor? {
		didSet {
			placeholderLabel.textColor = placeholderTextColor
		}
	}
	override internal var font: UIFont! {
		didSet {
			if placeholderFont == nil {
				placeholderLabel.font = font
				let size = text.sizeWithAttributes([NSFontAttributeName: font])
				labelHeight = size.height
				placeholderLabel.frame.size.height = labelHeight
			}
		}
	}
	// MARK: - Set placeholder Font and size
	@IBInspectable var placeholderFont: UIFont? {
		didSet {
			placeholderLabel.font = placeholderFont
			placeholderLabel.font = placeholderLabel.font.fontWithSize(fontSize)
		}
	}
	// MARK: - Create a placeholder lable for text view
	func createTextViewPlaceholder()
	{
		placeholderLabel = UILabel(frame: CGRectMake(xPadding, yPadding, labelWidth, labelHeight))
		placeholderLabel.text = placeholder
		placeholderLabel.textColor = placeholderTextColor
		placeholderLabel.font = placeholderFont
		placeholderLabel.font = placeholderLabel.font.fontWithSize(fontSize)
		self.delegate = self
		addSubview(placeholderLabel)
	}

	override var text: String! {
		didSet {
			placeholderLabel.hidden = true
		}
	}
}

extension JAPlaceholderTextView: UITextViewDelegate
{
	// MARK:-UITextFieldDelegate method
	func textViewDidChange(textView: UITextView) {
		if !textView.hasText() {
			placeholderLabel.hidden = false
		}
		else {
			placeholderLabel.hidden = true
		}
	}

	// MARK:-UITextFieldDelegate method
	func textViewShouldBeginEditing(textView: UITextView) -> Bool {
		return true
	}

	func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		if range.location == 0 {
			if (text == " " || text == "\n") {
				return false
			}
		} else {
			return true
		}
		return true
	}
    
}
