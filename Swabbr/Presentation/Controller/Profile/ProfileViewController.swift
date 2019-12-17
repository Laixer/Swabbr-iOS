//
//  ProfileViewController.swift
//  Swabbr
//
//  Created by James Bal on 18-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController : UIViewController {
    
    private let profileImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let countVlogsLabel = UILabel()
    private let countFollowersLabel = UILabel()
    private let countFollowingLabel = UILabel()
    private var followButton = UIButton()
    private let updateProfileButton = UIButton()
    
    private var isCurrentUser = false
    
    private var profileCollectionOverviewController: ProfileCollectionOverviewViewController?
    
    let controllerService = ProfileViewControllerService()
    private let userId: String

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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.white
        
        initElements()
        applyConstraints()
        
    @objc private func refresh() {
        controllerService.getUser(userId: userId)
        controllerService.getFollowStatus(userId: userId)
    }
    
    /**
     Show the collectionviewcontroller with the given user id for followers
     */
    @objc private func showFollowers() {
        navigationController?.pushViewController(ProfileCollectionOverviewViewController(followersOwnerId: userId), animated: true)
    }
    
    /**
     Show the collectionviewcontroller with the given user id for the following users
    */
    @objc private func showFollowing() {
        navigationController?.pushViewController(ProfileCollectionOverviewViewController(followingOwnerId: userId), animated: true)
    }
    
    /**
     Perform the correct action when button is pressed on the follow button.
     The use case can differ dependent on the follow state.
    */
    @objc private func clickedFollowButton() {
        
    }
    
    /**
     Add the vlog overview controller to this view.
     Be sure that memory leaks are not possible and the view is correctly added.
    */
    private func addProfileVlogOverviewController() {
        
        if profileCollectionOverviewController != nil {
            return
        }
        
        profileCollectionOverviewController = ProfileCollectionOverviewViewController(vlogOwnerId: userId)
        view.addSubview(profileCollectionOverviewController!.view)
        profileCollectionOverviewController!.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileCollectionOverviewController!.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            profileCollectionOverviewController!.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            profileCollectionOverviewController!.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if isCurrentUser {
            
            NSLayoutConstraint.activate([
                profileCollectionOverviewController!.view.topAnchor.constraint(equalTo: updateProfileButton.bottomAnchor)
            ])
            
        } else {
            
            NSLayoutConstraint.activate([
                profileCollectionOverviewController!.view.topAnchor.constraint(equalTo: followButton.bottomAnchor)
            ])
            
        }
        
        addChild(profileCollectionOverviewController!)
        profileCollectionOverviewController!.didMove(toParent: self)
        
    }
    
}

// MARK: ProfileViewControllerServiceDelegate
extension ProfileViewController: ProfileViewControllerServiceDelegate {
    func setFollowStatus(_ followStatus: String) {
        switch followStatus {
        case "accepted": followButton.setTitle("Unfollow", for: .normal)
        case "declined": followButton.setTitle("Rejected", for: .normal)
        default: followButton.setTitle("Follow", for: .normal)
        }
    }
    
    func didRetrieveUser(_ sender: ProfileViewControllerService) {
        usernameLabel.text = sender.user.username
        countVlogsLabel.text = String.init(format: "Vlog total: %d", sender.user.totalVlogs)
        countFollowersLabel.text = String.init(format: "followers: %d", sender.user.totalFollowers)
        countFollowingLabel.text = String.init(format: "following: %d", sender.user.totalFollowing)
        if UserDefaults.standard.getUserId() == sender.user.id {
            isCurrentUser = true
            view.addSubview(updateProfileButton)
            updateProfileButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                updateProfileButton.topAnchor.constraint(equalTo: countFollowingLabel.bottomAnchor),
                updateProfileButton.leftAnchor.constraint(equalTo: view.leftAnchor)
            ])
        } else {
            view.addSubview(followButton)
            followButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                followButton.topAnchor.constraint(equalTo: countFollowingLabel.bottomAnchor),
                followButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                followButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
            ])
        }
        addProfileVlogOverviewController()
    }
}

// MARK: BaseViewProtocol
extension ProfileViewController: BaseViewProtocol {
    internal func initElements() {
        
        view.addSubview(usernameLabel)
        view.addSubview(countVlogsLabel)
        view.addSubview(countFollowersLabel)
        view.addSubview(countFollowingLabel)
        
        updateProfileButton.setTitle("Update", for: .normal)
        updateProfileButton.tintColor = UIColor.white
        updateProfileButton.backgroundColor = UIColor.black
        
        followButton.tintColor = UIColor.white
        followButton.backgroundColor = UIColor.black
        
        followButton.addTarget(self, action: #selector(clickedFollowButton), for: .touchUpInside)
        
        let tapFollowersGesture = UITapGestureRecognizer(target: self, action: #selector(showFollowers))
        countFollowersLabel.isUserInteractionEnabled = true
        countFollowersLabel.addGestureRecognizer(tapFollowersGesture)
        
        let tapFollowingGesture = UITapGestureRecognizer(target: self, action: #selector(showFollowing))
        countFollowingLabel.isUserInteractionEnabled = true
        countFollowingLabel.addGestureRecognizer(tapFollowingGesture)
    }
    
    internal func applyConstraints() {
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        countVlogsLabel.translatesAutoresizingMaskIntoConstraints = false
        countFollowersLabel.translatesAutoresizingMaskIntoConstraints = false
        countFollowingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // usernameLabel
            usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            //countVlogsLabel
            countVlogsLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor),
            countVlogsLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            // countFollowersLabel
            countFollowersLabel.topAnchor.constraint(equalTo: countVlogsLabel.bottomAnchor),
            countFollowersLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            // countFollowingLabel
            countFollowingLabel.topAnchor.constraint(equalTo: countFollowersLabel.bottomAnchor, constant: 20),
            countFollowingLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            
        ])
        
    }
}
