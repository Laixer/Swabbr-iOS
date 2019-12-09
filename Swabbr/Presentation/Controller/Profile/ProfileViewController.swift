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

    /**
     Initializes with a user value.
     It will fill up the view with the user information that is stored in the given object.
     - parameter user: An User object.
    */
    init(userId: Int) {
        super.init(nibName: nil, bundle: nil)
        controllerService.delegate = self
        controllerService.getUser(userId: userId)
        controllerService.getVlogs(userId: userId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.white
        
        initElements()
        applyConstraints()
        
    }
    
    @objc private func showFollowers() {
        navigationController?.pushViewController(ProfileCollectionOverviewViewController(followersOwnerId: controllerService.user.id), animated: true)
    }
    
    @objc private func showFollowing() {
//        navigationController?.pushViewController(ProfileCollectionOverviewViewController(followingOwnerId: user.id), animated: true)
    }
    
    /**
     Add the vlog overview controller to this view.
     Be sure that memory leaks are not possible and the view is correctly added.
    */
    private func addProfileVlogOverviewController() {
        
        if profileCollectionOverviewController != nil {
            return
        }
        
        profileCollectionOverviewController = ProfileCollectionOverviewViewController(vlogOwnerId: controllerService.user.id)
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
                followButton.leftAnchor.constraint(equalTo: view.leftAnchor)
            ])
        }
    }
    
    func didRetrieveVlogs(_ sender: ProfileViewControllerService) {
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
        
        followButton.setTitle("Follow", for: .normal)
        followButton.tintColor = UIColor.white
        followButton.backgroundColor = UIColor.black
        
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
