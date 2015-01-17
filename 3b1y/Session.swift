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
			return "The session, \(name), is on \(date.longStringValue) and is being hosted by \(hostName)"
		}
	}
	
	var name : String
	var date: NSDate
	var hostName : String
	var hostUserName : String
	var collaborators : [Collaborator]
	var objectId : String
	var hosting: Bool = false
	
	init(objectId: String, name: String, date: NSDate, hostName: String, hostUserName: String, hosting: Bool, collaborators: [Collaborator])
	{
		self.objectId = objectId
		self.name = name
		self.date = date
		self.hostUserName = hostUserName
		self.hostName = hostName
		self.hosting = hosting
		self.collaborators = collaborators
	}
}