//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Nancy Xu on 6/30/16.
//  Copyright © 2016 Nancy Xu. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController, UITweetsViewControllerDelegate, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var basicTweetInfoCell: TweetTableCell!
    @IBOutlet weak var replyTextView: UITextView!
    @IBOutlet weak var replyProfileImageView: UIImageView!
    @IBOutlet weak var repliesTableView: UITableView!
    
    var tweet: Tweet!
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.purpleColor()
        self.navigationController?.tabBarController?.tabBar.barTintColor = UIColor.purpleColor()

        // Refresh control setup
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTweets), forControlEvents: .ValueChanged)
        repliesTableView.insertSubview(refreshControl, atIndex: 0)
        repliesTableView.estimatedRowHeight = 500
        repliesTableView.rowHeight = UITableViewAutomaticDimension
        // Instantiate tweets table view
        repliesTableView.delegate = self
        repliesTableView.dataSource = self
        
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
        
        reloadTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* ---------- FUNCTIONS ---------- */
    // Retrieves tweets and updates table
    func reloadTweets() {
        // Load current tweets in home timeline
        tweets = []
        tweets = TwitterClient.sharedInstance.getRetweets(tweet.tweetID!)
        repliesTableView.reloadData()
    }
    
    // Action for reloading table on pull-down refresh action
    func refreshControlAction(refreshControl: UIRefreshControl) {
        reloadTweets()
        refreshControl.endRefreshing()
    }
    
    /* ---------- TABLE VIEW DATA SOURCE ---------- */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("tweets count2: \(tweets.count)")
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweet = tweets[indexPath.row]
        let cell = repliesTableView.dequeueReusableCellWithIdentifier("tweetCell") as! TweetCell
        return setTableCell(cell, tweet: tweet)
    }
    
    func setTableCell (cell: TweetCell, tweet: Tweet) -> UITableViewCell {
        cell.tweetTableCellView.profileImageView.setImageWithURL(tweet.profileURL!)
        cell.tweetTableCellView.handleLabel.text = tweet.handle
        cell.tweetTableCellView.nameLabel.text = tweet.name
        cell.tweetTableCellView.tweetLabel.text = tweet.tweet
        cell.tweetTableCellView.heartCountLabel.text = String(tweet.favoritesCount)
        cell.tweetTableCellView.retweetCountLabel.text = String(tweet.retweetCount)
        cell.tweetTableCellView.tweetID = tweet.tweetID
        cell.tweetTableCellView.tweetObject = tweet
        cell.tweetTableCellView.delegate = self
        let timestampDate = tweet.timestamp
        let currentDate = NSDate()
        if (currentDate.years(from: timestampDate!) > 0) {
            cell.tweetTableCellView.timestampLabel.text = String(currentDate.years(from: timestampDate!)) + " years"
        } else if (currentDate.days(from: timestampDate!) > 0) {
            cell.tweetTableCellView.timestampLabel.text = String(currentDate.days(from: timestampDate!)) + " days"
        } else if (currentDate.hours(from: timestampDate!) > 0) {
            cell.tweetTableCellView.timestampLabel.text = String(currentDate.hours(from: timestampDate!)) + " hrs"
        } else if (currentDate.minutes(from: timestampDate!) > 0) {
            cell.tweetTableCellView.timestampLabel.text = String(currentDate.minutes(from: timestampDate!)) + " mins"
        } else {
            cell.tweetTableCellView.timestampLabel.text = String(currentDate.seconds(from: timestampDate!)) + " secs"
        }
        return cell
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
