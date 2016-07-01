//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Nancy Xu on 6/30/16.
//  Copyright © 2016 Nancy Xu. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController, UITweetsViewControllerDelegate {

    @IBOutlet weak var basicTweetInfoCell: TweetTableCell!
    @IBOutlet weak var replyTextView: UITextView!
    @IBOutlet weak var replyProfileImageView: UIImageView!
    @IBOutlet weak var repliesTableView: UITableView!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        basicTweetInfoCell.profileImageView.setImageWithURL(tweet.profileURL!)
        basicTweetInfoCell.handleLabel.text = tweet.handle
        basicTweetInfoCell.nameLabel.text = tweet.name
        basicTweetInfoCell.tweetLabel.text = tweet.tweet
        basicTweetInfoCell.heartCountLabel.text = String(tweet.favoritesCount)
        basicTweetInfoCell.retweetCountLabel.text = String(tweet.retweetCount)
        basicTweetInfoCell.tweetID = tweet.tweetID
        basicTweetInfoCell.tweetObject = tweet
        basicTweetInfoCell.delegate = self
        
        replyTextView.text = "@" + (tweet.user?.screenname)!
        
        let timestampDate = tweet.timestamp
        let currentDate = NSDate()
        if (currentDate.years(from: timestampDate!) > 0) {
            basicTweetInfoCell.timestampLabel.text = String(currentDate.years(from: timestampDate!)) + " years"
        } else if (currentDate.days(from: timestampDate!) > 0) {
            basicTweetInfoCell.timestampLabel.text = String(currentDate.days(from: timestampDate!)) + " days"
        } else if (currentDate.hours(from: timestampDate!) > 0) {
            basicTweetInfoCell.timestampLabel.text = String(currentDate.hours(from: timestampDate!)) + " hrs"
        } else if (currentDate.minutes(from: timestampDate!) > 0) {
           basicTweetInfoCell.timestampLabel.text = String(currentDate.minutes(from: timestampDate!)) + " mins"
        } else {
            basicTweetInfoCell.timestampLabel.text = String(currentDate.seconds(from: timestampDate!)) + " secs"
        }
        replyProfileImageView.image = basicTweetInfoCell.profileImageView.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /* ---------- TWEETS VIEW CONTROLLER DELEGATE ---------- */
    func presentRetweetView() {
        /*var popUpRetweetController: PopUpViewControllerSwift = PopUpViewControllerSwift(nibName: "PopUpViewController", bundle: nil)
         popUpRetweetController.title = "This is a popup view"
         popUpRetweetController.showInView(self.view, withImage: UIImage(named: "heart"), withMessage: "message", animated: true)
         popUpRetweetController.showInView(self.view, withImage: UIImage(named: "heart"), withMessage: "You just triggered a great popup window", animated: true)*/
        print("did retweet end")
    }
    
    func presentDetailsPage(tweet: Tweet, cell: TweetCell) {
        performSegueWithIdentifier("tweetDetailSegue", sender: cell)
    }
    
    func reloadTable() {
    }
    
    func dismissCompose() {
    }
    
    func presentProfilePage(tweet: Tweet, cell: TweetTableCell) {
        
    }

}
