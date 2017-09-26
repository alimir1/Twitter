//
//  ViewController.swift
//  Twitter
//
//  Created by Ali Mir on 9/26/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func onLoginTap(sender: AnyObject?) {
        TwitterClient.shared.login(
            success: {
                TwitterClient.shared.createAccount {
                    response, error in
                }
                
                TwitterClient.shared.tweets(from: .homeTimeline) {
                    response, error in
                }
        },
            failure: {
                error in
        })
        
    }
}

