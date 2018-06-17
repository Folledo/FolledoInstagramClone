//
//  ViewController.swift
//  FolledoInstagramClone
//
//  Created by Samuel Folledo on 6/4/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//
/*
import UIKit
import Parse

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate { //3 UINavigationControllerDelegate and UIImagePickerControllerDelegate are both needed in order to make launch and use an UIImagePickerController
    
    @IBOutlet var imageView: UIImageView! //3
    @IBOutlet var resultLabel: UILabel! //3
    
//3 imagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) { //3 a special method that add the image to our imageView when the user have successfully picked an image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage { //3 our image is in our info variable
            imageView.image = image //3
        } else { //3
            let errorString = "There was a problem getting the image" //3
            print(errorString) //3
            self.resultLabel.text = errorString //3
        } //3
        self.dismiss(animated: true, completion: nil) //3 after picking the image we have to dismiss our UIImagePickerController. We dont need to do anything after the method has been finish because we have already updated and added our image to imageView
    } //3
    
//3 chooseImage action button
    @IBAction func chooseImage(_ sender: Any) { //3 button with method to pick an imagePickerController we will use for our imageView
        let imagePickerController = UIImagePickerController() //3 A VC that manages the system interfaces for taking pictures, recording movies, and choosing items from the user's media library. The role and appearance of an image picker controller depend on the source type you assign to it before you present it (camera, photoLibrary or savedPhotosAlbum)
        imagePickerController.delegate = self //3
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary //3 sourceType can be camera, photoLibrary or savedPhotosAlbum
        imagePickerController.allowsEditing = false //3 not allow editing
        self.present(imagePickerController, animated: true, completion: nil) //3 this presents the VC to pick a photo/or use camera
        self.resultLabel.text = "Image is picked! "
    } //3
    
//4 showAlert
    @IBAction func showAlert(_ sender: Any) { //4
        let alertController = UIAlertController(title: "Hey there", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert) //4 creating an alertController
        
        //4 To add an OK and No in our alertController and then dismiss if tapped
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in //4 'action' is the action object to display as part of the alert. Actions are displayed as buttons in the alert. The action object provides the button text and the action to be performed when that button is tapped.
            let description = "OK button pressed" //4
            self.resultLabel.text = description //4
            print(description) //4
            self.dismiss(animated: true, completion: nil) //4
        })) //4
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in //4
            let description = "No button pressed" //4
            self.resultLabel.text = description //4
            print(description) //4
            self.dismiss(animated: true, completion: nil) //4
        })) //4
        self.present(alertController, animated: true, completion: nil) //4 present and dont want anything to happen on its completion
    }
    
//4 pauseApp
    @IBAction func pauseApp(_ sender: Any) { //4 pausing and displaying a spinner to show that something is going on
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) //4 create a spinner with height and width of 50
        activityIndicator.center = self.view.center //4
        activityIndicator.hidesWhenStopped = true //4
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray //4 set color to gray
        view.addSubview(activityIndicator) //4
        activityIndicator.startAnimating() //4 run it after setting its properties
        
        UIApplication.shared.beginIgnoringInteractionEvents() //4pauses the app when its loading
        //UIApplication.shared.endIgnoringInteractionEvents() //resumes the app
    }
    
    override func viewDidLoad() {
        super.viewDidLoad() // Do any additional setup after loading the view, typically from a nib.

        
/*      //2 Saving to the parse server
        let comment = PFObject(className: "Comment") //2 when we create a PFObject we need to create it with a class name. This allows us to group similar types of objects together and class names as we've seen before
        comment["text"] = "Nice shot!" //2 setting the text attributes
        comment.saveInBackground { (success, error) in //2 OR (success: Bool, error: Error?) in
            if (success) {
                print("Save successfully")
            } else {
                print("Save failed") //2 There was a problem, check error.description
            }
        }
 */
        let query = PFQuery(className: "Comment")
        query.getObjectInBackground(withId: "xk5I0KKUYf") { (object, error) in
            if let comment = object { //2 if object exist then assign it
                //print(comment) //2

//2 loading the comment's text from the server
                if let text = comment["text"] { //2 to just print comment's text
                    print(text) //2
                }
 
//updating the comment's text in the server
                comment["text"] = "Crazy shot!" //2
                comment.saveInBackground { (success, error) in //2
                    if (success) { //2
                        print("Update successful") //2
                    } else { //2
                        print("Update failed") //2
                    }
                }
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

*/
