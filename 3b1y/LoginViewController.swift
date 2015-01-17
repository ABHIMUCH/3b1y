//
//  LoginViewController.swift
//  3b1y
//
//  Created by Manav Gabhawala on 1/17/15.
//  Copyright (c) 2015 Manav Gabhawala. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
	@IBOutlet var username : UITextField!
	@IBOutlet var password : UITextField!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
	}
	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
	}
	@IBAction func login(sender: UIButton)
	{
		if (username.text.isEmpty)
		{
			username.shakeForInvalidInput()
		}
	}
	@IBAction func facebookLogin(sender: UIButton)
	{
		var permissions = ["public_profile"]
		PFFacebookUtils.logInWithPermissions(permissions, {
			(user: PFUser!, error: NSError!) -> Void in
			if user == nil
			{
				NSLog("Uh oh. The user cancelled the Facebook login.")
			}
			else if user.isNew
			{
				NSLog("User signed up and logged in through Facebook!")
			}
			else
			{
				
			}
		})
	}
}
