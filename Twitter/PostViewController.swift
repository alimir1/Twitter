//
//  PostViewController.swift
//  Twitter
//
//  Created by Ali Mir on 9/27/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit
import MBProgressHUD

internal class PostViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private var popupView: UIView!
    @IBOutlet private var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private var tweetTextView: UITextView!
    @IBOutlet private var usernameLabel: UILabel!
    
    // MARK: Stored Properties
    
    private var originalBottomConstraintConstant: CGFloat!
    
    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalBottomConstraintConstant = bottomConstraint.constant
        setupViews()
        addKeyboardObservers()
    }
    
    // MARK: Views Setup
    
    func setupViews() {
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        usernameLabel.text = "@\(User.currentUser?.screenName ?? "")"
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: Keyboard Observation
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.bottomConstraint.constant = keyboardHeight + 8
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard bottomConstraint.constant != originalBottomConstraintConstant else { return }
        self.bottomConstraint.constant = self.originalBottomConstraintConstant
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: Target-Action
    
    @IBAction private func onCancel(sender: UIButton?) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func onPostTweet(sender: UIButton?) {
        guard !tweetTextView.text.isEmpty else { return } // FIXME: display more meaningful message to user!
        MBProgressHUD.showAdded(to: view, animated: true)
        TwitterClient.shared.post(tweet: tweetTextView.text) {
            didSuccessfullyPost, potentialError in
            if didSuccessfullyPost {
                self.dismiss(animated: true, completion: nil)
            } else {
                // FIXME: Show nice error somewhere...
                print(potentialError!.localizedDescription)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

}
