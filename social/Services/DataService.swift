//
//  DataService.swift
//  social
//
//  Created by Lauren Charlton on 11/10/2017.
//  Copyright © 2017 Lauren Charlton. All rights reserved.
//

import Foundation
import Firebase
//this is global (all global variables should be in capitals
//it contains the url of the route of the database
let DB_BASE = Database.database().reference()

class DataService {
    //make a single instance of a class
    //this makes the class easy to reference and code with
    //static makes it global
    static let ds = DataService()
    private var _REF_BASE = DB_BASE
    //creating common end points
    //creates post reference
    //access the end point by using child and inputting the name
    //reference to posts
    private var _REF_POSTS = DB_BASE.child("posts")
    //referenece to users
    private var _REF_USERS = DB_BASE.child("users")
    //makes the references global
    //this is done as security so no one else can reference these variables
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
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
    
}
