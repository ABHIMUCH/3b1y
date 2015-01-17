//
//  AddCollaboratorViewController.swift
//  3b1y
//
//  Created by Manav Gabhawala on 1/17/15.
//  Copyright (c) 2015 Manav Gabhawala. All rights reserved.
//

import UIKit

class AddCollaboratorViewController: UITableViewController
{
    var potentialUsers = [PFUser]()
    @IBOutlet var searchBar : UISearchBar!
	
	func users (input : String) {
        if (input.isEmpty)
        {
            displayNoResults()
            return
        }
        let query1 = PFQuery()
        query1.whereKey("email", hasPrefix: input)
		
        let query2 = PFQuery()
        query2.whereKey("name", hasPrefix: input)
        
        let query3 = PFQuery()
        query3.whereKey("username", hasPrefix: input)
        let query = PFQuery.orQueryWithSubqueries([query1, query2, query3])
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if (objects.count == 0)
                {
                    self.displayNoResults()
                }
                else
                {
                    self.potentialUsers = objects as [PFUser]
                    self.tableView.reloadData()
                }
            } else
            {
                // Log details of the failure
                UIAlertController.displayError(error, self)
            }
        }
    }
    func displayNoResults()
    {
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
		//self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        searchBar.delegate = self
    }
    
    
}

extension AddCollaboratorViewController : UITableViewDelegate, UITableViewDataSource
{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return potentialUsers.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:
        NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell") as UITableViewCell
        cell.textLabel?.text = potentialUsers[indexPath.row]["name"] as? String
        cell.detailTextLabel?.text = potentialUsers[indexPath.row].username
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:
        NSIndexPath)
    {
        //This basically means someone picked a row.
    }
    
}
extension AddCollaboratorViewController : UISearchBarDelegate
{
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
		log(searchBar.text)
		users(searchBar.text)
    }

    
}