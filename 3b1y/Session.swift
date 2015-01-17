//
//  Session.swift
//  3b1y
//
//  Created by Manav Gabhawala on 1/17/15.
//  Copyright (c) 2015 Manav Gabhawala. All rights reserved.
//

import Foundation

class Session : Printable
{
	var description : String
	{
		get
		{
			let dateFormatter = NSDateFormatter()
			dateFormatter.dateStyle = .MediumStyle
			return "The session, \(name), is on \(dateFormatter.stringFromDate(date)) and is being hosted by \(hostName)"
		}
	}
	
	var name : String
	var date: NSDate
	var hostName : String
	var collaborators : [Collaborator]
	var objectId : String
	
	init(objectId: String, name: String, date: NSDate, hostName: String, collaborators: [Collaborator])
	{
		self.objectId = objectId
		self.name = name
		self.date = date
		self.hostName = hostName
		self.collaborators = collaborators
	}
}