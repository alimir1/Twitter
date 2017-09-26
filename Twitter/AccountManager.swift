//
//  TwitterClient.swift
//  Twitter
//
//  Created by Ali Mir on 9/26/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

internal class TwitterAccountManager: BDBOAuth1SessionManager {
    
    // MARK: Singleton
    
    static let shared = TwitterAccountManager(baseURL: URL(string: BaseURL)!, consumerKey: APIKey.consumerKey, consumerSecret: APIKey.consumerSecret)!
    
    internal typealias Failure = (Error?) -> Void
    
    private var loginSuccess: (() -> Void)?
    private var loginFailure: (Failure)?
    
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
}
