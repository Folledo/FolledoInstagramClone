//
//  UserTableViewController.swift
//  FolledoInstagramClone
//
//  Created by Samuel Folledo on 6/13/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

//1 Parse Server & AWS
//2 Retrieving & Updating Data
//3 Accessing the Camera Roll
//4 Spinners & Alerts
//5 Login & Signup
//6 User Table
//7 Pull to Refresh
//8 Posting Images
//9 Viewing User's Feeds

import UIKit
import Parse

class UserTableViewController: UITableViewController { //6
    
    var usernames = [""] //6
    var objectIds = [""] //6
    var isFollowing = ["" : false]  //6//28mins will keep track who our user is currently following
    
    var refresher: UIRefreshControl = UIRefreshControl() //7 //first we create a refresher which you'll use to control the pull to refresh
    
//logoutUser
    @IBAction func logoutUser(_ sender: Any) { //6
        PFUser.logOut() //6
        performSegue(withIdentifier: "logoutSegue", sender: self) //6
    }
    
//viewDidLoad
    override func viewDidLoad() { //6
        super.viewDidLoad() //6
        
        updateTable() //7
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh") //7 //text we want to appear at the top of the table
        refresher.addTarget(self, action: #selector(UserTableViewController.updateTable), for: UIControlEvents.valueChanged) //7 //what we want to happen when pull to refresh take place //self because we want to make it happen in our VC. valueChanged is a touch dragging or otherwise manipulating a control, causing it to emit a series of different values.
        tableView.addSubview(refresher) //7
        
    } //6

    override func didReceiveMemoryWarning() { //6
        super.didReceiveMemoryWarning() //6
        // Dispose of any resources that can be recreated.
    }

// MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int { //6
        // #warning Incomplete implementation, return the number of sections
        return 1 //6
    }

//numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //6
        // #warning Incomplete implementation, return the number of rows
        return usernames.count //6
    } //6

//cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //6
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) //6

        cell.textLabel?.text = usernames[indexPath.row] //6 each cells will now be usernames of each users
        if let followsBoolean = isFollowing[objectIds[indexPath.row]] { //6 //30mins if followsBoolean is true, then we are following them
        
            if followsBoolean { //6 //29mins objectIds get the objectId of that particular row and then isFollowing will tell us whether the user is following that user or not. If they are, then we add a check mark on the table
                cell.accessoryType = UITableViewCellAccessoryType.checkmark //6 //put a check mark
            }
        }
        
        return cell //6
    }
    
//didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //this method is called whenever a particular row is tapped //override because this method already exist, we're just adding to it
        
        let cell = tableView.cellForRow(at: indexPath) //6
        
        if let followsBoolean = isFollowing[objectIds[indexPath.row]] { //6 //33mins copied from cellForRowAt
            
            if followsBoolean { //6 //33mins if followsBoolean is true, then we are following them then we unfollow them by removing the check and updating our data in our server
                
                isFollowing[objectIds[indexPath.row]] = false //6 //37mins
                
                cell?.accessoryType = UITableViewCellAccessoryType.none //6 //34mins removes the check
                
                let query = PFQuery(className: "Following") //6 //34mins
                query.whereKey("follower", equalTo: PFUser.current()?.objectId) //6 //34mins we want our follower to be our current user
                query.whereKey("following", equalTo: objectIds[indexPath.row]) //6 //34mins we want following to be objectIds
                
                query.findObjectsInBackground(block: { (objects, error) in //6 //34mins we want the objects in the background
                    
                    if let objects = objects { //6 //34mins
                        for object in objects { //6
                            object.deleteInBackground() //6 //34mins then we delete each objects
                        }
                    }
                }) //6 //36mins so now if we tap on someone we're already following, it should unfollow them i.e. delete any presence they have in our Following class and also remove the checkbox. Dont forget to also update isFollowing
                
            } else { //6 //33mins else we follow them
                
                isFollowing[objectIds[indexPath.row]] = true //6 //37mins
                
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark //6 //adds a checkmark to our cell
                let following = PFObject(className: "Following") //6 //24mins
                
                 //6//to have the current user follow other users, you first set current user as the follower and, click on users to put a checkmark and the follower will add the user's objectId to the their following attributes
                following["follower"] = PFUser.current()?.objectId //6 //25mins follower will always be our current user
                following["following"] = objectIds[indexPath.row] //6 //25mins objectId of the row thats been tapped on, and the row that we want is indexPath.row
                following.saveInBackground() //6 //25mins
            }
        }
    } //6 End of didSelectRowAt
    
//updateTable
    @objc func updateTable() { //7 so updatingTable is a method and not just called once in viewDidLoad
        super.viewDidLoad() //6
        
        let query = PFUser.query() //6 //since its for users not an object
        query?.whereKey("username", notEqualTo:PFUser.current()?.username) //6 19mins so the user does not include and see itself //whereKey is a constraint
        
        query?.findObjectsInBackground(block: { (users, error) in  //6 //refresh usernames array
            if error != nil { //6
                print(error!) //6
                
            } else if let users = users {
                self.usernames.removeAll()  //6 //remove all initial values of the array since we initialized our array's 0 with ""
                self.objectIds.removeAll()  //6 //20:34 mins
                self.isFollowing.removeAll()  //6 //28mins
                
                for object in users {  //6 //users we created above is still an object so we have to convert it //dont forget to reload data
                    if let user = object as? PFUser {  //6 //convert those object and let compiler see them as a user
                        if let username = user.username { //6
                            
                            if let objectId = user.objectId { //6 //20mins
                                
                                let usernameArray = username.components(separatedBy: "@") //6 //splits username up with the @ symbol
                                
                                self.usernames.append(usernameArray[0]) //6 //this gets everything before the @ symbol
                                self.objectIds.append(user.objectId!)  //6 //saves the objectId
                                
                                
                                let query = PFQuery(className: "Following") //6 //26mins
                                query.whereKey("follower", equalTo: PFUser.current()?.objectId) //6 //26mins setup whereKeys to specify we want to search to see whether our user is following that user //we want out follower to be equal to our user
                                query.whereKey("following", equalTo: objectId) //6 //26mins check whether their following  the user that we're working through, so objectId
                                
                                query.findObjectsInBackground(block: { (objects, error) in //6
                                    
                                    if let objects = objects { //6
                                        if objects.count > 0 { //6 //27mins if it's true, then there is a following relationship between our user and the user we're checking
                                            self.isFollowing[objectId] = true //6 //28mins
                                        } else { //6
                                            self.isFollowing[objectId] = false //6 //28mins this should let the app know where the user is following specific users. Now we just need to put that info on the table itself (in cellForRowAt)
                                        }
                                        
                                    //7 //reloadData and endRefreshing can cause problem as we're running endRefresh every time we get a new object so its going to end refresh before it's actually finished so we should do a check if there are the same number of objects as the usernames
                                        if self.usernames.count == self.isFollowing.count { //7 //this will be true if we've finished the updating process so we can reload and refresh the tableview
                                            self.tableView.reloadData() //6 //32mins this is added to reloadData whenever we get a new object
                                            self.refresher.endRefreshing() //7 //Call this method at the end of any refresh operation
                                        }//7
                                    }
                                }) //6
                            }
                        }
                    }
                }
                self.tableView.reloadData() //6 //reloads the data
            }
        }) //6
        
    }
    

}
