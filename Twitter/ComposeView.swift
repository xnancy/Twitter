//
//  ComposeView.swift
//  Twitter
//
//  Created by Nancy Xu on 6/30/16.
//  Copyright © 2016 Nancy Xu. All rights reserved.
//

import UIKit

class ComposeView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    var delegate: UITweetsViewControllerDelegate?
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func onTweetButton(sender: AnyObject) {
        print("tweet tapped")
        TwitterClient.sharedInstance.postTweet(tweetTextView.text)
        delegate?.dismissCompose()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "ComposeView", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        addSubview(contentView)
    }
}
