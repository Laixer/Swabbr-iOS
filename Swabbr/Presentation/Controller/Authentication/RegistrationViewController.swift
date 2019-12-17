//
//  RegisterViewController.swift
//  Swabbr
//
//  Created by James Bal on 18-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Eureka

class RegistrationViewController: FormViewController {
    
    private let controllerService = RegistrationViewControllerService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let english = NSLocale(localeIdentifier: "en_US")
        form +++ Section()
            <<< TextRow {
                $0.title = "Firstname"
                $0.placeholder = "John"
                $0.add(rule: RuleRequired())
            }
            <<< TextRow {
                $0.title = "Lastname"
                $0.placeholder = "Smith"
                $0.add(rule: RuleRequired())
            }
            <<< TextRow {
                $0.title = "Username"
                $0.placeholder = "piet paulusma"
                $0.add(rule: RuleRequired())
            }
            <<< TextRow {
                $0.title = "Email"
                $0.placeholder = "email@email.com"
                $0.add(rule: RuleEmail())
                $0.add(rule: RuleRequired())
            }
            <<< PasswordRow("password") {
                $0.title = "Password"
                $0.placeholder = "password"
                $0.add(rule: RuleRequired())
            }
            <<< PasswordRow {
                $0.title = "Confirm password"
                $0.placeholder = "retype password"
                $0.add(rule: RuleEqualsToRow(form: form, tag: "password"))
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChangeAfterBlurred
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            <<< DateRow {
                $0.title = "Date of birth"
                $0.add(rule: RuleRequired())
                $0.noValueDisplayText = "Select date"
            }
            <<< PhoneRow {
                $0.title = "Phone number"
                $0.placeholder = "+0123456789"
            }
            <<< PushRow<String>() {
                $0.title = "Gender"
                $0.noValueDisplayText = "Pick"
                $0.options = ["Male", "Female", "Other"]
                $0.add(rule: RuleRequired())
            }
            <<< PickerInlineRow<String>() {
                $0.title = "Country"
                $0.noValueDisplayText = "Choose"
                $0.options = NSLocale.isoCountryCodes.compactMap { return english.displayName(forKey: .countryCode, value: $0) }.sorted()
                $0.add(rule: RuleRequired())
            }
            <<< SwitchRow {
                $0.title = "Account is Private"
            }
            <<< ButtonRow {
                $0.title = "Signup"
            }
    }
}
