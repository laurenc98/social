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
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //configure cell
    //img is optional because its not already in our cache and needs to be downloaded
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        //sets caption text as the caption
        self.caption.text = post.caption
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
    }
}
