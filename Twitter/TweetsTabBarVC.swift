//
//  TweetsTabBarVC.swift
//  Twitter
//
//  Created by Ali Mir on 9/29/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

internal class TweetsTabBarVC: UITabBarController {
    
    private var tweetsVCs: [UINavigationController] {
        let homeVC = tweetsNavVC(with: .homeTimeline)
        let mentionsVC = tweetsNavVC(with: .mentionsTimeline)
        let userVC = tweetsNavVC(with: .userTimeLine)
        homeVC.tabBarItem.title = "Home"
        homeVC.tabBarItem.image = #imageLiteral(resourceName: "Home")
        mentionsVC.tabBarItem.title = "Mentions"
        mentionsVC.tabBarItem.image = #imageLiteral(resourceName: "Mentions")
        userVC.tabBarItem.title = "Me"
        userVC.tabBarItem.image = #imageLiteral(resourceName: "User")
        return [homeVC, mentionsVC, userVC]
    }
    
    private func tweetsNavVC(with endpoint: TweetSource) -> UINavigationController {
        let navVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tweetsNavCtrl") as! UINavigationController
        let topVC = navVC.topViewController as! TweetsViewController
        topVC.endpoint = endpoint
        switch endpoint {
        case .homeTimeline:
            topVC.title = "Home"
        case .mentionsTimeline:
            topVC.title = "Mentions"
        case .userTimeLine:
            topVC.title = User.currentUser?.name ?? "Profile"
        }
        return navVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = tweetsVCs
    }
}
