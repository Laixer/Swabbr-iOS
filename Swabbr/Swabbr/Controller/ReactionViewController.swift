//
//  ReactionViewController.swift
//  Swabbr
//
//  Created by James Bal on 30-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import UIKit
import AVKit

class ReactionViewController: UIViewController, BaseViewProtocol {
    
    private let vlogId: Int
    
    private let tableView = UITableView()
    
    private var reactions: [VlogReaction] = []
    
    private var currentVideoRunning: ReactionTableViewCell?
    private var isScrolling = false
    
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
        
        initElements()
        applyConstraints()
        
        retrieveReactionsFromVlogWithId(vlogId)
        
    }
    
    internal func initElements() {
        tableView.register(ReactionTableViewCell.self, forCellReuseIdentifier: "reactionCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    
    internal func applyConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /**
     This function will find the reactions for the specific vlog.
     - parameter vlogId: The id of the vlog used to associate the reactions with.
    */
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
        cell.durationLabel.text = reaction.duration
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrolling = false
        finishedScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isScrolling = false
        finishedScrolling()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
    }
    
    // MARK: Custom
    /**
     Handle correctly when the tableview stops with scrolling, may be user stop or tableview deceleration stop.
     After the scrolling has been finished this function will handle the cells correctly.
    */
    private func finishedScrolling() {
        
        let visibleCells = tableView.visibleCells
        let visibleCellsCount = visibleCells.count
        
        // if currently scrolling or the tableview is empty just do nothing
        if isScrolling || visibleCellsCount == 0 {
            return
        }
        
        if visibleCellsCount == 1 {
            (visibleCells[0] as! ReactionTableViewCell).player.play()
            return
        }
        
        for i in 0..<visibleCells.count {
            var rect = tableView.rectForRow(at: tableView.indexPath(for: visibleCells[i])!)
            rect = tableView.convert(rect, to: tableView.superview)
            let intersect = rect.intersection(tableView.frame)
            let height = intersect.height
            
            // play the video of the cell which is atleast 60% on screen
            if height > 300 * 0.6 {
                let tempCurrentVideoRunning = (visibleCells[i] as! ReactionTableViewCell)
                if currentVideoRunning == tempCurrentVideoRunning {
                    break
                }
                if currentVideoRunning != nil {
                    currentVideoRunning!.player.pause()
                    currentVideoRunning!.player.seek(to: CMTime(seconds: 0, preferredTimescale: 60))
                }
                tempCurrentVideoRunning.player.play()
                currentVideoRunning = tempCurrentVideoRunning
                break
            }
        }
        
    }
    
}
