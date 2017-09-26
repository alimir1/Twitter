//
//  RequestURLs.swift
//  Twitter
//
//  Created by Ali Mir on 9/26/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation

extension TwitterAccountManager {
    internal static let BaseURL = "https://api.twitter.com"
    
    // MARK: Methods
    
    internal struct Method {
        static let get = "GET"
        static let post = "POST"
        static let put = "PUT"
    }
    
    // MARK: API Keys
    
    internal struct APIKey {
        static let consumerKey = "GwywzWnK609rylZRn7Os4K6pd"
        static let consumerSecret = "nwUiScF9sZkEfkEsEFpd38iHhT36id0ZxUUST9J0uQ6ll1wk0X"
    }
    
    // MARK: Request URL
    
    internal struct RequestURL {
        static let accessToken = "oauth/access_token"
        static let requestToken = "oauth/request_token"
        static func authentication(token: String) -> String {
            return "https://api.twitter.com/oauth/authenticate?oauth_token=\(token)"
        }
    }
}





