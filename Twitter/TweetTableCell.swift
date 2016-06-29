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
    var profilePicture: UIImage? {
        get { return profileImageView.image }
        set { profileImageView.image = profilePicture }
    }
    
    var handle: String? {
        get { return handleLabel.text }
        set { handleLabel.text = handle }
    }
    
    var name: String? {
        get { return nameLabel.text }
        set { nameLabel.text = name }
    }
    
    var tweet: String? {
        get { return tweetLabel.text }
        set { tweetLabel.text = tweet }
    }
    
    var timestamp: String? {
        get { return timestampLabel.text }
        set { timestampLabel.text = timestamp }
    }
    
    var heartCount: Int? {
        get { return Int(heartCountLabel.text!)}
        set { heartCountLabel.text = String(heartCount) }
    }
    
    var retweetCount: Int?  {
        get { return Int(retweetCountLabel.text!)}
        set { retweetCountLabel.text = String(retweetCount)}
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
    
    init(tweet: Tweet, frame: CGRect) {
        super.init(frame: frame)
        profileImageView.setImageWithURL(tweet.profileURL!)
        tweetID = tweet.tweetID
        handle = tweet.handle
        name = tweet.name
        retweetCount = tweet.retweetCount
        heartCount = tweet.favoritesCount
        self.tweet = tweet.tweet
        let timestampDate = tweet.timestamp
        let currentDate = NSDate()
        let hoursFromCurrent = currentDate.hours(from: timestampDate!)
        timestamp = String(hoursFromCurrent) + " hrs"
        
        initSubviews()
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
    @IBAction func onRetweetButton(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(tweetObject!, delegate: delegate!)
        print("button pressed")
    }
    @IBAction func onHeartButton(sender: AnyObject) {
    }

    
}
