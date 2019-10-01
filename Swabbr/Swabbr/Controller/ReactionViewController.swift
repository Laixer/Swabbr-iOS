//
//  ReactionViewController.swift
//  Swabbr
//
//  Created by James Bal on 30-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import UIKit

class ReactionViewController: UIViewController {
    
    private let vlogId: Int
    
    private let tableView = UITableView()
    
    private var reactions: [VlogReaction] = []
    
    /**
     Initializer of this controller.
     It will set the vlogId value of this class to later make a REST API call to get the data.
     - parameter vlogId: An int value which will be required to get the correct vlog.
    */
    init(vlogId: Int) {
        self.vlogId = vlogId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.white
        
        tableView.register(ReactionTableViewCell.self, forCellReuseIdentifier: "reactionCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        retrieveReactionsFromVlogWithId(vlogId)
        
    }
    
    private func retrieveReactionsFromVlogWithId(_ vlogId: Int) {
        
        ServerData().getVlogReactions(vlogId, onComplete: { vlogReactions in
            if vlogReactions == nil {
                return
            }
            self.reactions = vlogReactions!
            self.tableView.reloadData()
            
        })
        
    }
    
}

extension ReactionViewController : UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reactionCell", for: indexPath) as! ReactionTableViewCell
        let reaction = reactions[indexPath.row]
        
        cell.userUsernameLabel.text = reaction.owner!.username
        cell.dateLabel.text = reaction.postDateString
        
        return cell
    }
    
}
