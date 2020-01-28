//
//  TimelineViewController.swift
//  Swabbr
//
//  Created by James Bal on 18-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    
    weak var pageViewController: UIPageViewController!
    
    private let controllerService = TimelineViewControllerService()
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.white
        
        title = "Timeline"
        
        let pvc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        pvc.dataSource = self
        
        addChild(pvc)
        view.addSubview(pvc.view)
        
        pvc.view.frame = view.frame
        
        pvc.didMove(toParent: self)
        
        pageViewController = pvc
        
        controllerService.delegate = self
        controllerService.getVlogs()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    /**
     Show a specific vlog.
     # Notes #
     User has pressed on a notification.
     - parameter id: The id of the vlog.
    */
    func showSpecificVlog(id: String) {
        controllerService.showCurrentLive(id: id)
    }

}

// MARK: UIPageViewControllerDataSource
extension TimelineViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vlogId = (viewController as? VlogPageViewController)!.vlogId
        let vlog = self.controllerService.vlogs.first(where: { (vlogItem) -> Bool in
            vlogItem.id == vlogId
        })
        guard let cIndex = self.controllerService.vlogs.firstIndex(of: vlog!) else {
            return nil
        }
        
        let previousIndex = cIndex - 1
        
        guard previousIndex >= 0 else {
            return VlogPageViewController(vlogId: self.controllerService.vlogs.last!.id)
        }
        
        guard self.controllerService.vlogs.count > previousIndex else {
            return nil
        }
        
        return VlogPageViewController(vlogId: self.controllerService.vlogs[previousIndex].id)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vlogId = (viewController as? VlogPageViewController)!.vlogId
        let vlog = self.controllerService.vlogs.first(where: { (vlogItem) -> Bool in
            vlogItem.id == vlogId
        })
        guard let cIndex = self.controllerService.vlogs.firstIndex(of: vlog!) else {
            return nil
        }
        
        let nextIndex = cIndex + 1
        let vlogCount = self.controllerService.vlogs.count
        
        guard vlogCount != nextIndex else {
            return VlogPageViewController(vlogId: self.controllerService.vlogs.first!.id)
        }
        
        guard vlogCount > nextIndex else {
            return nil
        }
        
        return VlogPageViewController(vlogId: self.controllerService.vlogs[nextIndex].id)
    }
    
}

// MARK: TimelineViewControllerServiceDelegate
extension TimelineViewController: TimelineViewControllerServiceDelegate {
    func didRetrieveVlogs(_ sender: TimelineViewControllerService) {
        let vlogController = VlogPageViewController(vlogId: sender.vlogs[sender.vlogs.count - 1].id)
        pageViewController.setViewControllers([vlogController], direction: .forward, animated: true, completion: nil)
    }
}
