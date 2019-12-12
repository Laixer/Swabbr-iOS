//
//  LoginViewController.swift
//  Swabbr
//
//  Created by James Bal on 18-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Eureka

class LoginViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section()
            <<< TextRow {
                $0.title = "Email"
                $0.placeholder = "email@email.com"
                $0.add(rule: RuleEmail())
                $0.add(rule: RuleRequired())
            }
            <<< PasswordRow {
                $0.title = "Password"
                $0.placeholder = "password"
                $0.add(rule: RuleRequired())
            }
            <<< ButtonRow {
                $0.title = "Login"
        }
    }
}

