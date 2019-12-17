//
//  LoginViewController.swift
//  Swabbr
//
//  Created by James Bal on 18-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Eureka

class LoginViewController: FormViewController {
    
    private let controllerService = LoginViewControllerService()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        controllerService.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                $0.onCellSelection({ (_, _) in
                    self.controllerService.login()
                })
        }
    }
}

extension LoginViewController: LoginViewControllerServiceDelegate {
    func handleLoginResponse(code: Int) {
        UserDefaults.standard.set("login", forKey: "user")
        self.present(UINavigationController(rootViewController: TimelineViewController(nibName: nil, bundle: nil)), animated: true, completion: nil)
    }
}

