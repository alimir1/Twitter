//
//  HomeCell.swift
//  Twitter
//
//  Created by Ali Mir on 9/26/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var usernameSmallLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var tweetTextLabel: UILabel!
    @IBOutlet var timeStampLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            self.profileImageView.setImageWith(tweet.user!.profileURL!)
            self.usernameSmallLabel.text = "@\(tweet.user!.screenName!)"
            self.usernameLabel.text = tweet.user!.name
            self.tweetTextLabel.text = tweet.text
            self.timeStampLabel.text = "39h" // FIXME: - needs to be formatted
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 5
    }
}
