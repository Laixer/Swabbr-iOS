//
//  VlogPageViewController.swift
//  Swabbr
//
//  Created by James Bal on 19-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
//  This handles all things related the vlog page

import UIKit
import AVKit
import AVFoundation

class VlogPageViewController : UIViewController, BaseViewProtocol {
    
    private let likesCountLabel = UILabel()
    private let viewsCountLabel = UILabel()
    private let reactionCountLabel = UILabel()
    private let isLiveLabel = UILabel()
    private let userProfileImageView = UIImageView()
    private let userUsernameLabel = UILabel()
    private let reactionButton = UIButton()
    
    private let player = AVPlayer(url: URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!)
    
    private let vlog: Vlog
    
    private let playerView = AVPlayerViewController()
    private var reactionController: ReactionViewController?
    
    /**
     The initializer which accepts a Vlog as parameter.
     It will setup the view using the data contained in the Vlog.
     - parameter vlog: A vlog object.
    */
    init(vlog: Vlog) {
        self.vlog = vlog
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = String(vlog.id)
        view.backgroundColor = UIColor.white
        
        initElements()
        applyConstraints()
    }
    
    internal func initElements() {
        userProfileImageView.contentMode = .scaleAspectFill
        userProfileImageView.clipsToBounds = true
        
        // add tap event on imageview
        let singleProfileTap = UITapGestureRecognizer(target: self, action: #selector(clickedProfilePicture))
        userProfileImageView.isUserInteractionEnabled = true
        userProfileImageView.addGestureRecognizer(singleProfileTap)
        
        reactionButton.setTitle("React", for: .normal)
        reactionButton.tintColor = UIColor.white
        reactionButton.backgroundColor = UIColor.black
        reactionButton.addTarget(self, action: #selector(clickedReactButton), for: .touchUpInside)
        
        // set values
        likesCountLabel.text = String(vlog.totalLikes)
        viewsCountLabel.text = String(vlog.totalViews)
        reactionCountLabel.text = String(vlog.totalReactions)
        let singleReactionTap = UITapGestureRecognizer(target: self, action: #selector(clickedReactionLabel))
        reactionCountLabel.isUserInteractionEnabled = true
        reactionCountLabel.addGestureRecognizer(singleReactionTap)
        
        let singleVideoTap = UITapGestureRecognizer(target: self, action: #selector(clickedVideoToGoBackToFullscreen))
        playerView.view.isUserInteractionEnabled = true
        playerView.view.addGestureRecognizer(singleVideoTap)
        
        userUsernameLabel.text = vlog.owner!.username
        do {
            let url = URL(string: "https://cdn.mos.cms.futurecdn.net/yJaNqkw6JPf2QuXiYobcY3.jpg")
            let data = try Data(contentsOf: url!)
            userProfileImageView.image = UIImage(data: data)
        } catch {
            print(error)
        }
        isLiveLabel.text = "Live"
        isLiveLabel.backgroundColor = UIColor.red
        
        playerView.player = player
        playerView.view.frame = view.bounds
        playerView.showsPlaybackControls = false
        playerView.videoGravity = .resizeAspectFill
        
        view.addSubview(playerView.view)
        
        // add ui components to current view
        view.addSubview(likesCountLabel)
        view.addSubview(viewsCountLabel)
        view.addSubview(reactionCountLabel)
        view.addSubview(userProfileImageView)
        view.addSubview(userUsernameLabel)
        view.addSubview(reactionButton)
        if vlog.isLive {
            view.addSubview(isLiveLabel)
        }
    }

    internal func applyConstraints() {
        // disable auto constraint to override with given constraints
        likesCountLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        reactionCountLabel.translatesAutoresizingMaskIntoConstraints = false
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        userUsernameLabel.translatesAutoresizingMaskIntoConstraints = false
        isLiveLabel.translatesAutoresizingMaskIntoConstraints = false
        reactionButton.translatesAutoresizingMaskIntoConstraints = false
        
        // apply constraints
        NSLayoutConstraint.activate([
            
            // userUsernameLabel
            userUsernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userUsernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            // userProfileImageView
            userProfileImageView.topAnchor.constraint(equalTo: userUsernameLabel.bottomAnchor),
            userProfileImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 100),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 100),
            
            // likesCountLabel
            likesCountLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            likesCountLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            // viewsCountLabel
            viewsCountLabel.topAnchor.constraint(equalTo: likesCountLabel.bottomAnchor),
            viewsCountLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            // reactionCountLabel
            reactionCountLabel.bottomAnchor.constraint(equalTo: likesCountLabel.topAnchor),
            reactionCountLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            // reactionButton
            reactionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            reactionButton.leftAnchor.constraint(equalTo: likesCountLabel.rightAnchor, constant: 10),
            
        ])
        
        if vlog.isLive {
            NSLayoutConstraint.activate([
                isLiveLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                isLiveLabel.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if player.currentTime() > CMTime(seconds: 0, preferredTimescale: 60) {
            return
        }
        playPlayer(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stopPlayer(true)
    }
    
    /**
     Get run when the vlog has finished playing.
     This function makes sure that we can show the next vlog in the queue to the user.
     - parameter notification: A Notification object.
    */
    @objc private func videoEnd(notification: Notification){
        guard let parent = parent else {
            return
        }
        
        if parent.isKind(of: TimelineViewController.self){
            let pageViewController = parent as? TimelineViewController
            pageViewController!.setViewControllers([pageViewController!.pageViewController(pageViewController!, viewControllerAfter: self)!], direction: .forward, animated: true, completion: nil)
        } else {
            // TODO: handle error correctly
            print("error")
        }
    }
    
    /**
     It will run when we recognize a click on the profile.
     This will push the current view to the profile of the clicked user.
    */
    @objc private func clickedProfilePicture() {
        stopPlayer(true)
        navigationController?.pushViewController(ProfileViewController(user: vlog.owner!), animated: true)
    }
    
    /**
     This will handle all actions required to handle the click of the reation button.
    */
    @objc private func clickedReactButton() {
    }
    
    /**
     Handle all actions required when the reaction label is pressed.
    */
    @objc private func clickedReactionLabel() {
        playerView.view.frame = CGRect(x: 0, y: -playerView.view.bounds.midY, width: playerView.view.bounds.maxX, height: playerView.view.bounds.maxY)
        addReactionViewController()
    }
    
    /**
     Handle all actions required when the vlog is clicked, returns to fullscreen if reactions are visible.
    */
    @objc private func clickedVideoToGoBackToFullscreen() {
        removeReactionViewController()
    }
    
    /**
     When the react button has been pressed this function will run.
     The function will prepare the ReactionViewController to be shown in this current viewcontroller.
     This will only show the data coming from the ReactionViewController, this controller will not be responsible for function calls regarding the reactions.
    */
    private func addReactionViewController() {
        // prevent possible double press
        if reactionController != nil {
            return
        }
        
        stopPlayer(false)

        reactionController = ReactionViewController(vlogId: vlog.id)
        view.addSubview(reactionController!.view)
        reactionController!.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            reactionController!.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            reactionController!.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            reactionController!.view.topAnchor.constraint(equalTo: view.topAnchor, constant: playerView.view.bounds.midY),
            reactionController!.view.heightAnchor.constraint(equalToConstant: playerView.view.bounds.midY)
        ])
        addChild(reactionController!)
        reactionController!.didMove(toParent: self)
        
    }
    
    /**
     Handles the removal of the reaction view controller.
     It will ensure that the child controller has been released and prevent memory leaks.
    */
    private func removeReactionViewController() {
        if reactionController == nil {
            return
        }
        
        playPlayer(false)
        
        playerView.view.frame = CGRect(x: 0, y: 0, width: playerView.view.bounds.maxX, height: playerView.view.bounds.maxY)
        reactionController!.view.removeFromSuperview()
        reactionController!.removeFromParent()
        reactionController = nil
    }
    
    /**
     Run when we want to stop or pause the player.
     This function has also a parameter that is a boolean which indicate if we want to make a fully stop on the video or just want to pause to possibly resume later on.
     - parameter explicit: A boolean which when set to true will hard stop the player, which means the player will be fully stopped and observers abserving the player will be removed.
    */
    private func stopPlayer(_ explicit: Bool) {
        player.pause()
        
        if explicit {
            player.seek(to: CMTime(seconds: 0, preferredTimescale: 60))
            // remove observer so we dont get duplicates
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    /**
     Run when we want to start the player.
     This function has also a parameter that is a boolean which indicate if we resume the video or if we will start the video for the first time.
     - parameter explicit: A boolean which when set to true will imply that the video has never been run before and thusfor set an observer on the player.
     */
    private func playPlayer(_ explicit: Bool) {
        if explicit {
            // add observer so we know when the vlog has finished
            NotificationCenter.default.addObserver(self, selector: #selector(videoEnd), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        }
        player.play()
    }
    
}
