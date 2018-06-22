//
//  FeedTableViewController.swift
//  FolledoInstagramClone
//
//  Created by Samuel Folledo on 6/21/18.
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

class FeedTableViewController: UITableViewController {

    var users = [String: String]()
    var comments = [String]() //17mins
    var usernames = [String]() //17mins
    var imageFiles = [PFFile]() //17mins
    
//viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        let query = PFUser.query()
        query?.whereKey("username", notEqualTo: PFUser.current()?.username) //10mins so we dont see the current username
        query?.findObjectsInBackground(block: { (objects,error) in
            
            if let users = objects { //objects contains users but are initially PFObjects that is why we have to unwrap them as users
                for object in users { //now that we have unwrap them, we can loop through them
                    if let user = object as? PFUser { //11mins initially we called them objects, but then we created a user from them by casting the object from PFObject to PFUser
                        self.users[user.objectId!] = user.username! //12mins and store username and userId together
                    }
                }
            }
            
            //13mins now we want to workout who our current user follows
            let getFollowedUsersQuery = PFQuery(className: "Following")
            getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.current()?.objectId) //13mins this finds all the users our current user follows
            getFollowedUsersQuery.findObjectsInBackground(block: { (objects, error) in //runs the query
                if let followers = objects { //14mins if object contains anything, it will be a bunch of followers
                    for follower in followers {
                        if let followedUser = follower["following"] {//15mins we want to find who the "following" userId is to get a list of all the people that our user is following
                            let query = PFQuery(className: "Post") //then find the posts of that user
                            query.whereKey("userId", equalTo: followedUser) //16mins we want it to be equal to the userId of the user we're checking the post of
                            query.findObjectsInBackground(block: { (objects, error) in
                                if let posts = objects {
                                    for post in posts { //16mins
                                        self.comments.append(post["message"] as! String) //18mins RECOMMENDED to use if-let when uploading the app, but for now we'll use force unwrap
                                        self.usernames.append(self.users[post["userId"] as! String]!) //18mins
                                        self.imageFiles.append(post["imageFile"] as! PFFile) //18mins
                                        
                                        self.tableView.reloadData()//19mins now we reloadData
                                    }
                                }
                            })
                            
                        }
                        
                    }
                }
            })
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

//numberOfSections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

//numberOfRows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }

//cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell //9 //5mins "Cell" is the name of cell identifier //we have to force cast it of FeedTableViewCell and we know it will work because they are already linked
        
/*  //7 mins We can access any outlets within the cell by using cell dot notation
        cell.postedImage.image = UIImage(named:"museum.jpg")
        cell.comment.text = "Comment"
        cell.userInfo.text = "Username"
*/
        
        //21mins now we download those images
        imageFiles[indexPath.row].getDataInBackground { (data, error) in
            if let imageData = data {
                //22mins then we add the imageData to our cell.postedImage
                if let imageToDisplay = UIImage(data: imageData) { //22mins
                    
                    cell.postedImage.image = imageToDisplay //22mins
                }
            }
        }
        
        //cell.postedImage.image = UIImage(named: "museum.jpg") //20mins
        cell.comment.text = comments[indexPath.row] //20mins
        cell.userInfo.text = usernames[indexPath.row] //20mins

        return cell
    }
    
    

}
