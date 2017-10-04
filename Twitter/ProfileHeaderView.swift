//
//  ProfileHeaderView.swift
//  Twitter
//
//  Created by Ali Mir on 10/4/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit
import AFNetworking

@IBDesignable
internal class ProfileHeaderView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var headerImageView: UIImageView!
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var screenNameLabel: UILabel!
    @IBOutlet private var tweetsCountLabel: UILabel!
    @IBOutlet private var followingCountLabel: UILabel!
    @IBOutlet private var followersCountLabel: UILabel!
    
    internal var user: User? {
        didSet {
            if let user = user {
                if let bannerImageURL = user.profileBannerImageURL {
                    headerImageView.setImageWith(bannerImageURL)
                    print("has url: \(bannerImageURL)")
                } else {
                    headerImageView.image = #imageLiteral(resourceName: "noBannerImage")
                }
                if let profileURL = user.profileURL {
                    profileImageView.setImageWith(profileURL)
                }
                nameLabel.text = user.name!
                screenNameLabel.text = "@" + user.screenName!
                tweetsCountLabel.text = "\(user.tweetsCount)"
                followersCountLabel.text = "\(user.followersCount)"
                followingCountLabel.text = "\(user.followingCount)"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    private func initView() {
        let nib = UINib(nibName: "ProfileHeaderView", bundle: Bundle(for: type(of: self)))
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        profileImageView.layer.cornerRadius = 5
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 2
    }

}
