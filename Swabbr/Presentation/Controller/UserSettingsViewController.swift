//
//  UserSettingsViewController.swift
//  Swabbr
//
//  Created by James Bal on 10-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import UIKit
import Eureka

class UserSettingsViewController: FormViewController {
    
    private let controllerService = UserSettingsControllerService()
    
    private var userSettingsItem: UserSettingsItem?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        controllerService.delegate = self
        controllerService.getUserSettings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section()
            <<< SwitchRow("isPrivate") {
                $0.title = "Profile is private"
                $0.value = false
            }.onChange { (element) -> Void in
                self.userSettingsItem?.isPrivate = element.value!
            }
            <<< PushRow<Int>("requestLimit") {
                $0.title = "Daily request limit"
                $0.options = [0, 1, 2, 3]
                $0.value = 3
            }.onChange { (element) -> Void in
                    self.userSettingsItem?.dailyVlogRequestLimit = element.value!
            }
            <<< PushRow<FollowMode>("followMode") {
                $0.title = "Follow mode"
                $0.options = FollowMode.allCases
                $0.value = FollowMode.manual
            }.onChange { (element) -> Void in
                    self.userSettingsItem?.followMode = element.value!
            }
            <<< ButtonRow {
                $0.title = "Save"
                }.onCellSelection( {(_, _) -> Void in
                    self.saveButtonClicked()
                })
    }
    
    /**
     Will handle the userSettings value correctly.
     When the "save" button is pressed it will check for differences between the known values,
     if differences has been found it will send the new object tot he controller service other it will show an alert.
    */
    private func saveButtonClicked() {
        // userSettings
        if controllerService.userSettings! == userSettingsItem! {
            // TODO: alert
            return
        }
        controllerService.updateUserSettings(userSettingsItem: userSettingsItem!)
    }
}

// MARK: UserSettingsControllerServiceDelegate
extension UserSettingsViewController: UserSettingsViewControllerServiceDelegate {
    func retrievedUserSettings(_ sender: UserSettingsControllerService) {
        userSettingsItem = sender.userSettings
        
        let isPrivate: SwitchRow = form.rowBy(tag: "isPrivate")!
        let requestLimit: PushRow<Int> = form.rowBy(tag: "requestLimit")!
        let followMode: PushRow<FollowMode> = form.rowBy(tag: "followMode")!
        isPrivate.value = userSettingsItem?.isPrivate
        requestLimit.value = userSettingsItem?.dailyVlogRequestLimit
        followMode.value = userSettingsItem?.followMode
        
        tableView.reloadData()
    }
}
