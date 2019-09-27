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

class VlogPageViewController : UIViewController {
    
    private let likesLabel = UILabel()
    private let viewsLabel = UILabel()
    private let isLiveLabel = UILabel()
    private let userProfileImageView = UIImageView()
    private let userUsernameLabel = UILabel()
    
    let player = AVPlayer(url: URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!)
    
    private let vlog: Vlog
    
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
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        
        // add ui components to current view
        view.addSubview(likesLabel)
        view.addSubview(viewsLabel)
        view.addSubview(userProfileImageView)
        view.addSubview(userUsernameLabel)
        
        setConstraints()
        
        // add tap event on imageview
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(clickedProfilePicture))
        userProfileImageView.isUserInteractionEnabled = true
        userProfileImageView.addGestureRecognizer(singleTap)
    }
    
    /**
     Makes sure that all the UI elements on the screen are set up correctly.
     This means that basic configurations and correct data needs to be set up.
    */
    private func initElements() {
        userProfileImageView.contentMode = .scaleAspectFill
        userProfileImageView.clipsToBounds = true
        
        // set values
        likesLabel.text = String(vlog.totalLikes)
        viewsLabel.text = String(vlog.totalViews)
        userUsernameLabel.text = vlog.owner!.username
        do {
            let url = URL(string: "https://cdn.mos.cms.futurecdn.net/yJaNqkw6JPf2QuXiYobcY3.jpg")
            let data = try Data(contentsOf: url!)
            userProfileImageView.image = UIImage(data: data)
        } catch {
            print(error)
        }
    }
    
    /**
     Handle the constraints.
     It is responsible to locate all the UI elements correctly.
    */
    private func setConstraints() {
        // disable auto constraint to override with given constraints
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        userUsernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            // likesLabel
            likesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            likesLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            // viewsLabel
            viewsLabel.topAnchor.constraint(equalTo: likesLabel.bottomAnchor),
            viewsLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if player.currentTime() > CMTime(seconds: 0, preferredTimescale: 60) {
            return
        }
        // add observer so we know when the vlog has finished
        NotificationCenter.default.addObserver(self, selector: #selector(videoEnd), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        player.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // remove observer so we dont get duplicates
        NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        player.pause()
        player.seek(to: CMTime(seconds: 0, preferredTimescale: 60))
    }
    
    /**
     Get run when the vlog has finished playing.
     This function makes sure that we can show the next vlog in the queue to the user.
     - parameter notification: A Notification object.
    */
    @objc func videoEnd(notification: Notification){
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
    @objc func clickedProfilePicture() {
        navigationController?.pushViewController(ProfileViewController(user: vlog.owner!), animated: true)
    }
    
}
