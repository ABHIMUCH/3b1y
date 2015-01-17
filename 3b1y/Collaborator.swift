//
//  Collaborator.swift
//  3b1y
//
//  Created by Manav Gabhawala on 1/17/15.
//  Copyright (c) 2015 Manav Gabhawala. All rights reserved.
//

import Foundation

class Collaborator
{
	var objectId : String
	var userName : String
	var songLimit: Int
	init(objectId: String, userName: String, songLimit: Int)
	{
		self.objectId = objectId
		self.userName = userName
		self.songLimit = songLimit
	}
}