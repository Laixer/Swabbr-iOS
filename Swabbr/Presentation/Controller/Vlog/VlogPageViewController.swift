//
//  VlogPageViewController.swift
//  Swabbr
//
//  Created by James Bal on 19-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
//  This handles all things related the vlog page
//  swiftlint:disable force_cast

import UIKit
import AVKit
import AVFoundation

class VlogPageViewController : UIViewController {
    
    private let player = AVPlayer(playerItem: nil)
    
    private let likesCountLabel = UILabel()
    private let viewsCountLabel = UILabel()
    private let reactionCountLabel = UILabel()
    private let isLiveLabel = UILabel()
    private let userProfileImageView = UIImageView()
    private let userUsernameLabel = UILabel()
    private let reactionButton = UIButton()
    
    private let playerView = UIView()
    
    private let containerView = UIView()
    
    private var reactionController: ReactionViewController?
    private let scrollView = UIScrollView()
    
    private let controllerService = VlogPageViewControllerService()
    
    let vlogId: String
    
    /**
     The initializer which accepts a Vlog as parameter.
     It will setup the view using the data contained in the Vlog.
     - parameter vlog: A string value representing the id of a vlog.
     */
    init(vlogId: String) {
        self.vlogId = vlogId
        super.init(nibName: nil, bundle: nil)
        controllerService.delegate = self
        controllerService.getVlog(vlogId: vlogId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        initElements()
        applyConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollView.isScrollEnabled = false
        if controllerService.vlog != nil {
            playPlayer()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        player.seek(to: CMTime(seconds: 0, preferredTimescale: 60))
        stopPlayer()
    }
    
    /**
     Run when we want to stop or pause the player.
     This function has also a parameter that is a boolean which indicate if we want to make a fully stop on the video or just want to pause to possibly resume later on.
    */
    private func stopPlayer() {
        player.pause()
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
     Run when we want to start the player.
     This function has also a parameter that is a boolean which indicate if we resume the video or if we will start the video for the first time.
     */
    private func playPlayer() {
        player.replaceCurrentItem(with: AVPlayerItem(url: URL(string: controllerService.vlog.vlogUrl)!))
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = view.bounds
        playerView.layer.addSublayer(playerLayer)
        player.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoEnd), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
}

// MARK: VlogPageViewControllerServiceDelegate
extension VlogPageViewController: VlogPageViewControllerServiceDelegate {
    func didRetrieveVlog(_ sender: VlogPageViewControllerService) {
        likesCountLabel.text = String(sender.vlog.vlogTotalLikes)
        viewsCountLabel.text = String(sender.vlog.vlogTotalViews)
        reactionCountLabel.text = String(sender.vlog.vlogTotalReactions)
        userUsernameLabel.text = sender.vlog.userUsername
        do {
            let url = URL(string: "https://cdn.mos.cms.futurecdn.net/yJaNqkw6JPf2QuXiYobcY3.jpg")
            let data = try Data(contentsOf: url!)
            userProfileImageView.image = UIImage(data: data)
        } catch {
            print(error)
        }
        if sender.vlog.vlogIsLive {
            containerView.addSubview(isLiveLabel)
            NSLayoutConstraint.activate([
                isLiveLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                isLiveLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
            ])
        }
        playPlayer()
    }
}
extension VlogPageViewController: BaseViewProtocol {
    internal func initElements() {
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height * 2)
        
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
        
        let singleReactionTap = UITapGestureRecognizer(target: self, action: #selector(clickedReactionLabel))
        reactionCountLabel.isUserInteractionEnabled = true
        reactionCountLabel.addGestureRecognizer(singleReactionTap)
        
        let singleVideoTap = UITapGestureRecognizer(target: self, action: #selector(clickedVideoToGoBackToFullscreen))
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(singleVideoTap)
        
        let loveItTap = UITapGestureRecognizer(target: self, action: #selector(tappedVideoToLoveIt))
        loveItTap.numberOfTapsRequired = 2
        containerView.addGestureRecognizer(loveItTap)
        
        isLiveLabel.text = "Live"
        isLiveLabel.backgroundColor = UIColor.red
        
        scrollView.frame = view.bounds
        containerView.frame = view.bounds
        
        view.addSubview(scrollView)
        containerView.addSubview(playerView)
        
        // add ui components to current view
        containerView.addSubview(likesCountLabel)
        containerView.addSubview(viewsCountLabel)
        containerView.addSubview(reactionCountLabel)
        containerView.addSubview(userProfileImageView)
        containerView.addSubview(userUsernameLabel)
        containerView.addSubview(reactionButton)
        
        scrollView.addSubview(containerView)
        reactionController = ReactionViewController(vlogId: vlogId)
        reactionController!.view.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: view.bounds.height)
        scrollView.addSubview(reactionController!.view)
        addChild(reactionController!)
        reactionController!.didMove(toParent: self)
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
            userUsernameLabel.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
            userUsernameLabel.leftAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leftAnchor),
            
            // userProfileImageView
            userProfileImageView.topAnchor.constraint(equalTo: userUsernameLabel.bottomAnchor),
            userProfileImageView.leftAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leftAnchor),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 100),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 100),
            
            // viewsCountLabel
            viewsCountLabel.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
            viewsCountLabel.leftAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leftAnchor),
            
            // likesCountLabel
            likesCountLabel.bottomAnchor.constraint(equalTo: viewsCountLabel.topAnchor),
            likesCountLabel.leftAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leftAnchor),
            
            // reactionCountLabel
            reactionCountLabel.bottomAnchor.constraint(equalTo: likesCountLabel.topAnchor),
            reactionCountLabel.leftAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leftAnchor),
            
            // reactionButton
            reactionButton.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
            reactionButton.leftAnchor.constraint(equalTo: likesCountLabel.rightAnchor, constant: 10)
            
        ])
    }
}

// MARK: Events
extension VlogPageViewController {
    
    /**
     Get run when the vlog has finished playing.
     This function makes sure that we can show the next vlog in the queue to the user.
     */
    @objc private func videoEnd() {
        guard let parent = parent else {
            return
        }
        
        guard parent.isKind(of: UIPageViewController.self) else {
            return
        }
        
        let parentPageViewController = (parent as! UIPageViewController).parent as? TimelineViewController
        parentPageViewController!.pageViewController.setViewControllers(
            [parentPageViewController!.pageViewController(parentPageViewController!.pageViewController, viewControllerAfter: self)!],
            direction: .forward, animated: true, completion: nil)
    }
    
    /**
     It will run when we recognize a click on the profile.
     This will push the current view to the profile of the clicked user.
     */
    @objc private func clickedProfilePicture() {
        stopPlayer()
        navigationController?.pushViewController(ProfileViewController(userId: controllerService.vlog.userId), animated: true)
    }
    
    /**
     This will handle all actions required to handle the click of the reaction button.
     */
    @objc private func clickedReactButton() {
        //present(VlogReactionViewController(vlog: vlog), animated: true, completion: nil)
    }
    
    /**
     Handle all actions required when the reaction label is pressed.
     */
    @objc private func clickedReactionLabel() {
        scrollView.isScrollEnabled = true
        scrollView.setContentOffset(CGPoint(x: 0, y: 400), animated: true)
    }
    
    /**
     Handle all actions required when the vlog is clicked, returns to fullscreen if reactions are visible.
     */
    @objc private func clickedVideoToGoBackToFullscreen() {
        guard scrollView.contentOffset.y > 0 else {
            return
        }
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        scrollView.isScrollEnabled = false
    }
    
    @objc private func tappedVideoToLoveIt() {
        controllerService.giveLoveIt(for: vlogId) { (error) in
            guard error == nil else {
                let alert = UIAlertController(title: "Error", message: error!, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            print("Liked")
        }
    }
}
