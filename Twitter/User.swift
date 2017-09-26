//
//  User.swift
//  Twitter
//
//  Created by Ali Mir on 9/26/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation

class User: NSObject {
    
    var name: String?
    var createdAt: Date?
    var tagline: String?
    var screenName: String?
    var followersCount: Int?
    var profileURL: URL?
    var tweetsCount: Int?
    var followingCount: Int?
    
    init(dictionary: NSDictionary) {
        if let timeStampString = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createdAt = formatter.date(from: timeStampString)
        }
        
        tagline = dictionary["description"] as? String
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        
        if let followersCount = dictionary["followers_count"] as? NSNumber {
            self.followersCount = Int(followersCount)
        }
        
        if let profileURLString = dictionary["profile_image_url_https"] as? String {
            profileURL = URL(string: profileURLString)
        }
        
        if let tweetsCount = dictionary["statuses_count"] as? NSNumber {
            self.tweetsCount = Int(tweetsCount)
        }
        
        if let followingCount = dictionary["friends_count"] as? NSNumber {
            self.followingCount = Int(followingCount)
        }
        
    }
}
