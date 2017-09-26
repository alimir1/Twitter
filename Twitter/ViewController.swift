//
//  ViewController.swift
//  Twitter
//
//  Created by Ali Mir on 9/26/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func onLoginTap(sender: AnyObject?) {
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "GwywzWnK609rylZRn7Os4K6pd", consumerSecret: "nwUiScF9sZkEfkEsEFpd38iHhT36id0ZxUUST9J0uQ6ll1wk0X")
        twitterClient?.deauthorize()
        twitterClient?.fetchRequestToken(
            withPath: "oauth/request_token",
            method: "GET",
            callbackURL: URL(string: "twitterDemo1://oauth"),
            scope: nil,
            success: {
                requestToken in
                
                guard let requestToken = requestToken, let token = requestToken.token else {
                    print("LoginViewController: did not get request token!")
                    return
                }
                
                
                let url = URL(string: "https://api.twitter.com/oauth/authenticate?oauth_token=\(token)")!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
        },
            failure: {
                error in
                if let error = error {
                    print("LoginViewController: \(error.localizedDescription)")
                }
        })
    }
}

