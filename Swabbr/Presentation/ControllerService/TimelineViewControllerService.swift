//
//  TimelineViewControllerService
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class TimelineViewControllerService {
    
    weak var delegate: TimelineViewControllerServiceDelegate?
    
    let vlogDataRetriever = VlogDataRetriever.shared
    let userDataRetriever = UserDataRetriever.shared
    
    var vlogs: [VlogUserItem]! = [] {
        didSet {
            delegate?.didRetrieveVlogs(self)
        }
    }
    
    /**
     Retrieves vlogs from our VlogDataRetriever. Has a callback on completion for async processing.
     */
    func getVlogs() {
        vlogDataRetriever.get(refresh: true, completionHandler: { (vlogModels) -> Void in
            let vlogUserGroup = DispatchGroup()
            var vlogUserItems: [VlogUserItem] = []
            for vlogModel in vlogModels! {
                vlogUserGroup.enter()
                self.userDataRetriever.get(id: vlogModel.ownerId, refresh: false, completionHandler: { (userModel) -> Void in
                    vlogUserItems.append(VlogUserItem(vlogModel: vlogModel, userModel: userModel!))
                    vlogUserGroup.leave()
                })
            }
            vlogUserGroup.notify(queue: .main) {
                self.vlogs = vlogUserItems
            }
        })
    }
    
}

protocol TimelineViewControllerServiceDelegate: class {
    func didRetrieveVlogs(_ sender: TimelineViewControllerService)
}
