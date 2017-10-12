//
//  PostCell.swift
//  social
//
//  Created by Lauren Charlton on 10/10/2017.
//  Copyright © 2017 Lauren Charlton. All rights reserved.
//

import UIKit

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
    func configureCell(post: Post) {
        self.post = post
        //sets caption text as the caption
        self.caption.text = post.caption
        //same
        self.numberOfLikesLbl.text = ("\(post.likes)")
        
    }

}
