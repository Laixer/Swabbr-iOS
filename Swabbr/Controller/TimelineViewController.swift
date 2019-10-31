//
//  TimelineViewController.swift
//  Swabbr
//
//  Created by James Bal on 18-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import UIKit

class TimelineViewController : UIViewController {
    
    weak var pageViewController: UIPageViewController!
    private var vlogs: [Vlog] = []
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.white
        
        title = "Timeline"
        
        let pvc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        pvc.dataSource = self
        
        self.addChild(pvc)
        self.view.addSubview(pvc.view)
        
        pvc.view.frame = view.frame
        
        pvc.didMove(toParent: self)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showCamera))
        
        let sData = ServerData()
        sData.getSpecificUser(id: 0, onComplete: { user in
            User.current = user!
        })
        sData.getVlogs(onComplete: {vlogs in
            for vlog in vlogs! {
                self.vlogs.append(vlog)
            }
            let vlogController = VlogPageViewController(vlog: self.vlogs[0])
            pvc.setViewControllers([vlogController], direction: .forward, animated: true, completion: nil)
            self.pageViewController = pvc
        })
        
    }
    
    @objc func showCamera() {
        show(VlogStreamViewController(), sender: nil)
    }
}

extension TimelineViewController : UIPageViewControllerDataSource {
    
    // MARK: UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vlog = (viewController as! VlogPageViewController).vlog
        guard let cIndex = vlogs.firstIndex(of: vlog) else {
            return nil
        }
        
        let previousIndex = cIndex - 1
        
        guard previousIndex >= 0 else {
            return VlogPageViewController(vlog: vlogs.last!)
        }
        
        guard vlogs.count > previousIndex else {
            return nil
        }
        
        return VlogPageViewController(vlog: vlogs[previousIndex])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vlog = (viewController as! VlogPageViewController).vlog
        guard let cIndex = vlogs.firstIndex(of: vlog) else {
            return nil
        }
        
        let nextIndex = cIndex + 1
        let vlogCount = vlogs.count
        
        guard vlogCount != nextIndex else {
            return VlogPageViewController(vlog: vlogs.first!)
        }
        
        guard vlogCount > nextIndex else {
            return nil
        }
        
        return VlogPageViewController(vlog: vlogs[nextIndex])
    }
    
    
}
