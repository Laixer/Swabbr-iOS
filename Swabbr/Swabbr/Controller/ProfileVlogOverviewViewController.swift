//
//  ProfileVlogOverviewViewController.swift
//  Swabbr
//
//  Created by James Bal on 02-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation
import UIKit

class ProfileVlogOverviewViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var userId: Int
    private var vlogs: [Vlog] = []
    
    /**
     Initialize the controller with the given user id.
     The id will be used to make the calls correctly to the REST API.
     - parameter userId: An int value representing an user id.
    */
    init(userId: Int) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.white
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        
        view.addSubview(collectionView)
        
        collectionView.register(VlogCollectionViewCell.self, forCellWithReuseIdentifier: "vlogCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        applyConstraints()
        
        getVlogsOfThisUserWithId(userId)
        
    }
    
    /**
     Get the vlogs that is associated with the userId
     - parameter userId: The id of the user that the vlog needs to be owned by.
    */
    private func getVlogsOfThisUserWithId(_ userId: Int) {
        
        ServerData().getUserSpecificVlogs(userId, onComplete: {vlogs in
            if vlogs == nil {
                return
            }
            self.vlogs = vlogs!
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.layoutSubviews()
        })
        
    }
    
    /**
     Apply all constraints to this view.
    */
    private func applyConstraints() {
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
}

extension ProfileVlogOverviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vlogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vlogCell", for: indexPath) as! VlogCollectionViewCell
        let vlog = vlogs[indexPath.row]
        cell.durationLabel.text = vlog.duration
        return cell
    }
    
}

extension ProfileVlogOverviewViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
    
}
