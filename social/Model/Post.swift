//
//  Post.swift
//  social
//
//  Created by Lauren Charlton on 12/10/2017.
//  Copyright © 2017 Lauren Charlton. All rights reserved.
//
//post object data model
import Foundation

class Post {
    //private variables usually begin with _ so when they are made global they can be removed in the getters
    //store data
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    //get setters to make them global
    var caption: String {
        return _caption
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    //initialises the variables
    init(caption: String, imageUrl: String, likes: Int) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
    }
    //initialises post key
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        //not sure if there will be dictionary data passed through
        //"caption" is the name we used in firebase so it can find the data to pass through
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
    }
}
