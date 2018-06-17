//
//  UserTableViewController.swift
//  FolledoInstagramClone
//
//  Created by Samuel Folledo on 6/13/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import Parse

class UserTableViewController: UITableViewController {
    
    var usernames = [""]
    var objectIds = [""]
    var isFollowing = ["" : false] //28mins will keep track who our user is currently following
    
//logoutUser
    @IBAction func logoutUser(_ sender: Any) { //6
        PFUser.logOut() //6
        performSegue(withIdentifier: "logoutSegue", sender: self) //6
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let query = PFUser.query() //since its for users not an object
        query?.whereKey("username", notEqualTo:PFUser.current()?.username) //6 19mins so the user does not include and see itself
        
        query?.findObjectsInBackground(block: { (users, error) in //refresh usernames array
            if error != nil {
                print(error!)
                
            } else if let users = users {
                self.usernames.removeAll() //remove all initial values of the array since we initialized our array's 0 with ""
                self.objectIds.removeAll() //20:34 mins
                self.isFollowing.removeAll() //28mins
                
                for object in users { //users we created above is still an object so we have to convert it //dont forget to reload data
                    if let user = object as? PFUser { //convert those object and let compiler see them as a user
                        if let username = user.username {
                            
                            if let objectId = user.objectId { //20mins
                            
                                let usernameArray = username.components(separatedBy: "@") //splits username up with the @ symbol
                                
                                self.usernames.append(usernameArray[0]) //this gets everything before the @ symbol
                                self.objectIds.append(user.objectId!) //saves the objectId
                                
                                
                                let query = PFQuery(className: "Following") //26mins
                                query.whereKey("follower", equalTo: PFUser.current()?.objectId) //26mins setup whereKeys to specify we want to search to see whether our user is following that user //we want out follower to be equal to our user
                                query.whereKey("following", equalTo: objectId) //26mins check whether their following  the user that we're working through, so objectId
                                
                                query.findObjectsInBackground(block: { (objects, error) in
                                    
                                    if let objects = objects {
                                        if objects.count > 0 { //27mins if it's true, then there is a following relationship between our user and the user we're checking
                                            self.isFollowing[objectId] = true //28mins
                                        } else {
                                            self.isFollowing[objectId] = false //28mins this should let the app know where the user is following specific users. Now we just need to put that info on the table itself (in cellForRowAt)
                                        }
                                        
                                        self.tableView.reloadData() //32mins this is added to reloadData whenever we get a new object
                                    }
                                })
                                
                            }
                        }
                    }
                }
                self.tableView.reloadData() //reloads the data
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //6
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) //6

        cell.textLabel?.text = usernames[indexPath.row] //6 each cells will now be usernames of each users
        if let followsBoolean = isFollowing[objectIds[indexPath.row]] { //30mins if followsBoolean is true, then we are following them
        
            if followsBoolean { //29mins objectIds get the objectId of that particular row and then isFollowing will tell us whether the user is following that user or not. If they are, then we add a check mark on the table
                cell.accessoryType = UITableViewCellAccessoryType.checkmark //put a check mark
            }
        }
        
        return cell //6
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //this method is called whenever a particular row is tapped //override because this method already exist, we're just adding to it
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if let followsBoolean = isFollowing[objectIds[indexPath.row]] { //33mins copied from cellForRowAt
            
            if followsBoolean { //33mins if followsBoolean is true, then we are following them then we unfollow them by removing the check and updating our data in our server
                
                isFollowing[objectIds[indexPath.row]] = false //37mins
                
                cell?.accessoryType = UITableViewCellAccessoryType.none //34mins removes the check
                
                let query = PFQuery(className: "Following") //34mins
                query.whereKey("follower", equalTo: PFUser.current()?.objectId) //34mins we want our follower to be our current user
                query.whereKey("following", equalTo: objectIds[indexPath.row]) //34mins we want following to be objectIds
                
                query.findObjectsInBackground(block: { (objects, error) in //34mins we want the objects in the background
                    
                    if let objects = objects { //34mins
                        for object in objects {
                            object.deleteInBackground() //34mins then we delete each objects
                        }
                    }
                }) //36mins so now if we tap on someone we're already following, it should unfollow them i.e. delete any presence they have in our Following class and also remove the checkbox. Dont forget to also update isFollowing
                
            } else { //33mins else we follow them
                
                isFollowing[objectIds[indexPath.row]] = true //37mins
                
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark //adds a checkmark to our cell
                let following = PFObject(className: "Following")//24mins
                
                //to have the current user follow other users, you first set current user as the follower and, click on users to put a checkmark and the follower will add the user's objectId to the their following attributes
                following["follower"] = PFUser.current()?.objectId //25mins follower will always be our current user
                following["following"] = objectIds[indexPath.row] //25mins objectId of the row thats been tapped on, and the row that we want is indexPath.row
                following.saveInBackground() //25mins
            }
        }
        
        
        
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
