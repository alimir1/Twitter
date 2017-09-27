//
//  HomeCell.swift
//  Twitter
//
//  Created by Ali Mir on 9/26/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

internal class HomeCell: UITableViewCell {

    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var mediaImageView: UIImageView!
    @IBOutlet private var usernameSmallLabel: UILabel!
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var tweetTextLabel: UILabel!
    @IBOutlet private var timeStampLabel: UILabel!
    
    internal var tweet: Tweet! {
        didSet {
            self.profileImageView.setImageWith(tweet.user!.profileURL!)
            self.usernameSmallLabel.text = "@\(tweet.user!.screenName!)"
            self.usernameLabel.text = tweet.user!.name
            self.tweetTextLabel.text = tweet.text
            self.timeStampLabel.text = "39h" // FIXME: - needs to be formatted
            
            if let mediaURL = tweet.mediaURL {
                mediaImageView.setImageWith(mediaURL)
            } else {
                mediaImageView.image = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 5
        mediaImageView.layer.cornerRadius = 5
    }
}