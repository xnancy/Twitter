//
//  User.swift
//  Twitter
//
//  Created by Nancy Xu on 6/27/16.
//  Copyright © 2016 Nancy Xu. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    var name: String?
    var screenname: String?
    var profileURL: NSURL?
    var backgroundURL: NSURL?
    var tagline: String?
    var numberFollowing: String?
    var numberFollowers: String?
    var numberTweets: String?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        let profileURLString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileURLString {
            profileURL = NSURL(string: profileUrlString)
        }
        
        let backgroundURLString = dictionary["profile_background_image_url_https"] as? String
        if let backgroundURLString = backgroundURLString {
            backgroundURL = NSURL(string: backgroundURLString)
        }
        
        tagline = dictionary["description"] as? String
        print("PRINTING -------------------------------------------------------")
        numberFollowers = dictionary["followers_count"] as? String
        numberFollowing = dictionary["friends_count"] as? String
        numberTweets = dictionary["statuses_count"] as? String
    }
    
    // Current user class variable (computer property)
    // _ implies hidden class variable
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
            
                let userData = defaults.objectForKey("currentUserData") as? NSData
            
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set (user) {
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
}
