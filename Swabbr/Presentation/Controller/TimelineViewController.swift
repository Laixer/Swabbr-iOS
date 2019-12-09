//
//  TimelineViewController.swift
//  Swabbr
//
//  Created by James Bal on 18-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
//  TODO: display error when vlog unavailable
//  swiftlint:disable force_cast

import UIKit

class TimelineViewController : UIViewController {
    
    weak var pageViewController: UIPageViewController!
    
    private let controllerService = TimelineViewControllerService()
    
    override func viewDidLoad() {
        
        navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = UIColor.white
        
        title = "Timeline"
        
        let pvc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        pvc.dataSource = self
        
        self.addChild(pvc)
        self.view.addSubview(pvc.view)
        
        pvc.view.frame = view.frame
        
        pvc.didMove(toParent: self)
        
        self.pageViewController = pvc
        
        controllerService.delegate = self
        controllerService.getVlogs()
        
    }
}

// MARK: UIPageViewControllerDataSource
extension TimelineViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vlogId = (viewController as! VlogPageViewController).vlogId
        let vlog = self.controllerService.vlogs.first(where: { (vlogUserItem) -> Bool in
            vlogUserItem.vlogId == vlogId
        })
        guard let cIndex = self.controllerService.vlogs.firstIndex(of: vlog!) else {
            return nil
        }
        
        let previousIndex = cIndex - 1
        
        guard previousIndex >= 0 else {
            return VlogPageViewController(vlogId: self.controllerService.vlogs.last!.vlogId)
        }
        
        guard self.controllerService.vlogs.count > previousIndex else {
            return nil
        }
        
        return VlogPageViewController(vlogId: self.controllerService.vlogs[previousIndex].vlogId)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vlogId = (viewController as! VlogPageViewController).vlogId
        let vlog = self.controllerService.vlogs.first(where: { (vlogUserItem) -> Bool in
            vlogUserItem.vlogId == vlogId
        })
        guard let cIndex = self.controllerService.vlogs.firstIndex(of: vlog!) else {
            return nil
        }
        
        let nextIndex = cIndex + 1
        let vlogCount = self.controllerService.vlogs.count
        
        guard vlogCount != nextIndex else {
            return VlogPageViewController(vlogId: self.controllerService.vlogs.first!.vlogId)
        }
        
        guard vlogCount > nextIndex else {
            return nil
        }
        
        return VlogPageViewController(vlogId: self.controllerService.vlogs[nextIndex].vlogId)
    }
    
}

// MARK: TimelineViewControllerServiceDelegate
extension TimelineViewController : TimelineViewControllerServiceDelegate {
    func didRetrieveVlogs(_ sender: TimelineViewControllerService) {
        let vlogController = VlogPageViewController(vlogId: sender.vlogs[0].vlogId)
        pageViewController.setViewControllers([vlogController], direction: .forward, animated: true, completion: nil)
    }
}
