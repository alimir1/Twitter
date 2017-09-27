//
//  HomeViewController.swift
//  Twitter
//
//  Created by Ali Mir on 9/26/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onNewButton(sender: AnyObject?) {
        print("HomeViewController")
        TwitterClient.shared.tweets(from: .homeTimeline) {
            tweets, error in
            if let tweets = tweets {
                print("\(tweets.count) tweets:")
                for (index, tweet) in tweets.enumerated() {
                    print("verified \(index): \(tweet.user!.verified!)")
                }
            } else {
                print("no tweets here!")
            }
        }
    }
    
    @IBAction func onLogout(sender: AnyObject?) {
        TwitterClient.shared.logout()
    }
    
}
