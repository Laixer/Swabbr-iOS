//
//  UserSettingsViewController.swift
//  Swabbr
//
//  Created by James Bal on 10-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import UIKit

class UserSettingsViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero)
    
    private let vlogRequestLimitInput = UITextField(frame: .zero)
    private let followModeSelect = UIPickerView(frame: .zero )
    
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
        
        tableView.dataSource = self
        tableView.delegate = self
        
        initElements()
        applyConstraints()
    }

    /**
     A callback which will be used by the other connected tables.
     - parameter userSettings: The usersettingsitem which will be used to replace the current userSettings value.
    */
    func updateUserSettings(userSettings: UserSettingsItem) {
        self.userSettingsItem = userSettings
        tableView.reloadData()
    }
    
    /**
     Setting the correct private value when the switch has been pressed.
     - parameter sender: An UISwitch object.
    */
    @objc private func switchPressed(sender: UISwitch) {
        userSettingsItem!.isPrivate  = sender.isOn
    }
    
    /**
     Will handle the userSettings value correctly.
     When the "save" button is pressed it will check for differences between the known values,
     if differences has been found it will send the new object tot he controller service other it will show an alert.
    */
    @objc private func saveButtonClicked() {
        // userSettings
        if controllerService.userSettings! == userSettingsItem! {
            // TODO: alert
            print("Hetzelfde")
            return
        }
        controllerService.updateUserSettings(userSettingsItem: userSettingsItem!)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension UserSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
        guard let userSettingsItem = userSettingsItem else {
            return cell
        }
        if indexPath.row == 0 {
            cell.selectionStyle = .none
            cell.textLabel?.text = "Profile is private"
            let uiSwitch = UISwitch()
            uiSwitch.setOn(userSettingsItem.isPrivate, animated: true)
            uiSwitch.addTarget(self, action: #selector(switchPressed), for: .valueChanged)
            cell.accessoryView = uiSwitch
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Daily request limit"
            cell.detailTextLabel?.text = String(userSettingsItem.dailyVlogRequestLimit)
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "Follow mode"
            cell.detailTextLabel?.text = userSettingsItem.followMode.stringCode
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != 0 else {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            let vc = HelperTable(dailyRequestLimit: userSettingsItem!)
            vc.mainViewController = self
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            let vc = HelperTable(followMode: userSettingsItem!)
            vc.mainViewController = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let tableFooterView = UIView(frame: .zero)
        let saveButton = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        saveButton.setTitle("Save", for: .normal)
        saveButton.center = tableFooterView.center
        saveButton.setTitleColor(UIColor.blue, for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        tableFooterView.addSubview(saveButton)
        return tableFooterView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
}

// MARK: UserSettingsControllerServiceDelegate
extension UserSettingsViewController: UserSettingsViewControllerServiceDelegate {
    func retrievedUserSettings(_ sender: UserSettingsControllerService) {
        userSettingsItem = sender.userSettings
        tableView.reloadData()
    }
}

// MARK: BaseViewProtocol
extension UserSettingsViewController: BaseViewProtocol {
    func initElements() {
        view.addSubview(tableView)
    }
    
    func applyConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: HelperTable
class HelperTable: UITableViewController {
    
    fileprivate var mainViewController: UserSettingsViewController?
    
    private var currentUserSettings: UserSettingsItem
    private let options: [String]
    private let currentOption: String
    private enum OptionType {
        case dailyRequestLimit, followMode
    }
    private let optionType: OptionType
    
    init(dailyRequestLimit currentUserSettings: UserSettingsItem) {
        optionType = OptionType.dailyRequestLimit
        self.currentUserSettings = currentUserSettings
        self.options = ["1", "2", "3"]
        self.currentOption = String(currentUserSettings.dailyVlogRequestLimit)
        super.init(nibName: nil, bundle: nil)
    }
    
    init(followMode currentUserSettings: UserSettingsItem) {
        optionType = OptionType.followMode
        self.currentUserSettings = currentUserSettings
        self.options = currentUserSettings.followMode.stringCodes
        self.currentOption = currentUserSettings.followMode.stringCode
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
        let currentOption = options[indexPath.row]
        cell.textLabel?.text = currentOption
        if self.currentOption == currentOption {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        for cell in tableView.visibleCells {
            cell.accessoryType = .none
        }
        cell?.accessoryType = .checkmark
        switch optionType {
        case OptionType.dailyRequestLimit:currentUserSettings.dailyVlogRequestLimit = Int(options[indexPath.row])!
        case OptionType.followMode:currentUserSettings.followMode = currentUserSettings.followMode.enumCodes[indexPath.row]
        }
        mainViewController?.updateUserSettings(userSettings: currentUserSettings)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
}
