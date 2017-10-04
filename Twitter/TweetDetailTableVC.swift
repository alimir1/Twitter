//
//  TweetDetailTableVC.swift
//  Twitter
//
//  Created by Ali Mir on 9/28/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit
import MBProgressHUD

internal class TweetDetailTableVC: UITableViewController {
    
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
    @IBOutlet private var timeDateBottomLayoutConstraint: NSLayoutConstraint!
    
    // MARK: Stored Properties
    
    internal var tweet: Tweet!
    internal var updatedTweetAction: ((Tweet) -> Void)?

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
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.setLocalizedDateFormatFromTemplate("MM/dd/yyyyh:mma")
        dateTimeLabel.text = formatter.string(from: tweet.createdAt!)
        
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
        mediaImageView.layer.cornerRadius = 10
        mediaImageView.image = nil
        if let mediaURL = tweet.mediaURL {
            mediaImageView.setImageWith(mediaURL)
        }
    }
    
    private func setupUserInfo() {
        setupUserProfileImageView()
        if tweet.isRetweetedTweet {
            nameLabel.text = tweet.retweetSourceUser?.name
            screenNameLabel.text = "@\(tweet.retweetSourceUser?.screenName ?? "")"
        } else {
            nameLabel.text = tweet.user?.name
            screenNameLabel.text = "@\(tweet.user?.screenName ?? "")"
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
        timeDateBottomLayoutConstraint.constant = tweet.mediaURL != nil ? 241 : 0
        profileImageViewTopLayoutConstraint.constant = tweet.isRetweetedTweet || tweet.inReplyToScreenName != nil ? 22 : 0
    }
    
    
    // MARK: Target-action
    @IBAction private func onLikeTap(_ sender: Any) {
        let shouldLike = !tweet.isFavorited
        MBProgressHUD.showAdded(to: view, animated: true)
        TwitterClient.shared.changeLike(isLiked: shouldLike, id: tweet.id!) {
            success, error in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success {
                self.tweet.isFavorited = shouldLike
                self.likeButton.isSelected = shouldLike
                let favoritesCount = self.tweet.favoritesCount
                let updateFavCount = shouldLike ? favoritesCount + 1 : favoritesCount - 1
                self.tweet.setFavCount(updateFavCount)
                self.likesCountLabel.text = "\(updateFavCount)"
                self.updatedTweetAction?(self.tweet)
                return
            }
            print(error!.localizedDescription)
        }
    }
    @IBAction private func onRetweetTap(_ sender: Any) {
        
        let shouldRetweet = !tweet.isRetweeted
        
        if !shouldRetweet {
            MBProgressHUD.showAdded(to: view, animated: true)
            TwitterClient.shared.retweet(id: tweet.id!, shouldUntweet: true) {
                success, error in
                MBProgressHUD.hide(for: self.view, animated: true)
                if success {
                    self.tweet.isRetweeted = false
                    self.retweetButton.isSelected = false
                    let retweetCount = self.tweet.retweetCount
                    let updateRetweetCount = shouldRetweet ? retweetCount + 1 : retweetCount - 1
                    self.tweet.setRetweetsCount(updateRetweetCount)
                    self.retweetCountLabel.text = "\(updateRetweetCount)"
                    self.updatedTweetAction?(self.tweet)
                    return
                }
                print(error!.localizedDescription)
            }
            return
        }
        
        let retweetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "retweetVC") as! RetweetViewController
        retweetVC.tweet = tweet
        retweetVC.retweetAction = {
            retweeted in
            if retweeted {
                self.tweet.isRetweeted = true
                self.retweetButton.isSelected = true
                let retweetCount = self.tweet.retweetCount
                let updateRetweetCount = retweeted ? retweetCount + 1 : retweetCount - 1
                self.tweet.setRetweetsCount(updateRetweetCount)
                self.retweetCountLabel.text = "\(updateRetweetCount)"
                self.updatedTweetAction?(self.tweet)
            }
        }
        present(retweetVC, animated: false, completion: nil)
    }
    @IBAction private func onCommentTap(_ sender: Any) {
        let replyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "replyVC") as! ReplyViewController
        replyVC.replyingToTweet = tweet
        present(replyVC, animated: true, completion: nil)
    }
    
    // MARK: TableView Methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
