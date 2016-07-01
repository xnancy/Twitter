//
//  Tweet.swift
//  Twitter
//
//  Created by Nancy Xu on 6/27/16.
//  Copyright © 2016 Nancy Xu. All rights reserved.
//

import UIKit
import AFNetworking

class Tweet: NSObject {
    var tweetID: String?
    var name: String?
    var handle: String?
    var profileURL: NSURL?
    var backgroundURL: NSURL?
    var tweet: String?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: User?
    
    init(dictionary: NSDictionary) {
        tweetID = dictionary["id_str"] as? String
        name = dictionary["user"]!["name"] as? String
        handle = "@" + (dictionary["user"]!["screen_name"] as? String)!
        let profileURLString = dictionary["user"]!["profile_image_url_https"] as? String
        print("internal url string: \(profileURLString)")
        if let profileUrlString = profileURLString {
            profileURL = NSURL(string: profileUrlString)
            print("actuaul url: \(profileURL?.absoluteString)")
        }
        
        let backgroundURLString = dictionary["user"]!["profile_background_image_url_https"] as? String
        print("profile_background_image_url_https: \(backgroundURLString)")
        if let backgroundURLString = backgroundURLString {
            backgroundURL = NSURL(string: backgroundURLString)
        }
        
        user = User.init(dictionary: dictionary["user"] as! NSDictionary)
        tweet = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
            //print(dictionary)
        }
        return tweets
    }
}
