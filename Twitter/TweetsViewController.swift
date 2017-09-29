//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Ali Mir on 9/26/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit
import MBProgressHUD

internal class TweetsViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet fileprivate var tableView: UITableView!
    
    // MARK: Stored Properties
    
    fileprivate var refreshControl: UIRefreshControl!
    fileprivate var favoriteTweets = [Int : Bool]()
    fileprivate var retweetedTweets = [Int : Bool]()
    fileprivate var isFetchingMoreData = false
    internal var endpoint: TweetSource!
    
    // MARK: Property Observers
    
    internal var tweets = [Tweet]() {
        didSet {
            for (index, tweet) in tweets.enumerated() {
                favoriteTweets[index] = tweet.isFavorited
                retweetedTweets[index] = tweet.isRetweeted
            }
        }
    }
    
    // MARK: Lifecycles
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchData(shouldGetNextPage: false)
    }
    
    // MARK: Target-Actions
    
    @IBAction private func onLogout(sender: AnyObject?) {
        TwitterClient.shared.logout()
    }
    
}

// MARK: - Setup Views

extension TweetsViewController {
    
    fileprivate func setupViews() {
        setupRefreshControl()
        setupTableView()
        setupFooterViewForInfiniteScrolling()
    }
    
    fileprivate func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
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

extension TweetsViewController {

    fileprivate func fetchData(shouldGetNextPage: Bool) {
        MBProgressHUD.showAdded(to: view, animated: true)
        isFetchingMoreData = shouldGetNextPage
        TwitterClient.shared.tweets(from: endpoint, shouldGetNextPage: shouldGetNextPage) {
            tweets, error in
            if let tweets = tweets {
                if shouldGetNextPage {
                    for tweet in tweets {
                        self.tweets.append(tweet)
                    }
                } else {
                    self.tweets = tweets
                }
                self.tableView.reloadData()
            } else {
                print("TweetsViewController: no tweets!")
                print(error!.localizedDescription)
            }
            self.isFetchingMoreData = false
            self.endRefreshing()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

// MARKL: - Navigation

extension TweetsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postTweetVC" {
            let postVC = segue.destination as! PostViewController
            postVC.tweetAction = {
                tweet in
                if let tweet = tweet {
                    self.addTweetToTableView(tweet: tweet)
                }
            }
        }
        
        if segue.identifier == "tweetDetailVC" {
            let tweetDetailVC = segue.destination as! TweetDetailTableVC
            let indexPath = tableView.indexPathForSelectedRow!
            tweetDetailVC.tweet = tweets[indexPath.row]
            tweetDetailVC.updatedTweetAction = {
                tweet in
                self.retweetedTweets[indexPath.row] = tweet.isRetweeted
                self.favoriteTweets[indexPath.row] = tweet.isFavorited
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

// MARK: - Infinite Scrolling

extension TweetsViewController: UIScrollViewDelegate {
    
    fileprivate func setupFooterViewForInfiniteScrolling() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 150))
        footerView.backgroundColor = .white
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.startAnimating()
        activityIndicatorView.center = footerView.center
        footerView.addSubview(activityIndicatorView)
        tableView.tableFooterView = footerView
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isFetchingMoreData else { return }
        if scrollView.contentOffset.y > tableView.contentSize.height - tableView.bounds.height && tableView.isDragging {
            fetchData(shouldGetNextPage: true)
        }
    }
}

// MARK: - Helpers

extension TweetsViewController {
    
    @objc fileprivate func refreshPage() {
        fetchData(shouldGetNextPage: false)
    }
    
    func addTweetToTableView(tweet: Tweet) {
        self.tweets.insert(tweet, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func handleUpdatedRetwet(indexPath: IndexPath, isRetweeted: Bool, cell: TweetsCell) {
        self.retweetedTweets[indexPath.row] = isRetweeted
        self.tweets[indexPath.row].isRetweeted = isRetweeted
        cell.isRetweeted = isRetweeted
        let retweetedCount = self.tweets[indexPath.row].retweetCount
        let resetRetweetCount = isRetweeted ? retweetedCount + 1 : retweetedCount - 1
        self.tweets[indexPath.row].setRetweetsCount(resetRetweetCount)
        cell.tweet = self.tweets[indexPath.row]
    }
    
    func handleUpdatedFavorite(indexPath: IndexPath, isFavorite: Bool, cell: TweetsCell) {
        self.favoriteTweets[indexPath.row] = isFavorite
        self.tweets[indexPath.row].isFavorited = isFavorite
        cell.isFavorited = isFavorite
        let favoritesCount = self.tweets[indexPath.row].favoritesCount
        let resetFavoritesCount = isFavorite ? favoritesCount + 1 : favoritesCount - 1
        self.tweets[indexPath.row].setFavCount(resetFavoritesCount)
        cell.tweet = self.tweets[indexPath.row]
    }
}

// MARK: - TweetsCellDelegate

extension TweetsViewController: TweetsCellDelegate {
    func tweetsCell(_ cell: TweetsCell, didTapReply with: Tweet) {
        let replyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "replyVC") as! ReplyViewController
        replyVC.replyingToTweet = with
        replyVC.replyAction = {
            tweet in
            if let tweet = tweet {
                self.addTweetToTableView(tweet: tweet)
            }
        }
        present(replyVC, animated: true, completion: nil)
    }
    
    func tweetsCell(_ cell: TweetsCell, didTapRetwet with: Tweet, shouldRetweet: Bool) {
        let indexPath = tableView.indexPath(for: cell)!
        
        guard shouldRetweet else {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            TwitterClient.shared.retweet(id: with.id!, shouldUntweet: true) {
                success, error in
                MBProgressHUD.hide(for: self.view, animated: true)
                if success {
                    self.handleUpdatedRetwet(indexPath: indexPath, isRetweeted: false, cell: cell)
                } else {
                    print(error!.localizedDescription)
                }
            }
            return
        }
        
        let retweetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "retweetVC") as! RetweetViewController
        retweetVC.tweet = with
        retweetVC.retweetAction = {
            isRetweeted in
            self.handleUpdatedRetwet(indexPath: indexPath, isRetweeted: isRetweeted, cell: cell)
        }
        
        present(retweetVC, animated: false, completion: nil)
    }
    
    func tweetsCell(_ cell: TweetsCell, didTapFavorite with: Tweet, isFavorite: Bool) {
        let indexPath = tableView.indexPath(for: cell)!
        MBProgressHUD.showAdded(to: self.view, animated: true)
        TwitterClient.shared.changeLike(isLiked: isFavorite, id: with.id!) {
            success, error in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success {
                self.handleUpdatedFavorite(indexPath: indexPath, isFavorite: isFavorite, cell: cell)
            } else {
                print(error!.localizedDescription)
            }
        }
    }
}

// MARK: - TableView

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetsCell") as! TweetsCell
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        cell.delegate = self
        cell.isFavorited = favoriteTweets[indexPath.row] ?? false
        cell.isRetweeted = retweetedTweets[indexPath.row] ?? false
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
}
