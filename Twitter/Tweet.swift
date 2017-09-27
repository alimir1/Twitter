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
    private(set) var isRetweeted: Bool?
    private(set) var mediaURL: URL?
    
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
        
        
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        isRetweeted = dictionary["retweeted"] as? Bool
        
    }
    
    // MARK: Helpers
    
    internal class func tweets(from dictionaries: [NSDictionary]) -> [Tweet] {
        return dictionaries.map {Tweet(dictionary: $0)}
    }
}
