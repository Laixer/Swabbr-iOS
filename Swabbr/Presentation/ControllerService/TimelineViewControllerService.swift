//
//  TimelineViewControllerService
//  Swabbr
//
//  Created by James Bal on 14-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class TimelineViewControllerService {
    
    weak var delegate: TimelineViewControllerServiceDelegate?
    
    private let vlogUseCase = VlogUseCase()
    private let userUseCase = UserUseCase()
    
    public private(set) var vlogs: [VlogItem]! = [] {
        didSet {
            delegate?.didRetrieveVlogs(self)
        }
    }
    
    func showCurrentLive(id: String) {
        vlogUseCase.get(id: id, refresh: true) { (vlogModel) in
            guard let vlogModel = vlogModel else {
                return
            }
            self.vlogs.append(VlogItem.mapToPresentation(vlogModel: vlogModel))
        }
    }
    
    /**
     Retrieves vlogs from our VlogUseCase. Has a callback on completion for async processing.
     - parameter refresh: A boolean, when true will retrieve data from remote.
     */
    func getVlogs(refresh: Bool = false) {
        vlogUseCase.get(refresh: refresh, completionHandler: { (vlogModels) -> Void in
            self.vlogs = vlogModels.compactMap({ (vlogModel) -> VlogItem in
                VlogItem.mapToPresentation(vlogModel: vlogModel)
            })
        })
    }
    
}

protocol TimelineViewControllerServiceDelegate: class {
    func didRetrieveVlogs(_ sender: TimelineViewControllerService)
}
