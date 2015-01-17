//
//  ViewController.swift
//  3b1y
//
//  Created by Manav Gabhawala on 1/16/15.
//  Copyright (c) 2015 Manav Gabhawala. All rights reserved.
//

import UIKit

var sessions = [Session]()

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
		/*if (PFUser.currentUser() == nil)
		{
			performSegueWithIdentifier("login", sender: self)
		}*/
		if (session == nil || !session.isValid())
		{
			authenticateSpotify()
			//TODO: Reload session.
		}
		SPTRequest.userInformationForUserInSession(session, callback: {(error, user) in
			if (error != nil)
			{
				if (PFUser.currentUser() == nil)
				{
					let parseUser = PFUser(className: "User")
					parseUser.username = (user as SPTUser).canonicalUserName
					parseUser.password = "defaultPassword"
					parseUser.email = (user as SPTUser).emailAddress
					parseUser["name"] = (user as SPTUser).displayName
					parseUser["spotifyURI"] = (user as SPTUser).uri
					parseUser.signUpInBackgroundWithBlock({(completed, error) in
						if (completed && error == nil)
						{
							self.loadContent()
						}
						else
						{
							UIAlertController.displayError(error, self)
						}
						
					})
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
	
	func loadContent()
	{
		let query = PFQuery(className: "Collaborator")
		query.whereKey("collaborator", equalTo: PFUser.currentUser())
		query.findObjectsInBackgroundWithBlock({(results, error) in
			
			let foundSessions : [Session] = results.map {
				let songLimit = $0["maximumSongs"] as Int
				let collaborator = Collaborator(objectId: PFUser.currentUser().objectId, userName: PFUser.currentUser().username, songLimit: songLimit)
				let pfSession = $0["session"] as PFObject
				pfSession.fetchIfNeeded()
				let host = pfSession["host"] as PFUser
				host.fetchIfNeeded()
				return Session(objectId: pfSession.objectId, name: pfSession["eventName"]  as String, date: pfSession["eventDate"]  as NSDate, hostName: host["name"] as String, collaborators: [collaborator])
			}
			sessions = foundSessions.sorted({ $0.date <  $1.date })
			if (sessions.count == 0)
			{
				self.noResultsFound()
			}
			self.collectionView?.reloadData()
		})
	}
}

extension ViewController : UICollectionViewDataSource
{
	func noResultsFound()
	{
		let label = UILabel()
		label.text = "No Active Sessions Found."
		label.sizeToFit()
		label.center = view.center
		label.font = UIFont.systemFontOfSize(14)
		view.addSubview(label)
		self.collectionView?.removeFromSuperview()
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return sessions.count
	}
	
	// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as SessionCellView
		//TODO: Create the cell.
		let session = sessions[indexPath.row]
		cell.name = session.name
		cell.date =
		return cell
	}
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
	{
		return 1
	}
}