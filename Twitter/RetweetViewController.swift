//
//  RetweetViewController.swift
//  Twitter
//
//  Created by Ali Mir on 9/27/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit
import MBProgressHUD

internal class RetweetViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private var popupView: UIView!
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var screenNameLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var retweetButton: UIButton!
    @IBOutlet private var tapGestureRecognizer: UITapGestureRecognizer!
    
    // MARK: Stored Properties
    
    internal var tweet: Tweet!
    internal var retweetAction: ((Bool) -> Void)?
    
    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        tapGestureRecognizer.addTarget(self, action: #selector(dismissVC))
    }
    
    // MARK: Views Setup
    
    func setupViews() {
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        popupView.layer.cornerRadius = 5
        retweetButton.isEnabled = true
        setupOutlets()
    }
    
    func setupOutlets() {
        
        textLabel.text = tweet.text
        if tweet.isRetweetedTweet {
            setupOutletsForRetweetedTweets()
        } else {
            setupOutletsForNotRetweetedTweets()
        }
    }
    
    func setupOutletsForNotRetweetedTweets() {
        nameLabel.text = tweet.user!.name
        if let profileURL = tweet.user!.profileURL {
            profileImageView.setImageWith(profileURL)
        }
        screenNameLabel.text = "@\(tweet.user!.screenName!)"
    }
    
    func setupOutletsForRetweetedTweets() {
        nameLabel.text = tweet.retweetSourceUser!.name
        if let profileURL = tweet.retweetSourceUser!.profileURL {
            profileImageView.setImageWith(profileURL)
        }
        screenNameLabel.text = "@\(tweet.retweetSourceUser!.screenName!)"
    }
    
    // MARK: Networking
    
    @IBAction private func onRetweet(_ sender: UIButton) {
        retweetButton.isEnabled = false
        MBProgressHUD.showAdded(to: self.view, animated: true)
        TwitterClient.shared.retweet(id: tweet.id!, shouldUntweet: false) {
            success, error in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.retweetButton.isEnabled = true
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("retweet success!")
            self.retweetAction?(true)
            self.dismissVC()
        }
    }
    
    // MARK: Helpers
    
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
}
