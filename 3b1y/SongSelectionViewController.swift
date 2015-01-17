//
//  SongSelectionViewController.swift
//  3b1y
//
//  Created by Manav Gabhawala on 1/17/15.
//  Copyright (c) 2015 Manav Gabhawala. All rights reserved.
//

import UIKit

struct Playlist
{
	
}

class SongSelectionViewController: UITableViewController
{
	let playlists = [Playlist]()
	
	override func viewDidLoad()
	{
		SPTRequest.playlistsForUserInSession(session, callback: {(error, playlistListRecieved) in
			let playlistList = (playlistListRecieved as SPTPlaylistList)
			
			
		})
	}
	
}
