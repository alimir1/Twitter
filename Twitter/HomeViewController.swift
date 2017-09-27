//
//  HomeViewController.swift
//  Twitter
//
//  Created by Ali Mir on 9/26/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

internal class HomeViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet fileprivate var tableView: UITableView!
    
    // MARK: Stored Properties
    
    internal var tweets = [Tweet]()
    fileprivate var refreshControl: UIRefreshControl!
    
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
        TwitterClient.shared.tweets(from: .homeTimeline) {
            tweets, error in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else {
                print("no tweets here!")
            }
            self.endRefreshing()
        }
    }
}

// MARK: - TableView

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
}
