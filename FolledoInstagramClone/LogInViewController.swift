//
//  LogInViewController.swift
//  FolledoInstagramClone
//
//  Created by Samuel Folledo on 6/12/18.
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

import Foundation
import UIKit
import Parse

class LogInViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var signupModeActive = true //5
    
    @IBOutlet weak var resultLabel: UILabel! //5
    @IBOutlet weak var email: UITextField! //5
    
    @IBOutlet weak var password: UITextField! //5
    
//signupOrLogin
    @IBAction func signupOrLogin(_ sender: Any) { //5
        if email.text == "" || password.text == "" { //5
            displayAlert(title:"Error in form", message: "Please enter an email and password") //5
        } else { //5
            
    //activityIndicator
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) //4 create a spinner with height and width of 50
            activityIndicator.center = self.view.center //5
            activityIndicator.hidesWhenStopped = true //5
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray //5
            view.addSubview(activityIndicator) //5
            activityIndicator.startAnimating() //5
            UIApplication.shared.beginIgnoringInteractionEvents() //5pauses the app when its loading
            
            if (signupModeActive) { //5
                print("Signing up...") //5
                
                let user = PFUser() //5
                user.username = email.text //5
                user.password = password.text //5
                user.email = email.text //5
                //user["phone"] = "415-392-0202"
                
                user.signUpInBackground { //5
                    (success, error) in //5
                    
                    activityIndicator.stopAnimating() //5 stop the animation
                    UIApplication.shared.endIgnoringInteractionEvents() //5 let us touch our screen again
                    
                    if let error = error { //5
                        print(error) //5
                        //5 show the errorString and let user try again
                        self.displayAlert(title: "Could not sign you up", message: error.localizedDescription) //5
                    } else { //5
                        //5 Success! Let them use the app now
                        self.resultLabel.text = "Congratulations! You are now in"
                        print("User created") //5
                        self.performSegue(withIdentifier: "showUserTable", sender: self) //6 move from loginVC to userVC
                    }
                }
            } else {
                PFUser.logInWithUsername(inBackground: email.text!, password: password.text!) { (user, error) in //5
                    if user != nil { //5
                        print("Login successful") //5
                        self.performSegue(withIdentifier: "showUserTable", sender: self) //6 move from loginVC to userVC
                    } else { //5
                        var errorText = "Unknown error: Please try again" //5
                        if let error = error { //5
                            errorText = error.localizedDescription //5
                        }
                        self.displayAlert(title: "Could not sign you up", message: errorText) //5
                    }
                }
            }
        }
        
    }
    
    @IBOutlet weak var signupOrLoginButton: UIButton! //5
    
    @IBAction func switchLogInMode(_ sender: Any) { //5
        if (signupModeActive) { //5switch the titles of the button
            signupModeActive = false //5
            signupOrLoginButton.setTitle("Log In", for: []) //5 default state is represented by an empty array
            switchLoginModeButton.setTitle("Sign Up", for: []) //5
        } else {
            signupModeActive = false //5
            signupOrLoginButton.setTitle("Sign Up", for: []) //5
            switchLoginModeButton.setTitle("Log In", for: []) //5
        } //5
    }
    @IBOutlet weak var switchLoginModeButton: UIButton! //5
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//viewDidAppear
    override func viewDidAppear(_ animated: Bool) { //6 put in viewDidAppear because segue can't be performed until the view actually appears on the screen
        
        if PFUser.current() != nil { //6
            performSegue(withIdentifier: "showUserTable", sender: self) //6
        } //6
        
        self.navigationController?.navigationBar.isHidden = true //6 so we dont have a 'back button' on the navigationBar when we log out
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func displayAlert(title:String, message:String) { //5
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert) //5
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in //5
            self.dismiss(animated: true, completion: nil) //5
        })) //5
        self.present(alert, animated: true, completion: nil) //5
    } //5
    
}
