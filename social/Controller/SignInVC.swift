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
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //auto sign in
    override func viewDidAppear(_ animated: Bool) {
        //id present check
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            //if there
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
                //uses complete sign in function to generate key (user = user stops the ? from appearing, this mean it is unwrapped)
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
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
                    //calls function for auto sign in
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                    //user doesn't exist, creates account
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: {(user, error) in
                        //something went really wrong
                        if error != nil {
                            print("Lauren: Unable to authenticate with Firebase using email")
                        } else {
                            //user can be created
                            print("Lauren: Successfully authenticated with Firebase using email \(error)")
                            //calls function to make auto sign in
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
    }
    //auto sign-in
    func completeSignIn(id: String) {
        //creates a key
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Lauren: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}


