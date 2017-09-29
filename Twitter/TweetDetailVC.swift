//
//  TweetDetailVC.swift
//  Twitter
//
//  Created by Ali Mir on 9/28/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

internal class TweetDetailVC: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private var tweetStatusImageView: UIImageView!
    @IBOutlet private var tweetStatusLabel: UILabel!
    @IBOutlet private var userProfileImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var screenNameLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var mediaImageView: UIImageView!
    @IBOutlet private var dateTimeLabel: UILabel!
    @IBOutlet private var retweetCountLabel: UILabel!
    @IBOutlet private var likesCountLabel: UILabel!
    @IBOutlet private var retweetButton: UIButton!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var statusStackView: UIStackView!
    @IBOutlet private var profileImageViewTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private var timeDateTopLayoutConstraint: NSLayoutConstraint!
    
    // MARK: Stored Properties
    
    internal var tweet: Tweet!
    
    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutlets()
    }
    
    // MARK: Helpers
    
    private func setupOutlets() {
        layoutOutletConstraints()
        setupUserInfo()
        textLabel.text = tweet.text
        setupStatusLabel()
        setupMediaImageView()
        setupDateTimeLabel()
        setupCountLabels()
        setupButtons()
    }
    
    private func setupButtons() {
        setButtonImages()
        likeButton.isSelected = tweet.isFavorited
        retweetButton.isSelected = tweet.isRetweeted
    }
    
    private func setButtonImages() {
        retweetButton.setImage(#imageLiteral(resourceName: "RetweetUnfilled"), for: .normal)
        retweetButton.setImage(#imageLiteral(resourceName: "RetweetFilled"), for: .selected)
        likeButton.setImage(#imageLiteral(resourceName: "HeartUnfilled"), for: .normal)
        likeButton.setImage(#imageLiteral(resourceName: "HeartFilled"), for: .selected)
    }
    
    private func setupDateTimeLabel() {
        dateTimeLabel.text = "\(tweet.createdAt!)"
    }
    
    private func setupCountLabels() {
        retweetCountLabel.text = "\(tweet.retweetCount)"
        likesCountLabel.text = "\(tweet.favoritesCount)"
    }
    
    private func setupStatusLabel() {
        guard tweet.isRetweetedTweet || tweet.inReplyToScreenName != nil else {
            statusStackView.isHidden = true
            return
        }
        
        if tweet.isRetweetedTweet {
            tweetStatusImageView.image = #imageLiteral(resourceName: "RetweetUnfilled")
            tweetStatusLabel.text = "\(tweet.user!.name!) retweeted"
        } else {
            tweetStatusImageView.image = #imageLiteral(resourceName: "CommentUnfilled")
            tweetStatusLabel.text = "Replying to \(tweet.user!.screenName!)"
        }
        
    }
    
    private func setupMediaImageView() {
        if let mediaURL = tweet.mediaURL {
            mediaImageView.setImageWith(mediaURL)
        } else {
            mediaImageView.image = nil
        }
    }
    
    private func setupUserInfo() {
        setupUserProfileImageView()
        if tweet.isRetweetedTweet {
            nameLabel.text = tweet.retweetSourceUser?.name
            screenNameLabel.text = tweet.retweetSourceUser?.screenName
        } else {
            nameLabel.text = tweet.user?.name
            screenNameLabel.text = tweet.user?.screenName
        }
    }
    
    private func setupUserProfileImageView() {
        userProfileImageView.layer.cornerRadius = 5
        if tweet.isRetweetedTweet {
            userProfileImageView.setImageWith(tweet.retweetSourceUser!.profileURL!)
        } else {
            userProfileImageView.setImageWith(tweet.user!.profileURL!)
        }
    }
    
    /// Adjusts constant of constraints based on views
    
    private func layoutOutletConstraints() {
        timeDateTopLayoutConstraint.constant = tweet.mediaURL != nil ? 315.5 : 8
        profileImageViewTopLayoutConstraint.constant = tweet.isRetweetedTweet || tweet.inReplyToScreenName != nil ? 40 : 8
    }
    
}
