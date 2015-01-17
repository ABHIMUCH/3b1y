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
    var artist: [String]
    var image: NSURL
}
class SongSelectionViewController: UITableViewController
{
    var playlist : SPTPlaylistSnapshot!
    var playlistList : SPTListPage!
    var songs : [Song]
    
    override func viewDidLoad() {
        playlistList = playlist.firstTrackPage
        songs = (playlistList.items as [SPTPlaylistTrack]).map {
            Song(uri: $0.playableUri, name: $0.name, album: $0.album, artist: $0.artists, image: $0.image)
        }
    }
}
extension SongSelectionViewController: UITableViewDelegate, UITableViewDataSource
{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int (playlistList.totalListLength)
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        <#code#>
    }
}