//
//  HomeViewController.swift
//  Twitter
//
//  Created by Ali Mir on 9/26/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit
import MBProgressHUD

internal class HomeViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet fileprivate var tableView: UITableView!
    
    // MARK: Stored Properties
    
    
    fileprivate var refreshControl: UIRefreshControl!
    
    internal var tweets = [Tweet]()
    
    // MARK: Lifecycles
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchData()
    }
    
    // MARK: Target-Actions
    
    @IBAction private func onLogout(sender: AnyObject?) {
        TwitterClient.shared.logout()
    }
    
}


// MARK: - Setup Views

extension HomeViewController {
    
    fileprivate func setupViews() {
        setupRefreshControl()
        setupTableView()
    }
    
    fileprivate func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    fileprivate func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    fileprivate func endRefreshing() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
}

// MARK: - Networking

extension HomeViewController {
    @objc fileprivate func fetchData() {
        MBProgressHUD.showAdded(to: view, animated: true)
        TwitterClient.shared.tweets(from: .homeTimeline) {
            tweets, error in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else {
                print("HomeViewController: no tweets!")
                print(error!.localizedDescription)
            }
            self.endRefreshing()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

// MARK: - HomeCellDelegate

extension HomeViewController: HomeCellDelegate {
    func homeCell(_ cell: HomeCell, didTapReply with: Tweet) {
        let replyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "replyVC") as! ReplyViewController
        replyVC.replyingToTweet = with
        present(replyVC, animated: true, completion: nil)
    }
    
    func homeCell(_ cell: HomeCell, didTapRetwet with: Tweet) {
        let retweetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "retweetVC") as! RetweetViewController
        retweetVC.tweet = with
        present(retweetVC, animated: false, completion: nil)
    }
    
    func homeCell(_ cell: HomeCell, didTapFavorite with: Tweet, isFavorite: Bool) {
        
    }
    
}

// MARK: - TableView

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeCell
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        cell.delegate = self
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
}
