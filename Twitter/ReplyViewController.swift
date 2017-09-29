//
//  ReplyViewController.swift
//  Twitter
//
//  Created by Ali Mir on 9/27/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit
import MBProgressHUD

internal class ReplyViewController: UIViewController, UITextViewDelegate {
    
    // MARK: Outlets
    
    @IBOutlet private var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet private var replyTextView: UITextView!
    @IBOutlet private var currentUserProfileImageView: UIImageView!
    @IBOutlet private var replyingToLabel: UILabel!
    @IBOutlet private var textLimitCount: UIBarButtonItem!
    
    // MARK: Stored Properties
    
    internal var replyingToTweet: Tweet!
    internal var replyAction: ((Tweet?) -> Void)?
    
    // MARK: Computed Properties
    
    private var replyToUsers: [String] {
        var users = ["@\(replyingToTweet.user!.screenName!)"]
        if replyingToTweet.isRetweetedTweet {
            users.append("@\(replyingToTweet.retweetSourceUser!.screenName!)")
        }
        if let inReplyTo = replyingToTweet.inReplyToScreenName {
            users.append("@\(inReplyTo)")
        }
        return users
    }
    
    private var usersToReplyToString: String {
        return replyToUsers.joined(separator: " ")
    }
    
    private var initTextRemaining: Int {
        return 140 - usersToReplyToString.characters.count
    }
    
    private var remainingTextCount: Int = 0 {
        didSet {
            textLimitCount.title = "\(remainingTextCount)"
        }
    }
    
    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObservers()
        replyTextView.becomeFirstResponder()
        setupViews()
        remainingTextCount = initTextRemaining
    }
    
    // MARK: Views Setup
    
    private func setupViews() {
        setupOutlets()
    }
    
    private func setupOutlets() {
        if let userImageURL = User.currentUser?.profileURL {
            currentUserProfileImageView.setImageWith(userImageURL)
        }
        
        let replyingToScreenNames = replyToUsers.joined(separator: " ")
        
        
        replyingToLabel.text = "Replying to \(replyingToScreenNames)"
    }
    
    // MARK: Target-Action
    
    @IBAction private func onCancelTap(sender: AnyObject?) {
        dismissVC()
    }
    
    @IBAction private func onReplyTap(sender: AnyObject?) {
        guard !replyTextView.text.isEmpty && remainingTextCount > 0 else { return } // FIXME: Should notify user.
        
        let status = replyTextView.text!
        let tweetStatus = "\(usersToReplyToString) \(status)"
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
        TwitterClient.shared.post(tweet: tweetStatus, idForReply: replyingToTweet.id!) {
            tweet, success, error in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success {
                self.replyAction?(tweet)
                self.dismissVC()
            } else {
                print("\(error!.localizedDescription)") // MARK: Show something
            }
        }
    }
    
    // MARK: Helpers
    
    private func dismissVC() {
        hideKeyboard()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Keyboard Observation
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    }
    
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.bottomViewConstraint.constant = keyboardHeight
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MAKR: TextView delegate
    
    func textViewDidChange(_ textView: UITextView) {
        remainingTextCount = initTextRemaining - textView.text.characters.count
    }
    
}
