//
//  LoginViewController.swift
//  Swabbr
//
//  Created by James Bal on 18-09-19.
//  Copyright © 2019 Laixer. All rights reserved.

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
                $0.cellSetup({ (cell, _) in
                    cell.textField.autocapitalizationType = .none
                })
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
                $0.onCellSelection({[unowned self] (_, _) in
                    guard self.form.validate().isEmpty else {
                        return
                    }
                    self.submitLoginForm()
                })
            }
            <<< ButtonRow {
                $0.title = "Register"
                $0.onCellSelection({[weak self] (_, _) in
                    self?.present(UINavigationController(rootViewController: RegistrationViewController()), animated: true, completion: nil)
                })
        }
    }
    
    /**
     Submits the form
    */
    private func submitLoginForm() {
        
        let dictionary = form.values()
        let loginItem = LoginUserItem(email: String(describing: dictionary["email"]),
                                      password: String(describing: dictionary["password"]),
                                      rememberMe: Bool(String(describing: dictionary["rememberMe"]))!)
        controllerService.login(loginItem)
    
    }
}

extension LoginViewController: LoginViewControllerServiceDelegate {
    func handleLoginResponse(errorString: String?) {
        
        if let errorString = errorString {
            BasicErrorDialog.createAlert(message: errorString, context: self)
            return
        }

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window!.rootViewController = MainTabBarViewController()
        }
    }
}
