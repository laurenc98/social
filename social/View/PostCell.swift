//
//  PostCell.swift
//  social
//
//  Created by Lauren Charlton on 10/10/2017.
//  Copyright © 2017 Lauren Charlton. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: FancyCircleView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var numberOfLikesLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    var post: Post!
    //references to likes
    var likesref:  DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //create a tap gesture for the like button
        //it can't be done on storyboard due to it being in a repeating cell
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        //only needs one tap
        tap.numberOfTapsRequired = 1
        //adds the tap gesture to the image
        likeImg.addGestureRecognizer(tap)
        //required to work
        likeImg.isUserInteractionEnabled = true
    }
    //configure cell
    //img is optional because its not already in our cache and needs to be downloaded
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        //sets caption text as the caption
        self.caption.text = post.caption
        //reference to database for likes
        likesref =  DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        //same
        self.numberOfLikesLbl.text = ("\(post.likes)")
        //download image
        //this works with the optional
        if img != nil {
            self.postImg.image = img
        } else {
            //if not in the cache it needs to be downloaded
            let ref = Storage.storage().reference(forURL: post.imageUrl as String)
                //2mb calculation
                ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                 //trying to bring the data from the url
                    if error != nil {
                        print("Lauren: Unable to download image from firebase storage")
                    } else {
                        print("Lauren: Image downloaded from firebase storage")
                        //save data to cache
                        if let imgData = data {
                            //place image url into image
                            if let img = UIImage(data: imgData) {
                                self.postImg.image = img
                                FeedVC.IMAGE_CACHE.setObject(img, forKey: post.imageUrl)
                                
                            }
                        }
                    }
            })
        }
       
        //watches for changes, only watches for one change when cell is created
        likesref.observeSingleEvent(of: .value, with: { (snapshot) in
            //check for null
            //underscore is when variable not required as it wont be reused
            //no like
            if let _ = snapshot.value as? NSNull {
                //set blank image
                self.likeImg.image = UIImage(named: "empty-heart")
                //if someone has liked it
            } else {
                //set liked image
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        })
    }
    //not null
    @objc func likeTapped(sender: UITapGestureRecognizer) {
        //watches for changes, only watches for one change when cell is created
        likesref.observeSingleEvent(of: .value, with: { (snapshot) in
            //check for null
            //underscore is when variable not required as it wont be reused
            //no like
            if let _ = snapshot.value as? NSNull {
                
                self.likeImg.image = UIImage(named: "filled-heart")
                //calls function to adjust number of likes
                self.post.adjustLikes(addLike: true)
                //post data to firebase database
                self.likesref.setValue(true)
            } else {
                //set liked image
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesref.removeValue()
            }
        })
    }
}
