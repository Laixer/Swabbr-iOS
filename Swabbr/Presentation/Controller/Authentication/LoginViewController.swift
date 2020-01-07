//
//  LoginViewController.swift
//  Swabbr
//
//  Created by James Bal on 18-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
// swiftlint:disable force_cast


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
            <<< TextRow("email") {
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
            <<< SwitchRow("rememberMe") {
                $0.title = "Remember me"
                $0.value = false
            }
            <<< ButtonRow {
                $0.title = "Login"
                $0.onCellSelection({ (_, _) in
                    self.submitLoginForm()
                })
        }
    }
    
    /**
     Submits the form
    */
    private func submitLoginForm() {
    
        let dictionary = form.values()
        let loginItem = LoginUserItem(email: dictionary["email"] as! String,
                                      password: dictionary["password"] as! String,
                                      rememberMe: dictionary["rememberMe"] as! Bool)
        controllerService.login(loginItem)
    
    }
    
}

extension LoginViewController: LoginViewControllerServiceDelegate {
    func handleLoginResponse(errorString: String?) {
        guard errorString == nil else {
            BasicErrorDialog.createAlert(message: errorString, context: self)
            return
        }
//        self.present(UINavigationController(rootViewController: TimelineViewController(nibName: nil, bundle: nil)), animated: true, completion: nil)
    }
}

