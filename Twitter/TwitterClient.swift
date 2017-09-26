//
//  TwitterClient.swift
//  Twitter
//
//  Created by Ali Mir on 9/26/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

internal class TwitterClient: BDBOAuth1SessionManager {
    
    // MARK: Singleton
    
    static let shared = TwitterClient(baseURL: URL(string: BaseURL)!, consumerKey: APIKey.consumerKey, consumerSecret: APIKey.consumerSecret)!
    
    internal typealias Failure = (Error?) -> Void
    
    private var loginSuccess: (() -> Void)?
    private var loginFailure: (Failure)?
    
    
    // MARK: URL Handler
    
    internal func handle(open url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(
            withPath: RequestURL.accessToken,
            method: Method.post,
            requestToken: requestToken,
            success: {
                _ in
                self.loginSuccess?()
        },
            failure: {
                error in
                self.loginFailure?(error)
        })
    }
    
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
    
    private func request(_ urlString: String, completion: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        get(
            urlString,
            parameters: nil,
            progress: nil,
            success: {
                task, response in
                guard let response = response else { return }
                completion(response, nil)
        },
            failure: {
                task, error in
                completion(nil, error)
        })
    }
    
    internal func user(completion: @escaping (_ response: User?, _ error: Error?) -> Void) {
        request(RequestURL.accountVerifyCredentials) {
            response, error in
            if let response = response {
                let user = User(dictionary: response as! NSDictionary)
                completion(user, nil)
            } else {
                completion(nil, error!)
            }
        }
    }
    
    internal func tweets(from source: TweetSource, completion: @escaping (_ response: [Tweet]?, _ error: Error?) -> Void) {
        
        var requestURLString = ""
        
        switch source {
        case .timeline:
            requestURLString = RequestURL.timeline
        }
        
        request(requestURLString) {
            response, error in
            if let response = response {
                let timeline = Tweet.tweets(from: response as! [NSDictionary])
                completion(timeline, nil)
            } else {
                completion(nil, error!)
            }
        }
    }
}
