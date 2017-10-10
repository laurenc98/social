//
//  FeedVC.swift
//  social
//
//  Created by Lauren Charlton on 09/10/2017.
//  Copyright © 2017 Lauren Charlton. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        //removes key
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("Lauren: ID removed from keychain \(keychainResult)")
        //sign out of firebase
        try! Auth.auth().signOut()
        //back to sign in view
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
