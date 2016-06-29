//
//  LoginViewController.swift
//  Twitter
//
//  Created by Nancy Xu on 6/27/16.
//  Copyright © 2016 Nancy Xu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    @IBAction func onLoginButton(sender: AnyObject) {
        TwitterClient.sharedInstance.login({
            print("I've logged in!")
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }) { (error: NSError) in
            print("Error: \(error.localizedDescription)")
        }
    }
}
