//
//  ReactionViewController.swift
//  Swabbr
//
//  Created by James Bal on 30-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
// swiftlint:disable force_cast

import UIKit
import AVKit

class ReactionViewController: UIViewController {
    
    private let dateFormatter = DateFormatter()
    
    private let tableView = UITableView()
    
    private var currentVideoRunning: ReactionTableViewCell?
    private var isScrolling = false
    
    private let controllerService = ReactionViewControllerService()
    
    /**
     Initializer of this controller.
     It will set the vlogId value of this class to later make a REST API call to get the data.
     - parameter vlogId: An string value which will be required to get the correct vlog.
    */
    init(vlogId: String) {
        super.init(nibName: nil, bundle: nil)
        controllerService.delegate = self
        controllerService.getReactions(vlogId: vlogId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.white
        
        initElements()
        applyConstraints()
        
    }
    
}

// MARK: BaseViewProtocol
extension ReactionViewController: BaseViewProtocol {
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
}

// MARK: VlogPageViewControllerServiceDelegate
extension ReactionViewController: ReactionViewControllerServiceDelegate {
    func didRetrieveReactions(_ sender: ReactionViewControllerService) {
        tableView.reloadData()
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension ReactionViewController : UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controllerService.reactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reactionCell", for: indexPath) as! ReactionTableViewCell
        let reaction = controllerService.reactions[indexPath.row]
        
        cell.userUsernameLabel.text = reaction.userUsername
        cell.dateLabel.text = dateFormatter.displayDateAsString(date: reaction.reactionDate)
        cell.durationLabel.text = reaction.reactionDuration
        
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
        
        for index in 0..<visibleCells.count {
            var rect = tableView.rectForRow(at: tableView.indexPath(for: visibleCells[index])!)
            rect = tableView.convert(rect, to: tableView.superview)
            let intersect = rect.intersection(tableView.frame)
            let height = intersect.height
            
            // play the video of the cell which is atleast 60% on screen
            if height > 300 * 0.6 {
//                let tempCurrentVideoRunning = (visibleCells[index] as! ReactionTableViewCell)
//                if currentVideoRunning == tempCurrentVideoRunning {
//                    break
//                }
//                if currentVideoRunning != nil {
//                    currentVideoRunning!.player.pause()
//                    currentVideoRunning!.player.seek(to: CMTime(seconds: 0, preferredTimescale: 60))
//                }
//                tempCurrentVideoRunning.player.play()
//                currentVideoRunning = tempCurrentVideoRunning
                break
            }
        }
        
    }
    
}
