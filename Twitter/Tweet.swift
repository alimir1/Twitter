//
//  Timeline.swift
//  Twitter
//
//  Created by Ali Mir on 9/26/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation

internal class Tweet: NSObject {
    
    // MARK: Stored Properties
    
    private(set) var user: User?
    private(set) var createdAt: Date?
    private(set) var text: String?
    private(set) var retweetCount: Int = 0
    private(set) var favoritesCount: Int = 0
    private(set) var mediaURL: URL?
    private(set) var isRetweetedTweet: Bool = false
    private(set) var inReplyToScreenName: String?
    private(set) var retweetSourceUser: User?
    private(set) var id: Int64?
    
    internal var isFavorited: Bool = false
    internal var isRetweeted: Bool = false
    
    // MARK: Initializers
    
    init(dictionary: NSDictionary) {
        if let userDict = dictionary["user"] as? NSDictionary {
            user = User(dictionary: userDict)
        }
        
        if let timeStampString = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createdAt = formatter.date(from: timeStampString)
        }
        
        if let entities = dictionary["entities"] as? NSDictionary, let media = entities["media"] as? [NSDictionary] {
            if let mediaURL = media[0]["media_url_https"] as? String {
                self.mediaURL = URL(string: mediaURL)
            }
        }
        
        id = dictionary["id"] as? Int64
        
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        if let replyScreenName = dictionary["in_reply_to_screen_name"] as? String {
            inReplyToScreenName = replyScreenName
        }
        
        if let retweetStatus = dictionary["retweeted_status"] as? NSDictionary {
            // it's a retweeted tweet
            isRetweetedTweet = true
            if let userDictionary = retweetStatus["user"] as? NSDictionary {
                retweetSourceUser = User(dictionary: userDictionary)
            }
        }
        
        isFavorited = (dictionary["favorited"] as? NSNumber ?? 0) != 0
        isRetweeted = (dictionary["retweeted"] as? NSNumber ?? 0) != 0
    }
    
    // MARK: Helpers
    
    internal class func tweets(from dictionaries: [NSDictionary]) -> [Tweet] {
        return dictionaries.map {Tweet(dictionary: $0)}
    }
    
    internal func setRetweetsCount(_ count: Int) {
        self.retweetCount = count
    }
    
    internal func setFavCount(_ count: Int) {
        self.favoritesCount = count
    }
}
