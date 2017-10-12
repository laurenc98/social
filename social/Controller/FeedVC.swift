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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        //initialise the listening for data
        //listens for changes to the posts object
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            //prevents duplicates
            self.posts = []
            //broken down into individual objects
            //children is each post
            //all objects means likes, caption, image url
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                //take each individual snap (children)
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    //now have objects eg. 3
                    //value is things inside the object such as imageUrl and caption and likes
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        //passing data
                        let post = Post(postKey: key, postData: postDict)
                        //takes the array of posts and appends it
                        self.posts.append(post)
                    }
                }
            }
            //shows the data in the background but does not display yet
            self.tableView.reloadData()
        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            //sends the ui
            cell.configureCell(post: post)
            return cell
        } else {
            return PostCell()
        }
    }
    
    //sign out button
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
