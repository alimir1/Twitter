//
//  TwitterClient.swift
//  Twitter
//
//  Created by Ali Mir on 9/26/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

internal enum TweetSource {
    case homeTimeline
}

internal class TwitterClient: BDBOAuth1SessionManager {
    
    // MARK: Singleton
    
    internal static let shared = TwitterClient(baseURL: URL(string: BaseURL)!, consumerKey: APIKey.consumerKey, consumerSecret: APIKey.consumerSecret)!
    
    internal typealias Failure = (Error?) -> Void
    
    fileprivate var loginSuccess: (() -> Void)?
    fileprivate var loginFailure: (Failure)?
    
    
    // MARK: URL Handler
    
    internal func handle(open url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(
            withPath: RequestURL.accessToken,
            method: Method.post,
            requestToken: requestToken,
            success: {
                _ in
                self.createAccount {
                    user, error in
                    if let user = user {
                        self.loginSuccess?()
                        User.setCurrentUser(user: user)
                    } else {
                        self.loginFailure?(error!)
                    }
                }
        },
            failure: {
                error in
                self.loginFailure?(error)
        })
    }
    
}

// MARK: - Requests

extension TwitterClient {
    // MARK: Get
    
    fileprivate func getRequest(_ urlString: String, with parameters: Any?, completion: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        get(
            urlString,
            parameters: parameters,
            progress: nil,
            success: {
                task, response in
                completion(response, nil)
        },
            failure: {
                task, error in
                completion(nil, error)
        })
    }
    
    // MARK: Post
    
    fileprivate func postRequest(_ urlString: String, with parameters: Any?, completion: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        post(
            urlString,
            parameters: parameters,
            progress: nil,
            success: { task, response in
                completion(response, nil)
        },
            failure: { task, error in
                completion(nil, error)
        })
    }
}

// MARK: - Login/Logout

extension TwitterClient {
    
    // MARK: Login
    
    internal func login(success: @escaping () -> Void, failure: @escaping Failure) {
        deauthorize()
        loginSuccess = success
        loginFailure = failure
        fetchRequestToken(
            withPath: RequestURL.requestToken,
            method: Method.get,
            callbackURL: URL(string: "twitterDemo1://oauth"),
            scope: nil,
            success: {
                requestToken in
                guard let requestToken = requestToken, let token = requestToken.token else {
                    print("TwitterClient: no request token!")
                    return
                }
                let url = URL(string: RequestURL.authentication(token: token))!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
        },
            failure: {
                error in
                self.loginFailure?(error)
        })
    }
    
    // Mark: Logout
    
    internal func logout() {
        NotificationCenter.default.post(name: NSNotification.Name.UserDidLogout, object: nil)
        User.removeCurrentUser()
        deauthorize()
    }
}

// MARK: - Conveniences

extension TwitterClient {
    internal func createAccount(completion: @escaping (_ response: User?, _ error: Error?) -> Void) {
        getRequest(RequestURL.accountVerifyCredentials, with: nil) {
            response, error in
            if let response = response {
                let user = User(dictionary: response as! NSDictionary)
                completion(user, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    internal func tweets(from source: TweetSource, completion: @escaping (_ response: [Tweet]?, _ error: Error?) -> Void) {
        
        var requestURLString = ""
        
        switch source {
        case .homeTimeline:
            requestURLString = RequestURL.timeline
        }
        
        getRequest(requestURLString, with: ["include_entities" : true]) {
            response, error in
            if let response = response {
                let timeline = Tweet.tweets(from: response as! [NSDictionary])
                completion(timeline, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    internal func post(tweet status: String, idForReply id: Int64?, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        
        var parameters = [String : Any]()
        
        parameters["status"] = status
        
        if let id = id {
            parameters["in_reply_to_status_id"] = id
        }
        
        postRequest(RequestURL.update, with: parameters) {
            response, error in
            if response != nil {
                completion(true, error)
            } else {
                completion(false, error)
            }
        }
    }
    
    internal func retweet(id: Int64, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let parameters = ["id" : id]
        postRequest(RequestURL.retweet(id), with: parameters) {
            response, error in
            if response != nil {
                completion(true, error)
            } else {
                completion(false, error)
            }
        }
    }
    
}

// MARK: - String Keys

extension TwitterClient {
    fileprivate static let BaseURL = "https://api.twitter.com"
    
    // MARK: Methods
    
    fileprivate struct Method {
        static let get = "GET"
        static let post = "POST"
        static let put = "PUT"
    }
    
    // MARK: API Keys
    
    fileprivate struct APIKey {
        static let consumerKey = "GwywzWnK609rylZRn7Os4K6pd"
        static let consumerSecret = "nwUiScF9sZkEfkEsEFpd38iHhT36id0ZxUUST9J0uQ6ll1wk0X"
    }
    
    // MARK: Request URL
    
    fileprivate struct RequestURL {
        static let accessToken = "oauth/access_token"
        static let requestToken = "oauth/request_token"
        static let timeline = "1.1/statuses/home_timeline.json"
        static let update = "1.1/statuses/update.json"
        static let accountVerifyCredentials = "1.1/account/verify_credentials.json"
        static func retweet(_ id: Int64) -> String {
            return "1.1/statuses/retweet/\(id).json"
        }
        static func authentication(token: String) -> String {
            return "https://api.twitter.com/oauth/authenticate?oauth_token=\(token)"
        }
    }
}
