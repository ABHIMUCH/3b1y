//
//  ViewController.swift
//  3b1y
//
//  Created by Manav Gabhawala on 1/16/15.
//  Copyright (c) 2015 Manav Gabhawala. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController
{
	override func viewDidLoad()
	{
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
	}
	override func viewDidAppear(animated: Bool)
	{
		super.viewDidAppear(animated)
		if (PFUser.currentUser() == nil)
		{
			performSegueWithIdentifier("login", sender: self)
		}
		if (!session.isValid())
		{
			//TODO: Reload session.
		}
		SPTRequest.userInformationForUserInSession(session, callback: {(error, user) in
			if (error != nil)
			{
				if ((PFUser.currentUser()["spotifyURI"] as String).isEmpty)
				{
					PFUser.currentUser()["spotifyURI"] = (user as SPTUser)
				}
			}
			else
			{
				UIAlertController.displayError(error, self)
			}
		})
	}
	
	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}