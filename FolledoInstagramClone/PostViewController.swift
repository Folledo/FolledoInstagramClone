//
//  PostViewController.swift
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


import UIKit //8
//import Foundation //8
import Parse //8

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate { //8 //7mins 2 protocols are added to access photos

    @IBOutlet weak var imageToPost: UIImageView! //8
    
    @IBOutlet weak var comment: UITextField! //8
    
//chooseImage button
    @IBAction func chooseImage(_ sender: Any) { //8
        
        let imagePicker = UIImagePickerController() //8 //8mins
        imagePicker.delegate = self //8 //8mins
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary //8 //8mins
        imagePicker.allowsEditing = false //8 //8mins
        self.present(imagePicker, animated: true, completion: nil) //8 //8mins
        
    }
//8 didFinishPickingMediaWithInfo method for updating the image as well
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) { //dont forget to also update info.plist's privacy to allow photo library usage
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {//9mins this is before we check to see whether we can create a var image if the user has chosen the image and not cancel and cast it as UIImage
            imageToPost.image = image
        }
        self.dismiss(animated: true, completion: nil) //10mins
    }
    
    @IBAction func postImage(_ sender: Any) { //8
        
        if let image = imageToPost.image { //14 mins imageData is an optional so first check if there is an image
            let post = PFObject(className: "Post") //create a new class
            post["message"] = comment.text
            post["userId"] = PFUser.current()?.objectId
            
            if let imageData = UIImagePNGRepresentation(image) {
                
            //8 run a spinner while uploading image and comment
                //activityIndicator
                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) //4 create a spinner with height and width of 50
                activityIndicator.center = self.view.center //5
                activityIndicator.hidesWhenStopped = true //5
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray //5
                view.addSubview(activityIndicator) //5
                activityIndicator.startAnimating() //5
                UIApplication.shared.beginIgnoringInteractionEvents() //5 pauses the app when its loading
                
                
                let imageFile = PFFile(name: "image.png", data: imageData)
                post["imageFile"] = imageFile
                post.saveInBackground(block: { (success, error) in
                    
                   activityIndicator.stopAnimating() //stop spinner after it saveInBackground method runs
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if success {
                        self.displayAlert(title: "Image Posted", message: "Your image has been posted successfully")
                        self.comment.text = "" //17mins clear textfield and imageview
                        self.imageToPost.image = nil
                    } else { //if something goes wrong
                        self.displayAlert(title: "Image Could Not Be Posted", message: "Please try again later")
                    }
                })
            }
        }
        
    }
    
    override func viewDidLoad() { //8
        super.viewDidLoad() //8

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() { //8
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//displayAlert method
    func displayAlert(title:String, message:String) { //5
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert) //5
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in //5
            self.dismiss(animated: true, completion: nil) //5
        })) //5
        self.present(alert, animated: true, completion: nil) //5
    } //5
    
}
