//
//  Generic Extensions.swift
//  3b1y
//
//  Created by Manav Gabhawala on 1/17/15.
//  Copyright (c) 2015 Manav Gabhawala. All rights reserved.
//

import Foundation
import UIKit


extension UIView
{
	/**
	This is an extension to UIView which will create a standard shake animation to indicate to the user that something went wrong.
	
	:see: shake:
	*/
	func shakeForInvalidInput()
	{
		shake(iterations: 7, direction: 1, currentTimes: 0, size: 25, interval: 0.1)
		if (self is UITextField)
		{
			if ((self as UITextField).secureTextEntry)
			{
				(self as UITextField).text = ""
			}
		}
	}
	
	/**
	This function shakes a UIView with a spring timing curve using the parameters to create the animations.
	
	:param: iterations   The number of times to shake the view back and forth before stopping
	:param: direction    The direction in which to move the view for the first time
	:param: currentTimes The number of times the function has been performed. Use 0 to begin with.
	:param: size         The size of the shake. i.e. how much to move the view
	:param: interval     The amount of time for each 'shake'.
	*/
	func shake(#iterations: Int, direction: Int, currentTimes: Int, size: CGFloat, interval: NSTimeInterval)
	{
		UIView.animateWithDuration(interval, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 10, options: .allZeros, animations: {() in
			self.transform = CGAffineTransformMakeTranslation(size * CGFloat(direction), 0)
			}, completion: {(finished) in
				if (currentTimes >= iterations)
				{
					UIView.animateWithDuration(interval, animations: {() in
						self.transform = CGAffineTransformIdentity
					})
					return
				}
				self.shake(iterations: iterations - 1, direction: -direction, currentTimes: currentTimes + 1, size: size, interval: interval)
		})
	}
}

extension String
{
	/**
	*  This subscript function gives quick access to a String's character with the position passed in by the substring.
	:Code: var myString = "Hello World"
	myString[4] //returns "o"
	:Returns: A string with the character at the index passed in through the subscript.
	:Warning: This function returns an empty String if the index is out of bounds.
	*/
	subscript (i: Int) -> String
	{
		if countElements(self) > i
		{
			return String(Array(self)[i])
		}
		return ""
	}
	
	/**
	A quick access function that creates a String.Index object which is required in Swift instead of just an index.
	
	:param: theInt The index value that you want the String.Index to refer to.
	
	:returns: The return value is a String.Index object which has the index you would like.
	*/
	func indexAt(theInt: Int) -> String.Index
	{
		return advance(self.startIndex, theInt)
	}
	
	/**
	This function is performed on a string and removes all the formatting/unnecessary characters and returns a String with just numbers in it. This is useful for formatting prices, phone numbers, etc.
	
	:returns: The string with just numbers in it.
	*/
	func returnActualNumber() -> String
	{
		var returnString = stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
		returnString = returnString.stringByReplacingOccurrencesOfString(" ", withString: "")
		returnString = returnString.stringByReplacingOccurrencesOfString("-", withString: "")
		returnString = returnString.stringByReplacingOccurrencesOfString("(", withString: "")
		returnString = returnString.stringByReplacingOccurrencesOfString(")", withString: "")
		returnString = returnString.stringByReplacingOccurrencesOfString("+", withString: "")
		return returnString
	}
	
	/**
	This function can be performed on a string to make a masked string which has number formattings such as +, (, ) and -'s.
	
	:returns: Returns a string that contains the number masked to be in a correct format.
	*/
	func returnMaskedPhoneText() -> String
	{
		var returnString = self
		//Trims non-numerical characters
		returnString = returnString.returnActualNumber()
		
		//Formats mobile number with parentheses and spaces
		if (countElements(returnString) <= 10)
		{
			if (countElements(returnString) > 6)
			{
				returnString = returnString.stringByReplacingCharactersInRange(Range<String.Index>(start: returnString.indexAt(6), end: returnString.indexAt(6)), withString: "-")
			}
			if (countElements(returnString) > 3)
			{
				returnString = returnString.stringByReplacingCharactersInRange(Range<String.Index>(start: returnString.indexAt(3), end: returnString.indexAt(3)), withString: ") ")
			}
			if (countElements(returnString) > 0)
			{
				returnString = returnString.stringByReplacingCharactersInRange(Range<String.Index>(start: returnString.indexAt(0), end: returnString.indexAt(0)), withString: "(")
			}
		}
		else
		{
			returnString = "+" + ((returnString as NSString).substringToIndex(countElements(returnString) - 10) as String) + " " + ((returnString as NSString).substringFromIndex(countElements(returnString) - 10) as String).returnMaskedPhoneText()
		}
		return returnString
	}
	
	/**
	Converts a string to a native Float type if one exists else it returns nil
	
	:returns: Returns a Float or nil from the string the function is called on.
	*/
	func floatValue () -> Float?
	{
		let number = (self as NSString).floatValue
		if (number == 0.0 || number == HUGE || number == -HUGE)
		{
			return nil
		}
		return number
	}
}
/**
Use this function to print any errors that have not be dealt with but you want to print to the command line so that everyone knows something went wrong.

:param: value Pass in anything in here from a string to an int or even your object. Just make sure it follows the Printable protocol.
:see: log <T: DebugPrintable>
*/
func log <T: Printable> (value: T)
{
	let date = NSDate(timeIntervalSinceNow: 0)
	println("\(date.longStringValue):  Fatal problem that hasn't been tended to: \(value)")
}
/**
Use this function to print any errors that have not be dealt with but you want to print to the command line so that everyone knows something went wrong.

:param: value Pass in anything in here from a string to an int or even your object. Just make sure it follows the DebugPrintable protocol.
:see: log <T: Printable>
*/
func log <T: DebugPrintable> (value: T)
{
	let date = NSDate(timeIntervalSinceNow: 0)
	println("\(date.longStringValue):  Fatal problem that hasn't been tended to: \(value)")
}

var session : SPTSession!
var cachedViewController: ViewController!
let clientID = "e6695c6d22214e0f832006889566df9c"
let hostingURL = NSURL(string: "https://peaceful-sierra-1249.herokuapp.com/swap")
let callbackURL = NSURL(string: "spotifyiossdkexample://")
let selectedScopes = [SPTAuthPlaylistModifyPrivateScope]
/**
Use this function to navigate to Spotify to authenticate a user.
*/
func authenticateSpotify()
{
	let auth = SPTAuth.defaultInstance()
	var loginURL : NSURL?
	
	if (hostingURL == nil)
	{
		// If we don't have a token exchange service, we need to request the token response type.
		loginURL = auth.loginURLForClientId(clientID, declaredRedirectURL: callbackURL, scopes: selectedScopes, withResponseType:"token")
	}
	else
	{
		loginURL = auth.loginURLForClientId(clientID, declaredRedirectURL: callbackURL, scopes: selectedScopes)
	}
	if (loginURL == nil)
	{
		log("Error")
	}
	//TODO: Add scopes as required
	UIApplication.sharedApplication().openURL(loginURL!)
}

extension UIAlertController
{
	/**
	Use this function as a generic error displayer for the user. It displays a UIAlertController.
	
	:param: error      The NSError that was generated.
	:param: controller The ViewController currently on the screen. Pass this in so that the function knows where to present the alert.
	*/
	class func displayError(error: NSError, _ controller: UIViewController)
	{
		let dictionary = NSDictionary(dictionary: error.userInfo!)
		let message = dictionary.valueForKey(NSLocalizedFailureReasonErrorKey) as String
		let alertController = UIAlertController(title: "We're sorry. An Error Occurred", message: message, preferredStyle: UIAlertControllerStyle.Alert)
		alertController.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
		controller.presentViewController(alertController, animated: true, completion: nil)
	}
}
extension NSDate
{
	var mediumStringValue : String
	{
		get
		{
			let dateFormatter = NSDateFormatter()
			dateFormatter.dateStyle = .MediumStyle
			return dateFormatter.stringFromDate(self)
		}
	}
	var longStringValue : String
	{
		get
		{
			let dateFormatter = NSDateFormatter()
			dateFormatter.dateStyle = .LongStyle
			dateFormatter.timeStyle = .LongStyle
			return dateFormatter.stringFromDate(self)
		}
	}
}

func < (lhs: NSDate, rhs: NSDate) -> Bool
{
	return (lhs.compare(rhs) == NSComparisonResult.OrderedAscending)
}