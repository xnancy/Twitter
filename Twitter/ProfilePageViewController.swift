//
//  ProfilePageViewController.swift
//  Twitter
//
//  Created by Nancy Xu on 6/30/16.
//  Copyright © 2016 Nancy Xu. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController {

    /* ---------- OUTLETS ----------- */
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var taglineTextView: UITextView!
    @IBOutlet weak var statsSegementedControl: UISegmentedControl!

    /* ---------- VARIABLES ----------- */
    var user: User?
    
    /* ---------- VIEW CONTROLLER ---------- */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = User.currentUser
        
        profileImageView.setImageWithURL((user?.profileURL)!)
        nameLabel.text = user?.name
        handleLabel.text = user?.screenname
        taglineTextView.text = user?.tagline
        statsSegementedControl.setTitle("621" + " FOLLOWING", forSegmentAtIndex: 0)
        statsSegementedControl.setTitle("10.4K " + " FOLLOWERS", forSegmentAtIndex: 1)
        statsSegementedControl.setTitle("3,011 " + " TWEETS", forSegmentAtIndex: 2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
