//
//  RegisterViewController.swift
//  Swabbr
//
//  Created by James Bal on 18-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

// swiftlint:disable force_cast

import Eureka

class RegistrationViewController: FormViewController {
    
    private let controllerService = RegistrationViewControllerService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let english = NSLocale(localeIdentifier: "en_US")
        form +++ Section()
            <<< TextRow("firstname") {
                $0.title = "Firstname"
                $0.placeholder = "Jane"
                $0.add(rule: RuleRequired())
                }.cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            <<< TextRow("lastname") {
                $0.title = "Lastname"
                $0.placeholder = "Doe"
                $0.add(rule: RuleRequired())
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            <<< TextRow("username") {
                $0.title = "Username"
                $0.placeholder = "Jane Doe"
                $0.add(rule: RuleRequired())
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            <<< TextRow("email") {
                $0.title = "Email"
                $0.placeholder = "jane@doe.com"
                $0.cellSetup({ (cell, _) in
                    cell.textField.autocapitalizationType = .none
                })
                $0.add(rule: RuleEmail())
                $0.add(rule: RuleRequired())
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            <<< PasswordRow("password") {
                $0.title = "Password"
                $0.placeholder = "password"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleMinLength(minLength: 6))
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
            <<< DateRow("dob") {
                $0.title = "Date of birth"
                $0.add(rule: RuleRequired())
                $0.noValueDisplayText = "Select date"
                $0.maximumDate = Date()
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                }.cellUpdate({ (cell, _) in
                    cell.datePicker.timeZone = TimeZone.init(abbreviation: "UTC")
                })
            <<< PhoneRow("phone") {
                $0.title = "Phone number"
                $0.placeholder = "+0123456789"
            }
            <<< PushRow<Int>("gender") {
                let genders = ["Male", "Female", "Unspecified"]
                $0.title = "Gender"
                $0.noValueDisplayText = "Pick"
                $0.options = [0, 1, 2]
                $0.displayValueFor = { (rowValue: Int?) in return (rowValue == nil) ? "Pick" : genders[rowValue!] }
                $0.add(rule: RuleRequired())
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                }.onPresent({ (_, element) in
                    element.enableDeselection = false
                })
            <<< PickerInlineRow<String>("country") {
                $0.title = "Country"
                $0.noValueDisplayText = "Choose"
                $0.options = NSLocale.isoCountryCodes.compactMap { return english.displayName(forKey: .countryCode, value: $0) }.sorted()
                $0.add(rule: RuleRequired())
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
            }
            <<< SwitchRow("private") {
                $0.title = "Account is Private"
                $0.value = false
            }
            <<< ButtonRow {
                $0.title = "Signup"
                $0.onCellSelection({[unowned self] (_, _) in
                    guard self.form.validate().isEmpty else {
                        return
                    }
                    self.sendRegisterForm()
                })
            }
            <<< ButtonRow {
                $0.title = "Cancel"
                $0.onCellSelection({[weak self] (_, _) in
                    self?.dismiss(animated: true, completion: nil)
                })
            }
        
        controllerService.delegate = self
    }
    
    /**
     Send the values from the registration form to the service to handle the registration.
    */
    func sendRegisterForm() {
        let dictionary = form.values()
        controllerService.registerUser(registrationUserItem: RegistrationUserItem(firstName: dictionary["firstname"] as! String,
                                                                                  lastName: dictionary["lastname"] as! String,
                                                                                  gender: dictionary["gender"] as! Int,
                                                                                  country: dictionary["country"] as! String,
                                                                                  email: dictionary["email"] as! String,
                                                                                  password: dictionary["password"] as! String,
                                                                                  birthdate: dictionary["dob"] as! Date,
                                                                                  timezone: TimeZone.current.abbreviation() ?? "CST",
                                                                                  username: dictionary["username"] as! String,
                                                                                  profileImageUrl: nil,
                                                                                  isPrivate: dictionary["private"] as! Bool,
                                                                                  phoneNumber: dictionary["phone"] as! String))
    }
    
}

extension RegistrationViewController: RegistrationViewControllerServiceDelegate {
    func registeredUser(errorString: String?) {
        guard errorString == nil else {
            BasicErrorDialog.createAlert(message: errorString, context: self)
            return
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = MainTabBarViewController()
    }
}
