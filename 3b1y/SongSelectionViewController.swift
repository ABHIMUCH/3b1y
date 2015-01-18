//
//  SongSelectionViewController.swift
//  3b1y
//
//  Created by Jaimie Zhu on 1/17/15.
//  Copyright (c) 2015 Manav Gabhawala. All rights reserved.
//

import UIKit

struct Song
{
    var uri : NSURL
    var name: String
    var album: String
    var artists: [String]
    var image: NSURL
}
class SongSelectionViewController: UITableViewController
{
    var playlist : SPTPlaylistSnapshot!
    var playlistList : SPTListPage!
    var songs = [Song]()

    override func viewDidLoad() {
        playlistList = playlist.firstTrackPage
		getNextSongs()
    }
	
	func getNextSongs()
	{
		self.playlistList.requestNextPageWithSession(session, callback: {(error, list) in
			self.playlistList = list as SPTListPage
			let tracks = self.playlistList.items as [SPTPlaylistTrack]
			let newSongs : [Song] = tracks.map {
				let artistNames : [String] = $0.artists.map { $0.name }
				return Song(uri: $0.playableUri, name: $0.name, album: $0.album.name, artists: artistNames, image: $0.album.smallestCover.imageURL)
			}
			for song in newSongs
			{
				self.songs.append(song)
			}
			self.tableView.reloadData()
			if (self.playlistList.hasNextPage)
			{
				self.getNextSongs()
			}
		})
		
	}
}
extension SongSelectionViewController: UITableViewDelegate, UITableViewDataSource
{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
	{
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		println(songs.count)
		return Int(songs.count)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		if (songs.count < indexPath.row)
		{
			log("Please wait. We are still loading the songs.")
		}
		let song = songs[indexPath.row]
		let cell = tableView.dequeueReusableCellWithIdentifier("songCell") as SongCell
		let data = NSData(contentsOfURL: song.image)
		cell.albumArtwork.image = UIImage(data: data!)
		let artistNames = song.artists.reduce("", combine: { $0 + ", " + $1 })
		cell.artistName.text = artistNames
		cell.songName.text = song.name
		cell.albumName.text = song.album
		
		return cell
    }
}