//
//  SearchViewController.swift
//  Swabbr
//
//  Created by James Bal on 02-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, BaseViewProtocol {
    
    private let searchBar = UISearchBar()
    private var collectionView: UICollectionView!
    
    private let controllerService = SearchViewControllerService()
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.white
        
        initElements()
        applyConstraints()
        
        controllerService.delegate = self
        controllerService.findUsers(term: "")
    }
    
    func initElements() {
        
        searchBar.placeholder = "Search..."
        searchBar.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.cancelsTouchesInView = false
        tapGesture.addTarget(self, action: #selector(dismissKeyboard))
        
        collectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: "userCell")
        collectionView.addGestureRecognizer(tapGesture)

        view.addSubview(collectionView)
    }
    
    func applyConstraints() {
        
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /**
     Handles the actions required to dismiss the keyboard of the screen.
    */
    @objc private func dismissKeyboard() {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
            searchBar.endEditing(true)
        }
    }
    
}

// MARK: SearchViewControllerServiceDelegate
extension SearchViewController: SearchViewControllerServiceDelegate {
    func foundUsers(_ sender: SearchViewControllerService) {
        collectionView.reloadData()
    }
}

// MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        controllerService.findUsers(term: searchBar.text!)
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllerService.users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as? UserCollectionViewCell
        let user = controllerService.users[indexPath.row]
        cell!.profileImageView.imageFromUrl(user.profileImageUrl)
        cell!.usernameLabel.text = user.username
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = controllerService.users[indexPath.row]
        self.navigationController?.pushViewController(ProfileViewController(userId: user.id), animated: true)
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
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
