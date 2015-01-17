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
    var name: String
    var album: String
    var artist: String
    var image: NSURL
}
class SongSelectionViewController: UITableViewController
{
    var playlist : SPTPlaylistList!
}
