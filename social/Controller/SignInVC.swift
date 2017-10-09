//
//  SignInVC.swift
//  social
//
//  Created by Lauren Charlton on 05/10/2017.
//  Copyright © 2017 Lauren Charlton. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//when tapped it logins in the user through their facebook account
    @IBAction func facebookBtnTapped(_ sender: Any) {
        //checking that everything is okay with facebook
        let facebookLogin = FBSDKLoginManager()
        //requesting read permissions from the email address
        //self = current view controller
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            //if there is an error
            if error != nil {
                print("Lauren: Unable to authenticate with Facebook - \(error)")
                //if no error, check user hasn't cancelled authentication
            } else if result?.isCancelled == true {
                print("Lauren : User cancelled Facebook Authentication")
                //successful
            } else {
                print("Lauren: Successfully authenticated with Facebook")
                //store it in firebase
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                //calls function and passes the variable
                self.firebaseAuth(credential)
            }
        }
    }
    //authenticate with firebase
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Lauren: Unable to authenticate with Firebase - \(error!)")
            } else {
                print("Lauren: Successfully authenticated with Firebase")
            }
        })
    }
    //Setting up email login
    @IBAction func signInTapped(_ sender: Any) {
        //sets variables to the text of the fields
        if let email = emailField.text, let pwd = pwdField.text {
            //authorises email sign in
            Auth.auth().signIn(withEmail: email, password: pwd, completion: {(user, error) in
                //user exists and the detais are correct
                if error == nil {
                    print("Lauren: Email user authenticated with Firebase")
                    //user doesn't exist, creates account
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: {(user, error) in
                        //something went really wrong
                        if error != nil {
                            print("Lauren: Unable to authenticate with Firebase using email")
                        } else {
                            //user can be created
                            print("Lauren: Successfully authenticated with Firebase using email \(error)")
                        }
                    })
                }
            })
        }
    }
}


