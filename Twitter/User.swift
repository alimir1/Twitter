//
//  User.swift
//  Twitter
//
//  Created by Ali Mir on 9/26/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    
    
    /**
     Posted when user logs out.
     */
    public static let UserDidLogout = NSNotification.Name("UserDidLogoutNotifictaion")
}

internal class User: NSObject {
    
    private(set) var name: String?
    private(set) var createdAt: Date?
    private(set) var tagline: String?
    private(set) var screenName: String?
    private(set) var followersCount: Int = 0
    private(set) var profileURL: URL?
    private(set) var tweetsCount: Int = 0
    private(set) var followingCount: Int = 0
    private(set) var verified: Bool?
    private(set) var dictionary: NSDictionary?
    
    internal static var currentUser: User?
    
    internal static var isUserLoggedIn: Bool = {
        
        return _currentUser != nil
    }()
    
    private class var _currentUser: User? {
        get {
            if currentUser == nil {
                if let data = UserDefaults.standard.object(forKey: "currentUser") as? NSData, let dictionary = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? NSDictionary {
                    let user = User(dictionary: dictionary)
                    currentUser = user
                }
            }
            return currentUser
        }
        
        set(newUser) {
            currentUser = newUser
            if let user = newUser, let dict = user.dictionary {
                let data = NSKeyedArchiver.archivedData(withRootObject: dict)
                let userDefaults = UserDefaults.standard
                userDefaults.set(data, forKey:"currentUser")
                userDefaults.synchronize()
            }
        }
    }
    
    init(dictionary: NSDictionary) {
        
        self.dictionary = dictionary
        
        if let timeStampString = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createdAt = formatter.date(from: timeStampString)
        }
        
        tagline = dictionary["description"] as? String
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        
        verified = dictionary["verified"] as? Bool
        
        self.followersCount = (dictionary["followers_count"] as? Int) ?? 0
        
        if let profileURLString = dictionary["profile_image_url_https"] as? String {
            profileURL = URL(string: profileURLString)
        }
        
        self.tweetsCount = (dictionary["statuses_count"] as? Int) ?? 0
        
        self.followingCount = (dictionary["friends_count"] as? Int) ?? 0
    }
    
    internal class func setCurrentUser(user: User) {
        _currentUser = user
    }
    
    internal class func removeCurrentUser() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
        UserDefaults.standard.synchronize()
        _currentUser = nil
    }
    
}
