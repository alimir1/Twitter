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
        TwitterAccountManager.shared.login(
            success: {
                print("successfully logged in!!! :D")
        },
            failure: {
                error in
        })
        
    }
}

