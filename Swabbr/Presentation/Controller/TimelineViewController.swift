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
    
    private let viewModel = TimelineViewViewModel()
    
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
        
        viewModel.delegate = self
        viewModel.getVlogs()
        
    }
}

// MARK: UIPageViewControllerDataSource
extension TimelineViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vlog = (viewController as! VlogPageViewController).viewModel.vlog
        
        guard let cIndex = self.viewModel.vlogs.firstIndex(of: vlog!) else {
            return nil
        }
        
        let previousIndex = cIndex - 1
        
        guard previousIndex >= 0 else {
            return VlogPageViewController(vlog: self.viewModel.vlogs.last!)
        }
        
        guard self.viewModel.vlogs.count > previousIndex else {
            return nil
        }
        
        return VlogPageViewController(vlog: self.viewModel.vlogs[previousIndex])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vlog = (viewController as! VlogPageViewController).viewModel.vlog
        
        guard let cIndex = self.viewModel.vlogs.firstIndex(of: vlog!) else {
            return nil
        }
        
        let nextIndex = cIndex + 1
        let vlogCount = self.viewModel.vlogs.count
        
        guard vlogCount != nextIndex else {
            return VlogPageViewController(vlog: self.viewModel.vlogs.first!)
        }
        
        guard vlogCount > nextIndex else {
            return nil
        }
        
        return VlogPageViewController(vlog: self.viewModel.vlogs[nextIndex])
    }
    
}

// MARK: TimelineViewViewModelDelegate
extension TimelineViewController : TimelineViewViewModelDelegate {
    func didRetrieveVlogs(_ sender: TimelineViewViewModel) {
        let vlogController = VlogPageViewController(vlog: sender.vlogs[0])
        pageViewController.setViewControllers([vlogController], direction: .forward, animated: true, completion: nil)
    }
}
