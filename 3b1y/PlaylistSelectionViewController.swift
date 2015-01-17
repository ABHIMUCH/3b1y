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
	var name: String
	var uri: NSURL
	var trackCount : Int
	var owner : String
}


class PlaylistSelectionViewController: UITableViewController
{
	var playlists = [Playlist]()
	
	override func viewDidLoad()
	{
		SPTRequest.playlistsForUserInSession(session, callback: {(error, playlistListRecieved) in
			let playlistListItems = (playlistListRecieved as SPTPlaylistList).items
			
			for playlistPartial in playlistListItems as [SPTPartialPlaylist]
			{
				let owner = playlistPartial.owner as SPTUser
				self.playlists.append(Playlist(name: playlistPartial.name, uri: playlistPartial.uri, trackCount: Int(playlistPartial.trackCount), owner: owner.canonicalUserName))
			}
		})
	}
}