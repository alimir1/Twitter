//
//  ViewController.swift
//  Twitter
//
//  Created by Ali Mir on 9/26/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit
import MBProgressHUD

internal class LoginViewController: UIViewController {

    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Target-Actions
    
    @IBAction private func onLoginTap(sender: AnyObject?) {
        MBProgressHUD.showAdded(to: view, animated: true)
        TwitterClient.shared.login(
            success: {
                self.handleSuccessfulLogin()
                MBProgressHUD.hide(for: self.view, animated: true)
        },
            failure: {
                error in
                MBProgressHUD.hide(for: self.view, animated: true)
        })
        
    }
    
    // MARK: Helpers
        
    private func handleSuccessfulLogin() {
        let tweetsNavVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tweetsNavCtrl") as! UINavigationController
        self.present(tweetsNavVC, animated: true, completion: nil)
    }
    
}

