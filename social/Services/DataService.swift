//
//  DataService.swift
//  social
//
//  Created by Lauren Charlton on 11/10/2017.
//  Copyright © 2017 Lauren Charlton. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper
//this is global (all global variables should be in capitals
//it contains the url of the route of the database
let DB_BASE = Database.database().reference()
//it contains the url of the route of the storage
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    //make a single instance of a class
    //this makes the class easy to reference and code with
    //static makes it global
    static let ds = DataService()
    //database references
    private var _REF_BASE = DB_BASE
    //creating common end points
    //creates post reference
    //access the end point by using child and inputting the name
    //reference to posts
    private var _REF_POSTS = DB_BASE.child("posts")
    //referenece to users
    private var _REF_USERS = DB_BASE.child("users")
    
    //storage references
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    //same process ^ for profile images
    //makes the references global
    //this is done as security so no one else can reference these variables
    //datatbase references get set
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    //reference to the current user
    var REF_USER_CURRENT: DatabaseReference {
        //grabs the user id to identify them
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    //storage references get set
    var REF_POST_IMAGES: StorageReference {
        return _REF_POST_IMAGES
    }
    //use references to post data to the database to create users
    //uid = user id number
    //userData is a dictionary and will contain likes and posts
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        //write the data to firebase
        //uid doesn't exist, so it will create it
        //It updates the values of likes and posts
        REF_USERS.child(uid).updateChildValues(userData)
    }
    //get data from firebase
}
