//
//  ViewController.swift
//  Twitter
//
//  Created by Ali Mir on 9/26/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onLoginTap(sender: AnyObject?) {
        
        TwitterClient.shared.login(
            success: {
            self.handleSuccessfulLogin()
        },
            failure: {
                error in
        })
        
    }
    
    @IBAction func onShowTweets(sender: AnyObject?) {
        TwitterClient.shared.tweets(from: .homeTimeline) {
            tweets, error in
            if let tweets = tweets {
                print("\(tweets.count) tweets:")
                for (index, tweet) in tweets.enumerated() {
                    print("user \(index): \(tweet.user!)")
                }
            } else {
                print("no tweets here!")
            }
        }
    }
    
    func handleSuccessfulLogin() {
        let tweetsNavVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tweetsNavCtrl") as! UINavigationController
        self.present(tweetsNavVC, animated: true, completion: nil)
    }
    
}

