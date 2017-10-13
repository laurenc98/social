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
//image picker controller delegate and navigation controller delegate needed to get image to display
class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImage: FancyCircleView!
    @IBOutlet weak var captionField: FancyField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    //image cache
    static var IMAGE_CACHE: NSCache<NSString, UIImage> = NSCache()
    //to prevent button image
    var imageSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        //initialises image picker
        imagePicker = UIImagePickerController()
        //allows editing e.g. crop
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
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

            //pass image in if it exists in the cache
            if let img = FeedVC.IMAGE_CACHE.object(forKey: post.imageUrl) {
                //sends ui
                cell.configureCell(post: post, img: img)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
        } else {
            return PostCell()
        }
    }
    //needed function
    //sends an array
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //one of the items in the array is image picker controller edited image
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            //when thatis selected it sets it to the ui image
            addImage.image = image
            //prevents default button image
            imageSelected = true
        } else {
            print("Lauren: Invalid image, wasn't selected")
        }
        //gets rid of image picker when image selected
        imagePicker.dismiss(animated: true, completion: nil)
    }
    //post
    func postToFirebase(imgUrl: String) {
        //content
        let post: Dictionary<String, AnyObject> = [
            "caption": captionField.text! as AnyObject,
            "imageUrl": imgUrl as AnyObject,
            "likes": 0 as AnyObject
        ]
        //where the post content goes
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        //clears previous post
        captionField.text = ""
        imageSelected = false
        addImage.image = UIImage(named: "add-image")
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
    @IBAction func addImageTapped(_ sender: Any) {
        //displays image picker
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
        //can't post unless image is selected and caption wrote
        //guard statement
        //guard checks it exists and if it does is it not blank
        guard let caption = captionField.text, caption != "" else {
            //error will occur
            print("Lauren: caption must be entered")
            //return needed for guard statements
            return
        }
        //goes to next guard statement if caption passed
        //checks image is selected and its not the default
        guard let img = addImage.image, imageSelected == true else {
            print("Lauren: Image must be selected")
            return
        }
        //uploading image
        //compress the image data
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            let imgUid = NSUUID().uuidString
            //jpeg being passed
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            //use references
            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metaData) { (metaData, error) in
                if error != nil {
                    print("Lauren: Unable to upload image to Firebase Storage")
                } else {
                    print("Lauren: Successfully uploaded image to Firebase Storage")
                    //metadata contain url for downloading
                    let downloadUrl = metaData?.downloadURL()?.absoluteString
                    //unwrap
                    if let url = downloadUrl {
                        self.postToFirebase(imgUrl: url)
                    }
                }
            }
        }
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
