//
//  TweetTableCell.swift
//  Twitter
//
//  Created by Nancy Xu on 6/28/16.
//  Copyright © 2016 Nancy Xu. All rights reserved.
//

import UIKit

class TweetTableCell: UIView {
    /* ---------- OUTLETS ---------- */
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var heartCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    /* ---------- VARIABLES ---------- */
    var handle: String? {
        didSet { handleLabel.text = handle }
    }
    
    var name: String? {
        didSet { nameLabel.text = name }
    }
    
    var tweet: String? {
        didSet { tweetLabel.text = tweet }
    }
    
    var timestamp: String? {
        didSet { timestampLabel.text = timestamp }
    }
    
    var heartCount: Int? {
        didSet { heartCountLabel.text = String(heartCount)}
    }
    
    var retweetCount: Int?  {
        didSet { retweetCountLabel.text = String(retweetCount!)}
    }
    
    var tweetID: String?
    var delegate: UITweetsViewControllerDelegate?
    var tweetObject: Tweet?
    
    /* ---------- INITIALIZERS ---------- */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    init(tweet: Tweet, frame: CGRect, delegate: UITweetsViewControllerDelegate) {
        super.init(frame: frame)
        initSubviews()
        
        profileImageView.setImageWithURL(tweet.profileURL!)
        tweetID = tweet.tweetID
        handleLabel.text = tweet.handle
        nameLabel.text = tweet.name
        retweetCountLabel.text = String(tweet.retweetCount)
        heartCountLabel.text = String(tweet.favoritesCount)
        self.tweet = tweet.tweet
        let timestampDate = tweet.timestamp

        let currentDate = NSDate()
        if (currentDate.years(from: timestampDate!) > 0) {
            timestamp = String(currentDate.years(from: timestampDate!)) + " years"
        } else if (currentDate.days(from: timestampDate!) > 0) {
            timestamp = String(currentDate.days(from: timestampDate!)) + " days"
        } else if (currentDate.hours(from: timestampDate!) > 0) {
            timestamp = String(currentDate.hours(from: timestampDate!)) + " hrs"
        } else if (currentDate.minutes(from: timestampDate!) > 0) {
            timestamp = String(currentDate.minutes(from: timestampDate!)) + " mins"
        } else {
            timestamp = String(currentDate.seconds(from: timestampDate!)) + " secs"
        }
        timestampLabel.text = timestamp
        
        tweetObject = tweet
        self.delegate = delegate
    }

    func initSubviews() {
        let nib = UINib(nibName: "TweetTableCell", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        contentView.frame = bounds
        profileImageView.contentMode = UIViewContentMode.ScaleAspectFill
        profileImageView.clipsToBounds = true
        addSubview(contentView)
    }
    
    /* ---------- ACTIONS ---------- */

    @IBAction func onReplyButton(sender: AnyObject) {
    }
    
    @IBAction func onCellTap(sender: AnyObject) {
        let senderTyped = sender as! UITapGestureRecognizer
        delegate!.presentDetailsPage(tweetObject!, cell: self.superview!.superview! as! TweetCell)
    }
    
    // Send API retweet, update count, present view
    @IBAction func onRetweetButton(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(tweetObject!, delegate: delegate!)
        retweetCountLabel.text = String(Int(retweetCountLabel.text!)! + 1)
        delegate?.presentRetweetView()
    }
    
    @IBAction func onHeartButton(sender: AnyObject) {
        TwitterClient.sharedInstance.heart(tweetObject!, delegate: delegate!)
        heartCountLabel.text = String(Int(heartCountLabel.text!)! + 1)
    }

    
}
