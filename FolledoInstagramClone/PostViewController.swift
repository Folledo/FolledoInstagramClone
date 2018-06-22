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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) { //8 //dont forget to also update info.plist's privacy to allow photo library usage
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage { //8 //9mins this is before we check to see whether we can create a var image if the user has chosen the image and not cancel and cast it as UIImage
            imageToPost.image = image //8
        }
        self.dismiss(animated: true, completion: nil) //8 //10mins
    }
    
    @IBAction func postImage(_ sender: Any) { //8
        
        if let image = imageToPost.image { //8 //14 mins imageData is an optional so first check if there is an image
            let post = PFObject(className: "Post") //8 //create a new class
            post["message"] = comment.text //8
            post["userId"] = PFUser.current()?.objectId //8
            
            if let imageData = UIImagePNGRepresentation(image) { //8
            //8 run a spinner while uploading image and comment
                //activityIndicator
                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) //8 create a spinner with height and width of 50
                activityIndicator.center = self.view.center //5 //8
                activityIndicator.hidesWhenStopped = true //5 //8
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray //5 //8
                view.addSubview(activityIndicator) //5 //8
                activityIndicator.startAnimating() //5 //8
                UIApplication.shared.beginIgnoringInteractionEvents() //5 //8 pauses the app when its loading
                
                
                let imageFile = PFFile(name: "image.png", data: imageData) //8
                post["imageFile"] = imageFile //8
                post.saveInBackground(block: { (success, error) in //8
                    
                   activityIndicator.stopAnimating() //8 //stop spinner after it saveInBackground method runs
                    UIApplication.shared.endIgnoringInteractionEvents() //8
                    
                    if success { //8
                        self.displayAlert(title: "Image Posted", message: "Your image has been posted successfully") //8
                        self.comment.text = "" //8 //17mins clear textfield and imageview
                        self.imageToPost.image = nil //8
                    } else { //8 //if something goes wrong
                        self.displayAlert(title: "Image Could Not Be Posted", message: "Please try again later") //8
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
    
//8 displayAlert method
    func displayAlert(title:String, message:String) { //5 //8
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert) //5 //8
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in //5 //8
            self.dismiss(animated: true, completion: nil) //5 //8
        })) //5 //8
        self.present(alert, animated: true, completion: nil) //5 //8
    } //5 //8
    
}
