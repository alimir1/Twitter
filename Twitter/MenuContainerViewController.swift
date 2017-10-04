//
//  MenuContainerViewController.swift
//  Twitter
//
//  Created by Ali Mir on 10/3/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

// MARK: - MenuContainerViewController

internal class MenuContainerViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var menuView: UIView!
    @IBOutlet private var contentViewLeadingConstraint: NSLayoutConstraint!
    
    // MARK: Stored Properties
    
    private var originalContentViewLeadingConstraintConstant: CGFloat!
    private var contentViewPanGestureRecognizer: UIPanGestureRecognizer!
    private var menuViewController: MenuViewController!
    
    // MARK: Property Observers
    
    internal var contentViewController: UIViewController! {
        didSet(oldVC) {
            
            UIView.animate(withDuration: 0.3) {
                self.contentViewLeadingConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
            
            if oldVC != nil {
                removeViewController(oldVC)
            }
            
            addViewController(contentViewController, to: contentView)
            
            
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onContentViewPan(sender:)))
        contentView.addGestureRecognizer(contentViewPanGestureRecognizer)
        menuViewController = MenuViewController()
        menuViewController.containerVC = self
        menuView.addSubview(menuViewController.view)
    }
    
    // MARK: Target-action
    
    @objc private func onContentViewPan(sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        switch sender.state {
        case .began:
            originalContentViewLeadingConstraintConstant = contentViewLeadingConstraint.constant
        case .changed:
            if velocity.x < 0 {
                // Prevent right side opening
                if originalContentViewLeadingConstraintConstant + translation.x < 0 {
                    break
                }
            }
            contentViewLeadingConstraint.constant = originalContentViewLeadingConstraintConstant + translation.x
        case .ended:
            UIView.animate(withDuration: 0.3) {
                if velocity.x > 0 {
                    self.contentViewLeadingConstraint.constant = self.view.frame.width / 2
                } else {
                    self.contentViewLeadingConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            }
        default:
            break
        }
    }
    
    // MAKR: Helpers
    
    private func addViewController(_ viewController: UIViewController, to view: UIView) {
        addChildViewController(viewController)
        viewController.view.frame = view.frame
        view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }
    
    private func removeViewController(_ viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
}

// MARK: - MenuViewController

fileprivate class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Stored Properties
    
    private var tableView: UITableView!
    internal var containerVC: MenuContainerViewController!
    
    // MARK: Computed Properties
    
    private lazy var viewControllers: [UIViewController] = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // HomeNavVC
        let homeNavVC = storyboard.instantiateViewController(withIdentifier: "tweetsNavCtrl") as! UINavigationController
        let homeVC = homeNavVC.topViewController as! TweetsViewController
        homeNavVC.title = "Home"
        homeVC.title = "Home"
        homeVC.endpoint = .homeTimeline
        
        // MentionsNavVC
        let mentionsNavVC = storyboard.instantiateViewController(withIdentifier: "tweetsNavCtrl") as! UINavigationController
        let mentionsVC = mentionsNavVC.topViewController as! TweetsViewController
        mentionsNavVC.title = "Mentions"
        mentionsVC.title = "Mentions"
        mentionsVC.endpoint = .mentionsTimeline
        
        // UserNavVC
        let userNavVC = storyboard.instantiateViewController(withIdentifier: "tweetsNavCtrl") as! UINavigationController
        let userVC = userNavVC.topViewController as! TweetsViewController
        userNavVC.title = "Profile"
        userVC.title = User.currentUser?.name ?? "Profile"
        userVC.endpoint = .userTimeLine
        userVC.displayUser = User.currentUser
        
        return [homeNavVC, mentionsNavVC, userNavVC]
    }()
    
    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.frame)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        containerVC.contentViewController = viewControllers[0]
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    // MARK: TableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        containerVC.contentViewController = viewControllers[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell")!
        let vc = viewControllers[indexPath.row]
        cell.textLabel?.text = vc.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
}
