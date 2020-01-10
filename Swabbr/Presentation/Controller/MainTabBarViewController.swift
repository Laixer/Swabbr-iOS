//
//  MainTabBarViewController.swift
//  Swabbr
//
//  Created by James Bal on 07-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

class MainTabBarViewController: UITabBarController {
    
    private let timelineTab = TimelineViewController()
    private let accountTab = ProfileViewController()
    private let searchTab = SearchViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        self.viewControllers = [navigationSearchTab, navigationTimelineTab, navigationAccountTab]
        selectedIndex = 1
        
    }
    
    @objc func showSettings() {
        accountTab.navigationController?.pushViewController(UserSettingsViewController(), animated: true)
    }
    
}
