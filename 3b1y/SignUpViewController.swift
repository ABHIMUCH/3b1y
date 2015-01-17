//
//  SignUpViewController.swift
//  3b1y
//
//  Created by Manav Gabhawala on 1/17/15.
//  Copyright (c) 2015 Manav Gabhawala. All rights reserved.
//

import UIKit

enum TextFieldType : Int
{
	case FirstName = 0
	case LastName, Email, PhoneNumber, Password, ConfirmPassword
}

class SignUpViewController: UIViewController
{
	var textFields = [UITextField]()
	let scrollView = UIScrollView()
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "signupButton:")
		navigationItem.rightBarButtonItem = doneButton
		navigationItem.title = "Sign Up"
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShown:", name: "UIKeyboardWillShowNotification", object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHidden:", name: "UIKeyboardWillHideNotification", object: nil)
		
		createForm()
	}
	/**
	A helper function that creates the UI for the sign up form
	*/
	func createForm()
	{
		scrollView.frame = CGRect(origin: CGPointZero, size: view.bounds.size)
		scrollView.keyboardDismissMode = .OnDrag
		
		let contentView = UIView(frame: CGRect(origin: CGPointZero, size: view.bounds.size))
		scrollView.contentSize = contentView.frame.size
		scrollView.bouncesZoom = false
		
		let attributes : [NSObject: AnyObject] = [NSForegroundColorAttributeName: UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.6)]
		let width = view.bounds.width * 0.75
		let centerX = view.bounds.width / 2
		navigationController?.toolbar.hidden = true
		let totalHeight = view.bounds.height - navigationController!.navigationBar.frame.height
		let numberOfFields = 6
		for i in 1...numberOfFields
		{
			let textField = UITextField()
			textField.textAlignment = .Center
			textField.textColor = UIColor.whiteColor()
			textField.autocapitalizationType = UITextAutocapitalizationType.None
			textField.autocorrectionType = UITextAutocorrectionType.No
			textField.borderStyle = UITextBorderStyle.None
			textField.layer.cornerRadius = 8.0
			textField.layer.masksToBounds = true
			textField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.4).CGColor
			textField.layer.borderWidth = 1.0
			textField.backgroundColor = UIColor.clearColor()
			textField.keyboardAppearance = UIKeyboardAppearance.Dark
			textField.keyboardType = UIKeyboardType.ASCIICapable
			textField.clearButtonMode = UITextFieldViewMode.WhileEditing
			textField.returnKeyType = UIReturnKeyType.Next
			textField.frame.size = CGSizeMake(width, 30)
			textField.center.x = centerX
			textField.center.y = CGFloat(i) * (totalHeight / CGFloat(numberOfFields))
			textField.font = UIFont(name: "HelveticaNeue-Light", size: 20)
			textField.delegate = self
			textFields.append(textField)
			contentView.addSubview(textField)
		}
		
		textFields[TextFieldType.FirstName.rawValue].attributedPlaceholder = NSAttributedString(string: "First Name", attributes: attributes)
		textFields[TextFieldType.FirstName.rawValue].autocapitalizationType = UITextAutocapitalizationType.Words
		
		textFields[TextFieldType.LastName.rawValue].attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: attributes)
		textFields[TextFieldType.LastName.rawValue].autocapitalizationType = UITextAutocapitalizationType.Words
		
		textFields[TextFieldType.Email.rawValue].attributedPlaceholder = NSAttributedString(string: "UM Uniqname", attributes: attributes)
		textFields[TextFieldType.Email.rawValue].keyboardType = UIKeyboardType.EmailAddress
		
		textFields[TextFieldType.PhoneNumber.rawValue].attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: attributes)
		textFields[TextFieldType.PhoneNumber.rawValue].keyboardType = UIKeyboardType.PhonePad
		textFields[TextFieldType.PhoneNumber.rawValue].autocapitalizationType = UITextAutocapitalizationType.None
		textFields[TextFieldType.PhoneNumber.rawValue].keyboardAppearance = UIKeyboardAppearance.Dark
		textFields[TextFieldType.PhoneNumber.rawValue].returnKeyType = UIReturnKeyType.Default
		textFields[TextFieldType.PhoneNumber.rawValue].addTarget(self, action: "phoneNumberMask:", forControlEvents: UIControlEvents.EditingChanged)
		
		textFields[TextFieldType.Password.rawValue].attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributes)
		textFields[TextFieldType.Password.rawValue].secureTextEntry = true
		
		textFields[TextFieldType.ConfirmPassword.rawValue].attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: attributes)
		textFields[TextFieldType.ConfirmPassword.rawValue].returnKeyType = UIReturnKeyType.Go
		textFields[TextFieldType.ConfirmPassword.rawValue].secureTextEntry = true
		
		scrollView.addSubview(contentView)
		view.addSubview(scrollView)
	}
	
	/**
	A function that is called when the user wishes to signup. It manages shaking the views which have invalid data and performing segues after the signup is successful.
	*/
	func signup()
	{
		var shouldReturn = false
		for textField in textFields
		{
			textField.resignFirstResponder()
			if (textField.text.isEmpty)
			{
				textField.shakeForInvalidInput()
				shouldReturn = true
			}
		}
		if (shouldReturn)
		{
			return
		}
		if (Array(textFields[TextFieldType.PhoneNumber.rawValue].text).count < 10)
		{
			textFields[TextFieldType.PhoneNumber.rawValue].shakeForInvalidInput()
			shouldReturn = true
		}
		if (Array(textFields[TextFieldType.Password.rawValue].text).count < 6)
		{
			textFields[TextFieldType.Password.rawValue].shakeForInvalidInput()
			shouldReturn = true
		}
		if (textFields[TextFieldType.Password.rawValue].text != textFields[TextFieldType.ConfirmPassword.rawValue].text)
		{
			textFields[TextFieldType.ConfirmPassword.rawValue].shakeForInvalidInput()
			shouldReturn = true
		}
		if (shouldReturn)
		{
			textFields[TextFieldType.Password.rawValue].text = ""
			textFields[TextFieldType.ConfirmPassword.rawValue].text = ""
			return
		}
		var user = PFUser()
		user.username = textFields[TextFieldType.Email.rawValue].text
		user.password = textFields[TextFieldType.Password.rawValue].text
		user.email = textFields[TextFieldType.Email.rawValue].text
		user["phone"] = (textFields[TextFieldType.PhoneNumber.rawValue].text.returnActualNumber() as NSString).doubleValue
		user["firstName"] = textFields[TextFieldType.FirstName.rawValue].text
		user["lastName"] = textFields[TextFieldType.LastName.rawValue].text
		user.signUpInBackgroundWithBlock
		{ (succeeded: Bool!, error: NSError!) -> Void in
			if (error == nil && succeeded!)
			{
				// Hooray! Let them use the app now.
				self.navigationController?.popToRootViewControllerAnimated(true)
			}
			else
			{
				let errorString = error.userInfo!["error"] as String
				// Show the errorString somewhere and let the user try again.
				var alert = UIAlertController(title: "Woah! Something went awfully wrong. Please try again.", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
				let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: nil)
				alert.addAction(dismissAction)
				self.presentViewController(alert, animated: true, completion: nil)
			}
		}
	}
	
	/**
	The action called when the sign up button is pressed.
	
	:param: sender The Done UIBarButtonItem
	*/
	func signupButton(sender: UIBarButtonItem)
	{
		signup()
	}
}

typealias TextDelegate = SignUpViewController
extension TextDelegate : UITextFieldDelegate
{
	/**
	This is a callback function that is called when the user hits the return key on the keyboard
	
	:param: textField The textfield on which has the first responder when the return key is pressed
	
	:returns: Returns whether this should result in normal behaviour or not.
	*/
	func textFieldShouldReturn(textField: UITextField) -> Bool
	{
		textField.resignFirstResponder()
		for i in 0..<(textFields.count-1)
		{
			if (textField == textFields[i])
			{
				textFields[i + 1].becomeFirstResponder()
				return true
			}
		}
		signup()
		return true
	}
	
	/**
	This is a callback function that is called when the user finishes editing a text field.
	
	:param: textField The textfield which just finished editing.
	:discussion: This manages scrolling the view to the right amount so that the field being edited is always shown to the user.
	
	*/
	func textFieldDidBeginEditing(textField: UITextField)
	{
		if (!scrollView.frame.contains(textField.frame.origin))
		{
			self.scrollView.scrollRectToVisible(textField.frame, animated: true)
		}
	}
	/**
	A registered notification callback for when the keyboard is shown because the user tapped on a textfield.
	
	:param: notification The notification that the keyboard is now shown.
	:discussion: This function deals with creating an offset for the scroll view whenever the keyboard is shown so that the view does not think that it has the entire screen to draw in rather it has the screen minus the height of the keyboard.
	*/
	func keyboardShown (notification: NSNotification)
	{
		var info = notification.userInfo!
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
		{
			var contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
			scrollView.contentInset = contentInsets
			scrollView.scrollIndicatorInsets = contentInsets
			var rect = self.view.frame
			rect.size.height -= keyboardSize.height
			var activeField = UIView()
			for textField in textFields
			{
				if textField.isFirstResponder()
				{
					activeField = textField
					break
				}
			}
			if (!rect.contains(activeField.frame.origin))
			{
				self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
			}
		}
	}
	
	/**
	A registered notification callback for when the keyboard is shown because the textfields lost responder.
	
	:param: notification The notification that the keyboard is now hidden.
	:discussion: This function deals with removing the offset created for the scroll view whenever the keyboard is hidden so that now the view knows that it has the entire screen to draw on again.
	*/
	func keyboardHidden (notification: NSNotification)
	{
		var contentInsets = UIEdgeInsetsZero
		scrollView.contentInset = contentInsets
		scrollView.scrollIndicatorInsets = contentInsets
	}
	/**
	This function handles callbacks for when the phone number field is being edited and is called each time a button on the keyboard is pressed.
	
	:param: sender The phone number text field.
	*/
	func phoneNumberMask(sender: AnyObject)
	{
		if let textField = sender as? UITextField
		{
			if textField == textFields[TextFieldType.PhoneNumber.rawValue]
			{
				//Setting cursor position.
				if let currentCurserPosition = textFields[TextFieldType.PhoneNumber.rawValue].selectedTextRange
				{
					var isEndOfString = false
					let currentCurserPositionInteger = textField.offsetFromPosition(textField.beginningOfDocument, toPosition: currentCurserPosition.start)
					if currentCurserPositionInteger == countElements(textField.text)
					{
						isEndOfString = true
					}
					textFields[TextFieldType.PhoneNumber.rawValue].text = textField.text.returnMaskedPhoneText()
					
					if isEndOfString == false
					{
						textFields[TextFieldType.PhoneNumber.rawValue].selectedTextRange = currentCurserPosition
					}
				}
				else
				{
					textFields[TextFieldType.PhoneNumber.rawValue].text = textField.text.returnMaskedPhoneText()
				}
			}
		}
	}
	
}
