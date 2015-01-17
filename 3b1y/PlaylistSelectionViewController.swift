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
			self.tableView.reloadData()
		})
	}
}
extension PlaylistSelectionViewController : UITableViewDataSource, UITableViewDelegate
{
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int
	{
		return 1
	}
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		println(playlists.count)
		return playlists.count
	}
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let playlist = playlists[indexPath.row]
		let cell = tableView.dequeueReusableCellWithIdentifier("playlistCell") as PlaylistCell
		cell.playlistName.text = playlist.name
		cell.playlistOwner.text = playlist.owner
		cell.trackCount.text = "\(playlist.trackCount) songs"
		return cell
	}
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		let playlist = playlists[indexPath.row]

		SPTRequest.requestItemAtURI(playlist.uri, withSession: session, callback: {(error, plist) in
			let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("SongList") as SongSelectionViewController
			 println(plist)
			self.navigationController?.pushViewController(viewController, animated: true)
		})
		
	}
}