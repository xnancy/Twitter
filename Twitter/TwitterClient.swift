//
//  TwitterClient.swift
//  Twitter
//
//  Created by Nancy Xu on 6/27/16.
//  Copyright © 2016 Nancy Xu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "xcVIZWmiYmLoQ5eWWVwQaRfOB", consumerSecret: "UddDquM7zatUcjcyusRpeid4MZ3rZST2fNIDXqiO0mn7gYF1Gn")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        // Get access token for user using verified URL
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
            self.loginSuccess?()
        }) { (error: NSError!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    // Get OAuth token for client
    // Get permission to send a user to the authorized URL (verify correct client)
    // Callback URL twitterclient establishes URL for opening pages back in app (add URL to info tab)
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        // Logout any previous twitter clients
        deauthorize()

        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterclient://oath"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) -> Void in
            print("I got a token!")
            
            // Actual Twitter user authentication URL
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            // Generic URL opener, works to open Safari, Maps, Contacts, etc
            UIApplication.sharedApplication().openURL(url!)
            }) {(error:NSError!) -> Void in
            print("Error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let userDictionary = response as! NSDictionary
                let user = User(dictionary: userDictionary)
                
                success(user)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error: \(error.localizedDescription)")
            }
        )
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries)
                
                success(tweets)
            },
            failure:{ (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)            }
        )
    }
    
    func retweet(tweet: Tweet, delegate: UITweetsViewControllerDelegate) {
        print("retweeting")
        let url = "1.1/statuses/retweet/" + tweet.tweetID! + ".json"
        POST(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            delegate.presentRetweetView()
            },
             failure:{ (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
            }
        )

    }
    
    func heart(tweet: Tweet, delegate: UITweetsViewControllerDelegate) {
        print("hearting")
        let url = "1.1/favorites/create.json?id=" + tweet.tweetID!
        POST(url, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            delegate.presentRetweetView()
            },
             failure:{ (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
            }
        )
        
    }
    
    func postTweet (text: String) {
        print("text is: \(text)")
        let url = "1.1/statuses/update.json"
        POST(url, parameters: ["status": text], success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in},
             failure:{ (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
            }
        )
    }
    
    func logout() {
        User.currentUser = nil 
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
}
