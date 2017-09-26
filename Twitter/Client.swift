//
//  AccountManager.swift
//  Twitter
//
//  Created by Ali Mir on 9/26/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

internal class TwitterClient: BDBOAuth1SessionManager {
    
    internal typealias Failure = (TwitterClientError) -> Void
    static let shared = TwitterClient()
    
    internal func timeline(success: @escaping (_ response: Any) -> Void, failure: @escaping Failure) {
        get(
            RequestURL.timeline,
            parameters: nil,
            progress: nil,
            success: {
                task, response in
                guard let response = response else { return }
                success(response)
                print("timeline:\n\(response)")
        },
            failure: {
                task, error in
                failure(.requestError(error))
        })
    }
}
