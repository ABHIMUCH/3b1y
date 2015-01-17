//
//  SongCell.swift
//  3b1y
//
//  Created by Manav Gabhawala on 1/17/15.
//  Copyright (c) 2015 Manav Gabhawala. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell
{
	@IBOutlet var albumArtwork : UIImageView!
	@IBOutlet var songName : UILabel!
	@IBOutlet var artistName : UILabel!
	@IBOutlet var albumName: UILabel!
}

class PlaylistCell : UITableViewCell
{
	@IBOutlet var playlistName: UILabel!
	@IBOutlet var trackCount: UILabel!
	@IBOutlet var playlistOwner: UILabel!
}
