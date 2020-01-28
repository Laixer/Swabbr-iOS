//
//  MainTabBarViewController.swift
//  Swabbr
//
//  Created by James Bal on 07-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

import UserNotifications

class MainTabBarViewController: UITabBarController {
    
    private let timelineTab = TimelineViewController()
    private let accountTab = ProfileViewController()
    private let searchTab = SearchViewController()
    private let followRequestTab = FollowRequestViewController()
    
    override func viewDidLoad() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification(_:)),
                                               name: Notification.Name(rawValue: "notif"), object: nil)
        
        timelineTab.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 1)
        timelineTab.tabBarItem.title = "Timeline"
        let navigationTimelineTab = UINavigationController(rootViewController: timelineTab)
        
        accountTab.navigationItem.title = "Account"
        accountTab.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showSettings))
        accountTab.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
        accountTab.tabBarItem.title = "Account"
        let navigationAccountTab = UINavigationController(rootViewController: accountTab)
        
        searchTab.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 3)
        let navigationSearchTab = UINavigationController(rootViewController: searchTab)
        
        followRequestTab.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 4)
        
        self.viewControllers = [navigationSearchTab, navigationTimelineTab, navigationAccountTab]
        selectedIndex = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func showSettings() {
        accountTab.navigationController?.pushViewController(UserSettingsViewController(), animated: true)
    }
    
    @objc func handleNotification(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            
            #if DEBUG
            print(userInfo)
            #endif

            let jsonData = try? JSONSerialization.data(withJSONObject: userInfo, options: [])
            
            guard let notificationObject = try? JSONDecoder().decode(Payload<SNotification>.self, from: jsonData!) else {
                return
            }
            
            switch notificationObject.innerData.clickAction {
            case .followedProfileLive:
                selectedIndex = 1
                let object = (notificationObject.innerData.object as? ObjectId)!
                timelineTab.showSpecificVlog(id: object.id)
            case .inactiveUserMotivate:
                selectedIndex = 1
            case .inactiveUnwatchedVlogs:
                selectedIndex = 2
                accountTab.showFollowing()
            case .inactiveVlogRecordRequest:
                // timelineviewcontroller
                break
            case .vlogGainedLikes:
                break
            case .vlogNewReaction:
                break
            case .vlogRecordRequest:
                let streamCreds = (notificationObject.innerData.object as? SLivestreamNotification)!
                self.show(VlogStreamViewController(creds:
                    (streamCreds.id,
                     streamCreds.hostAddress,
                     streamCreds.appName,
                     streamCreds.streamName,
                     streamCreds.port,
                     streamCreds.username,
                     streamCreds.password)
                    ), sender: nil)
            }
        }
        
    }
    
}
