//
//  HostSelectSongsViewController.swift
//  3b1y
//
//  Created by Abhimanyu Muchhal on 1/17/15.
//  Copyright (c) 2015 Manav Gabhawala. All rights reserved.
//

import UIKit

class HostSelectSongsViewController: UITableViewController
{

    func getSongs(inputedSession: String){
        var query = PFQuery(className:"Activity")
        query.whereKey("session", equalTo: inputedSession)
        
        
    query.findObjectsInBackgroundWithBlock {(objects: [AnyObject]!, error: NSError!) -> Void in
       
        var songQuery = PFQuery()
        
        
        
        }
        
    }


}

