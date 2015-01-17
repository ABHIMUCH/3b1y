//
//  SessionCellView.swift
//  3b1y
//
//  Created by Manav Gabhawala on 1/17/15.
//  Copyright (c) 2015 Manav Gabhawala. All rights reserved.
//

import UIKit

class SessionCellView: UICollectionViewCell
{
	@IBOutlet var name : UILabel!
	@IBOutlet var date : UILabel!
	@IBOutlet var host : UILabel!
	@IBOutlet var songLimit : UILabel!
	
	@IBOutlet var addSongs : UIButton!
	@IBOutlet var hostRequest : UIButton!
}
