//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Nancy Xu on 6/27/16.
//  Copyright © 2016 Nancy Xu. All rights reserved.
//

import UIKit
import NMPopUpViewSwift
import KLCPopup

protocol UITweetsViewControllerDelegate {
    func presentRetweetView()
    func reloadTable()
    func presentDetailsPage(tweet: Tweet, cell: TweetCell)
    func dismissCompose()
    func presentProfilePage(tweet: Tweet, cell: TweetTableCell)
}

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITweetsViewControllerDelegate {
    /* ---------- OUTLETS ---------- */
    @IBOutlet weak var tweetsTable: UITableView!
    
    /* ---------- VARIABLES ---------- */
    var tweets: [Tweet] = []
    var popUpController: KLCPopup?
    
    /*  ---------- VIEW FUNCTIONS ----------  */
    override func viewDidLoad() {
        print("View did load")
        super.viewDidLoad()
        
        // Refresh control setup 
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTweets), forControlEvents: .ValueChanged)
        tweetsTable.insertSubview(refreshControl, atIndex: 0)
        tweetsTable.estimatedRowHeight = 500
        tweetsTable.rowHeight = UITableViewAutomaticDimension
        // Instantiate tweets table view
        tweetsTable.delegate = self
        tweetsTable.dataSource = self
        
        reloadTweets()
    }
    
    /* ---------- FUNCTIONS ---------- */
    // Retrieves tweets and updates table
    func reloadTweets() {
        // Load current tweets in home timeline
        tweets = []
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            for tweet in tweets {
                self.tweets.append(tweet)
                print("NAME: \(tweet.name)")
            }
            print ("tweets count1: \(tweets.count)")
            print("printing self ")
            print(self.tweets)
            self.tweetsTable.reloadData()
            },
            failure: { (error: NSError) in print("error: \(error.localizedDescription)")
            }
        )
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
        let cell = tweetsTable.dequeueReusableCellWithIdentifier("tweetCell") as! TweetCell
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
    
    func reloadTable() {
        tweetsTable.reloadData()
    }
    
    func presentDetailsPage(tweet: Tweet, cell: TweetCell) {
        performSegueWithIdentifier("tweetDetailSegue", sender: cell)
    }
    
    func presentProfilePage(tweet: Tweet, cell: TweetTableCell) {
        performSegueWithIdentifier("toProfilePage", sender: cell)
    }
    /* ---------- ACTIONS ---------- */
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    
    /* ---------- SEGUES ---------- */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "tweetDetailSegue") {
            let destinationVC = segue.destinationViewController as! TweetDetailViewController
            let senderCell = sender as! TweetCell
            destinationVC.tweet = senderCell.tweetTableCellView.tweetObject
        } else if (segue.identifier == "toProfilePage") {
            let destinationVC = segue.destinationViewController as! ProfilePageViewController
            let senderCell = sender as! TweetTableCell
            destinationVC.user = senderCell.tweetObject?.user
        }

    }
    
    func dismissCompose() {
        popUpController?.dismiss(true)
    }
}
