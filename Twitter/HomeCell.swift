//
//  HomeCell.swift
//  Twitter
//
//  Created by Ali Mir on 9/26/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

@objc protocol HomeCellDelegate: class {
    @objc optional func homeCell(_ cell: HomeCell, didTapReply with: Tweet)
    @objc optional func homeCell(_ cell: HomeCell, didTapRetwet with: Tweet)
    @objc optional func homeCell(_ cell: HomeCell, didTapFavorite with: Tweet, isFavorite: Bool)
}

internal class HomeCell: UITableViewCell {
    
    // MARK: Outlets

    @IBOutlet private var mediaImageView: UIImageView!
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var usernameSmallLabel: UILabel!
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var tweetTextLabel: UILabel!
    @IBOutlet private var timeStampLabel: UILabel!
    @IBOutlet private var retweetStackView: UIStackView!
    @IBOutlet private var retweeterNameLabel: UILabel!
    @IBOutlet private var favoratedButon: UIButton!
    @IBOutlet private var replyButon: UIButton!
    @IBOutlet private var retweetButon: UIButton!
    @IBOutlet private var topConstraint: NSLayoutConstraint!
    
    // MARK: Property Observers
    
    internal var tweet: Tweet! {
        didSet {
            setupCell()
            if let mediaURL = tweet.mediaURL {
                mediaImageView.setImageWith(mediaURL)
            }
            guard !tweet.isRetweetedTweet else {
                setupCellForRetweetedTweet()
                return
            }
            
            setupCellForNonRetweetedTweet()
            
            if let inReplyTo = tweet.inReplyToScreenName {
                retweeterNameLabel.text = "Replying to @\(inReplyTo)"
                retweetStackView.isHidden = false
                topConstraint.constant = 24
            }
        }
    }
    
    internal var isFavorited: Bool = false {
        didSet {
            updateLikeButton()
        }
    }
    
    // MARK: Delegate Property
    
    internal var delegate: HomeCellDelegate?
    
    // MARK: Lifecycles
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 5
        mediaImageView.layer.cornerRadius = 5
    }
    
    private func setupCell() {
        tweetTextLabel.text = tweet.text
        timeStampLabel.text = "39h" // FIXME: - needs to be formatted
        mediaImageView.image = nil
        topConstraint.constant = 8
        setupButtons()
    }
    
    private func setupButtons() {
        favoratedButon.setImage(#imageLiteral(resourceName: "HeartFilled"), for: .selected)
        favoratedButon.setImage(#imageLiteral(resourceName: "HeartUnfilled"), for: .normal)
    }
    
    private func setupCellForRetweetedTweet() {
        profileImageView.setImageWith(tweet.retweetSourceUser!.profileURL!)
        usernameSmallLabel.text = "@\(tweet.retweetSourceUser!.screenName!)"
        usernameLabel.text = tweet.retweetSourceUser?.name
        retweeterNameLabel.text = "\(tweet.user!.name!) retweeted"
        retweetStackView.isHidden = false
        topConstraint.constant = 24
    }
    
    private func setupCellForNonRetweetedTweet() {
        retweetStackView.isHidden = true
        profileImageView.setImageWith(tweet.user!.profileURL!)
        usernameSmallLabel.text = "@\(tweet.user!.screenName!)"
        usernameLabel.text = tweet.user?.name
    }
    
    // MARK: Target-action
    
    @IBAction private func onReplyTap(sender: AnyObject?) {
        delegate?.homeCell?(self, didTapReply: tweet)
    }
    
    @IBAction private func onRetweetTap(_ sender: UIButton) {
        delegate?.homeCell?(self, didTapRetwet: tweet)
    }
    
    @IBAction func onFavoritesTap(_ sender: UIButton) {
        delegate?.homeCell?(self, didTapFavorite: tweet, isFavorite: !isFavorited)
    }
    
    // MARK: Helpers
    
    private func updateLikeButton() {
        favoratedButon.isSelected = isFavorited
    }
}
