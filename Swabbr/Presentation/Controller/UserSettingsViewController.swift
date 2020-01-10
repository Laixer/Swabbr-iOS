//
//  UserSettingsViewController.swift
//  Swabbr
//
//  Created by James Bal on 10-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
// swiftlint:disable force_cast

import UIKit
import Eureka

class UserSettingsViewController: FormViewController {
    
    private let controllerService = UserSettingsControllerService()
    
    private var userSettingsItem: UserSettingsItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Settings"
        
        form +++ Section()
            <<< SwitchRow("isPrivate") {
                $0.title = "Profile is private"
                $0.value = false
            }.onChange { [weak self](element) -> Void in
                self?.userSettingsItem?.isPrivate = element.value!
            }
            <<< PushRow<Int>("requestLimit") {
                $0.title = "Daily request limit"
                $0.options = [0, 1, 2, 3]
                $0.value = 3
            }.onChange { [unowned self](element) -> Void in
                guard let value = element.value else {
                    return
                }
                self.userSettingsItem?.dailyVlogRequestLimit = value
                }.onPresent({ (_, element) in
                    element.enableDeselection = false
                })
            <<< PushRow<Int>("followMode") {
                let modes = ["Never", "Always", "Manual"]
                $0.title = "Follow mode"
                $0.options = [0, 1, 2]
                $0.value = 0
                $0.displayValueFor = { (rowValue: Int?) in modes[rowValue!] }
            }.onChange { [unowned self](element) -> Void in
                guard let value = element.value else {
                    return
                }
                self.userSettingsItem?.followMode = value
            }.onPresent({ (_, element) in
                element.enableDeselection = false
            })
            <<< ButtonRow {
                $0.title = "Save"
                }.onCellSelection( {[weak self](_, _) -> Void in
                    self?.saveButtonClicked()
                })
            <<< ButtonRow {
                $0.title = "Logout"
                }
                .onCellSelection( {[weak self](_, _) -> Void in
                    self?.logoutButtonClicked()
                })
        controllerService.delegate = self
        controllerService.getUserSettings()
    }
    
    /**
     Will handle the userSettings value correctly.
     When the "save" button is pressed it will check for differences between the known values,
     if differences has been found it will send the new object tot he controller service other it will show an alert.
    */
    private func saveButtonClicked() {
        if controllerService.userSettings! == userSettingsItem! {
            return
        }
        controllerService.updateUserSettings(userSettingsItem: userSettingsItem!)
    }

    /**
     Will ask the controllerservice to handle the actions required to logout of the current account.
    */
    private func logoutButtonClicked() {
        controllerService.logout()
    }
}

// MARK: UserSettingsControllerServiceDelegate
extension UserSettingsViewController: UserSettingsViewControllerServiceDelegate {
    func retrievedUserSettings(_ sender: UserSettingsControllerService) {
        userSettingsItem = sender.userSettings
        
        let isPrivate: SwitchRow = form.rowBy(tag: "isPrivate")!
        let requestLimit: PushRow<Int> = form.rowBy(tag: "requestLimit")!
        let followMode: PushRow<Int> = form.rowBy(tag: "followMode")!
        isPrivate.value = userSettingsItem?.isPrivate
        requestLimit.value = userSettingsItem?.dailyVlogRequestLimit
        followMode.value = userSettingsItem?.followMode

        tableView.reloadData()
    }
    
    func updatedUserSettings(errorString: String?) {
        guard let errorString = errorString else {
            return
        }
        BasicErrorDialog.createAlert(message: errorString, context: self)
    }
    
    func logoutStatus(errorString: String?) {
        guard let errorString = errorString else {
            UserDefaults.standard.setAccessToken(value: nil)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window!.rootViewController = LoginViewController()
            return
        }
        BasicErrorDialog.createAlert(message: errorString, context: self)
    }
}
