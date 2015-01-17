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
		cachedViewController = self
		super.viewDidAppear(animated)
		/*if (PFUser.currentUser() == nil)
		{
			performSegueWithIdentifier("login", sender: self)
		}*/
		if (session == nil || PFUser.currentUser() == nil)
		{
			authenticateSpotify()
			//TODO: Reload session.
		}
		else if (!session.isValid())
		{
			//TODO: Reload session.
			log("Please learn how to reload the session.")
		}
		
	}
	
	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	func loadSpotify()
	{
		if (PFUser.currentUser() != nil)
		{
			loadContent()
			return
		}
		SPTRequest.userInformationForUserInSession(session, callback: {(error, user) in
			if (error == nil)
			{
				if (PFUser.currentUser() == nil)
				{
					let parseUser = PFUser()
					parseUser.username = (user as SPTUser).canonicalUserName
					parseUser.password = "defaultPassword"
					parseUser.email = (user as SPTUser).emailAddress
					parseUser["name"] = (user as SPTUser).displayName
					parseUser["spotifyURI"] = (user as SPTUser).uri.absoluteString
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
				return Session(objectId: pfSession.objectId, name: pfSession["eventName"]  as String, date: pfSession["eventDate"]  as NSDate, hostName: host["name"] as String, hostUserName: host.username, hosting: pfSession["hosting"] as Bool, collaborators: [collaborator])
			}
			sessions = foundSessions.sorted({ $0.date <  $1.date })
			if (sessions.count == 0)
			{
				self.noResultsFound()
			}
			else
			{
				self.collectionView?.reloadData()
			}
		})
	}
}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate
{
	func noResultsFound()
	{
		let label = UILabel()
		label.text = "No Active Sessions Found."
		label.font = UIFont.systemFontOfSize(18)
		label.sizeToFit()
		label.textColor = UIColor.whiteColor()
		label.center = view.center
		view.addSubview(label)
		view.bringSubviewToFront(label)
		//self.collectionView?.removeFromSuperview()
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
		cell.name.text = session.name
		cell.date.text = session.date.longStringValue
		cell.host.text = session.hostName
		let songLimit = session.collaborators.filter{PFUser.currentUser().username == $0.userName }.first?.songLimit
		cell.songLimit.text = "You have been limited to \(songLimit) songs."
		if (songLimit == nil || songLimit == 0)
		{
			cell.songLimit.text = "You have unlimited song requests."
		}
		cell.addSongs.tag = indexPath.row
		cell.addSongs.addTarget(self, action: "addSongsToSession:", forControlEvents: .TouchUpInside)
		cell.hostRequest.tag = indexPath.row
		if (PFUser.currentUser().username == session.hostUserName)
		{
			if (session.hosting)
			{
				cell.hostRequest.setTitle("View Requests", forState: .Normal)
				cell.hostRequest.addTarget(self, action: "checkRequests", forControlEvents: .TouchUpInside)
			}
			else
			{
				cell.hostRequest.addTarget(self, action: "hostSession:", forControlEvents: .TouchUpInside)
			}
		}
		else
		{
			cell.hostRequest.setTitle("Request Song", forState: .Normal)
			cell.hostRequest.enabled = session.hosting
			cell.hostRequest.addTarget(self, action: "requestSong:", forControlEvents: .TouchUpInside)
		}
		return cell
	}
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
	{
		return 1
	}
	
	func hostSession(sender: UIButton)
	{
		
	}
	
	func requestSong(sender: UIButton)
	{
		
	}
	func addSongsToSession(sender: UIButton)
	{
		
	}
	func checkRequests(sender: UIButton)
	{
		
	}
	@IBAction func createSession(sender: UIBarButtonItem)
	{
		//TODO: Add the sesh to Parse
		performSegueWithIdentifier("sessionCreate", sender: self)
		
	}
}