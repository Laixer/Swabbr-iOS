//
//  SearchViewControllerService.swift
//  Swabbr
//
//  Created by James Bal on 02-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class SearchViewControllerService {
    
    weak var delegate: SearchViewControllerServiceDelegate?
    
    private let userUseCase = UserUseCase()
    
    public private(set) var users: [UserItem]! = [] {
        didSet {
            delegate?.foundUsers(self)
        }
    }
    
    func findUsers(term: String) {
        userUseCase.searchForUsers(searchTerm: term) { (userModels) in
            self.users = userModels.compactMap({ (userModel) -> UserItem in
                UserItem.mapToPresentation(model: userModel)
            })
        }
    }

}

protocol SearchViewControllerServiceDelegate: class {
    func foundUsers(_ sender: SearchViewControllerService)
}
