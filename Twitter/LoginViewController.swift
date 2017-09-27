//
//  ViewController.swift
//  Twitter
//
//  Created by Ali Mir on 9/26/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

internal class LoginViewController: UIViewController {

    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Target-Actions
    
    @IBAction private func onLoginTap(sender: AnyObject?) {
        
        TwitterClient.shared.login(
            success: {
            self.handleSuccessfulLogin()
        },
            failure: {
                error in
        })
        
    }
    
    // MARK: Helpers
        
    private func handleSuccessfulLogin() {
        let tweetsNavVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tweetsNavCtrl") as! UINavigationController
        self.present(tweetsNavVC, animated: true, completion: nil)
    }
    
}

