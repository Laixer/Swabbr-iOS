//
//  FollowRequestViewController.swift
//  Swabbr
//
//  Created by James Bal on 13-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

import UIKit

class FollowRequestViewController: UIViewController {
    
    private var tableView: UITableView!
    private let controllerService = FollowRequestViewControllerService()
    
    private let incomingButton = UIButton()
    private let outgoingButton = UIButton()
    
    private var showingIncoming = true
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        
        title = "Follow Requests"
        
        initElements()
        applyConstraints()
        
        incomingButton.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        incomingButton.titleLabel?.text = "Incoming"
        incomingButton.tintColor = UIColor.white
        incomingButton.backgroundColor = UIColor.black
        outgoingButton.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        outgoingButton.titleLabel?.text = "Outgoing"
        outgoingButton.tintColor = UIColor.white
        outgoingButton.backgroundColor = UIColor.black
        
        controllerService.delegate = self
        
        controllerService.getIncomingFollowRequests()
        
    }
    
    @objc private func incomingButtonClicked() {
        guard !showingIncoming else {
            return
        }
        showingIncoming = true
        controllerService.getIncomingFollowRequests()
    }
    
    @objc private func outgoingButtonClicked() {
        guard showingIncoming else {
            return
        }
        showingIncoming = false
        controllerService.getOutgoingFollowRequests()
    }
    
    @objc func acceptButtonClicked(sender: UIButton) {
        let index = sender.tag
        controllerService.acceptFollowRequest(followRequestId: controllerService.followRequests[index].followRequestId)
    }
    
    @objc func denyButtonClicked(sender: UIButton) {
        let index = sender.tag
        controllerService.denyFollowRequest(followRequestId: controllerService.followRequests[index].followRequestId)
    }
    
    @objc func removeButtonClicked(sender: UIButton) {
        let index = sender.tag
        controllerService.removeFollowRequest(followRequestId: controllerService.followRequests[index].followRequestId)
    }
    
}

// MARK: FollowRequestViewControllerServiceDelegate
extension FollowRequestViewController: FollowRequestViewControllerServiceDelegate {
    
    func performedFollowRequestCall(errorString: String?) {
        guard let errorString = errorString else {
            tableView.reloadData()
            return
        }
        BasicDialog.createAlert(message: errorString, context: self)
    }
    func retrievedFollowRequests() {
        tableView.reloadData()
    }
}

// MARK: BaseViewProtocol
extension FollowRequestViewController: BaseViewProtocol {
    
    func initElements() {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(IncomingRequestTableViewCell.self, forCellReuseIdentifier: "incomingRequestCell")
        tableView.register(OutgoingRequestTableViewCell.self, forCellReuseIdentifier: "outgoingRequestCell")
        self.tableView = tableView
        
        incomingButton.addTarget(self, action: #selector(incomingButtonClicked), for: .touchUpInside)
        outgoingButton.addTarget(self, action: #selector(outgoingButtonClicked), for: .touchUpInside)
        
        view.addSubview(tableView)
        view.addSubview(incomingButton)
        view.addSubview(outgoingButton)
    }
    
    func applyConstraints() {
        incomingButton.translatesAutoresizingMaskIntoConstraints = false
        outgoingButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            incomingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            incomingButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            
            outgoingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            outgoingButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            tableView.topAnchor.constraint(equalTo: incomingButton.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
}

// MARK: UITableViewDelegate
extension FollowRequestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controllerService.followRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if showingIncoming {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "incomingRequestCell", for: indexPath) as? IncomingRequestTableViewCell)!
            let followRequest = controllerService.followRequests[indexPath.row]
            
            cell.userUsernameLabel.text = followRequest.userUsername
            cell.profileImageView.imageFromUrl(followRequest.userProfileImageUrl)
            cell.timeLabel.text = followRequest.date
            
            cell.acceptButton.tag = indexPath.row
            cell.acceptButton.addTarget(self, action: #selector(acceptButtonClicked(sender:)), for: .touchUpInside)
            
            cell.denyButton.tag = indexPath.row
            cell.denyButton.addTarget(self, action: #selector(denyButtonClicked(sender:)), for: .touchUpInside)
            
            return cell
        } else {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "outgoingRequestCell", for: indexPath) as? OutgoingRequestTableViewCell)!
            let followRequest = controllerService.followRequests[indexPath.row]
            
            cell.userUsernameLabel.text = followRequest.userUsername
            cell.profileImageView.imageFromUrl(followRequest.userProfileImageUrl)
            cell.timeLabel.text = followRequest.date
            
            cell.removeButton.tag = indexPath.row
            cell.removeButton.addTarget(self, action: #selector(removeButtonClicked(sender:)), for: .touchUpInside)
            
            return cell
        }
        
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
