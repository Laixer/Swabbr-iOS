//
//  ProfileViewController.swift
//  Swabbr
//
//  Created by James Bal on 18-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let profileImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let countVlogsLabel = UILabel()
    private let countFollowersLabel = UILabel()
    private let countFollowingLabel = UILabel()
    private let profileButton = UIButton()
    
    private var isCurrentUser = false
    private var refreshing = false
    
    private var profileCollectionOverviewController: ProfileCollectionOverviewViewController?
    
    let controllerService = ProfileViewControllerService()
    
    private var userId: String?

    /**
     Initializes with a user value.
     It will fill up the view with the user information that is stored in the given object.
     - parameter user: An User object.
    */
    init(userId: String) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
        controllerService.delegate = self
        controllerService.getUser(userId: userId)
        controllerService.getFollowStatus(userId: userId)
    }
    
    /**
     Initializes the view for the current user.
    */
    init() {
        isCurrentUser = true
        super.init(nibName: nil, bundle: nil)
        controllerService.delegate = self
        controllerService.getCurrentUser(refresh: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.white
        
        initElements()
        applyConstraints()
        
    }
    
    /**
     Function retrieves all data that needs to be refreshed
    */
    @objc private func refresh() {
        controllerService.getUser(userId: userId!, refresh: true)
        if !isCurrentUser {
            controllerService.getFollowStatus(userId: userId!, refresh: true)
        }
        scrollView.refreshControl?.endRefreshing()
    }
    
    /**
     Show the collectionviewcontroller with the given user id for followers
     */
    @objc private func showFollowers() {
        navigationController?.pushViewController(ProfileCollectionOverviewViewController(followersOwnerId: userId!), animated: true)
    }
    
    /**
     Show the collectionviewcontroller with the given user id for the following users
    */
    @objc internal func showFollowing() {
        navigationController?.pushViewController(ProfileCollectionOverviewViewController(followingOwnerId: userId!), animated: true)
    }
    
    /**
     Perform the correct action when button is pressed on the follow button.
     The use case can differ dependent on the follow state.
    */
    @objc private func clickedFollowButton() {
        profileButton.isEnabled = false
        guard let followRequest = controllerService.followRequest else {
            controllerService.createFollowRequest(userId: userId!)
            return
        }
        switch followRequest.status {
        case 0:
            controllerService.removeFollowRequest()
        case 1:
            controllerService.unfollowUser(withId: userId!)
        default:
            controllerService.createFollowRequest(userId: userId!)
        }
    }
    
    /**
     Add the vlog overview controller to this view.
     Be sure that memory leaks are not possible and the view is correctly added.
    */
    private func addProfileVlogOverviewController() {
        
        if let profileCollectionOverviewController = profileCollectionOverviewController {
            profileCollectionOverviewController.loadData()
            return
        }
        
        profileCollectionOverviewController = ProfileCollectionOverviewViewController(vlogOwnerId: userId!)
        contentView.addSubview(profileCollectionOverviewController!.view)

        profileCollectionOverviewController!.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileCollectionOverviewController!.view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            profileCollectionOverviewController!.view.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            profileCollectionOverviewController!.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            profileCollectionOverviewController!.view.topAnchor.constraint(equalTo: profileButton.bottomAnchor)
        ])
        
        addChild(profileCollectionOverviewController!)
        profileCollectionOverviewController!.didMove(toParent: self)
        
    }
    
}

// MARK: ProfileViewControllerServiceDelegate
extension ProfileViewController: ProfileViewControllerServiceDelegate {
    
    func performedFollowRequestCall(_ errorString: String?) {
        profileButton.isEnabled = true
        guard let errorString = errorString else {
            profileButton.setTitle("Sent", for: .normal)
            return
        }
        BasicErrorDialog.createAlert(message: errorString, context: self)
    }
    
    func setFollowStatus(_ followStatus: Int?) {
        switch followStatus {
        case 0: profileButton.setTitle("Pending", for: .normal)
        case 1: profileButton.setTitle("Unfollow", for: .normal)
        case 2: profileButton.setTitle("Declined", for: .normal)
        default: profileButton.setTitle("Follow", for: .normal)
        }
        profileButton.isEnabled = true
    }
    
    func didRetrieveUser(_ sender: ProfileViewControllerService) {
        
        guard let user = sender.user else {
            BasicErrorDialog.createAlert(message: "Unknown user", context: self)
            return
        }
        
        if isCurrentUser {
            userId = user.id
        }
        
        usernameLabel.text = user.username
        countVlogsLabel.text = String.init(format: "Vlog total: %d", user.totalVlogs)
        countFollowersLabel.text = String.init(format: "followers: %d", user.totalFollowers)
        countFollowingLabel.text = String.init(format: "following: %d", user.totalFollowing)
        profileImageView.imageFromUrl(user.profileImageUrl)
        
        if !refreshing {
        
            if isCurrentUser {
                profileButton.isEnabled = true
            } else {
                profileButton.addTarget(self, action: #selector(clickedFollowButton), for: .touchUpInside)
            }
            
            refreshing = true
            
        }
    }
}

// MARK: BaseViewProtocol
extension ProfileViewController: BaseViewProtocol {
    internal func initElements() {
        
        contentView.addSubview(usernameLabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(countVlogsLabel)
        contentView.addSubview(countFollowersLabel)
        contentView.addSubview(countFollowingLabel)
        contentView.addSubview(profileButton)
        
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        profileButton.setTitle("Update", for: .normal)
        profileButton.tintColor = UIColor.white
        profileButton.backgroundColor = UIColor.black
        profileButton.isEnabled = false
        
        let tapFollowersGesture = UITapGestureRecognizer(target: self, action: #selector(showFollowers))
        countFollowersLabel.isUserInteractionEnabled = true
        countFollowersLabel.addGestureRecognizer(tapFollowersGesture)
        
        let tapFollowingGesture = UITapGestureRecognizer(target: self, action: #selector(showFollowing))
        countFollowingLabel.isUserInteractionEnabled = true
        countFollowingLabel.addGestureRecognizer(tapFollowingGesture)
        
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    internal func applyConstraints() {
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        countVlogsLabel.translatesAutoresizingMaskIntoConstraints = false
        countFollowersLabel.translatesAutoresizingMaskIntoConstraints = false
        countFollowingLabel.translatesAutoresizingMaskIntoConstraints = false
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
            // profileImageView
            profileImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            profileImageView.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150),

            // usernameLabel
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            usernameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),

            //countVlogsLabel
            countVlogsLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor),
            countVlogsLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),

            // countFollowersLabel
            countFollowersLabel.topAnchor.constraint(equalTo: countVlogsLabel.bottomAnchor),
            countFollowersLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),

            // countFollowingLabel
            countFollowingLabel.topAnchor.constraint(equalTo: countFollowersLabel.bottomAnchor, constant: 20),
            countFollowingLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            
            // profileButton
            profileButton.topAnchor.constraint(equalTo: countFollowingLabel.bottomAnchor),
            profileButton.leftAnchor.constraint(equalTo: contentView.leftAnchor)
            
        ])
        
        addProfileVlogOverviewController()
        
    }
}
