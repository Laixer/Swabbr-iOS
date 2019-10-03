//
//  TimelineViewController.swift
//  Swabbr
//
//  Created by James Bal on 18-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import UIKit

class TimelineViewController : UIPageViewController {
    
    internal var vlogViewControllers: [VlogPageViewController] = []
    
    /**
     We use this function to override the default values to make it compatible with our needs.
     The UIPageVIewController uses pageCurl as the default transitionStyle, we override this to the scroll type.
     - parameter style: A TransitionStyle value.
     - parameter navigationOrientation: A NavigationOrientation value.
     - parameter options: A dictionary in the following format <OptionsKey : Any>.
    */
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.white
        
        title = "Timeline"
        
        dataSource = self
        delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showCamera))
        
        let sData = ServerData()
        sData.getSpecificUser(id: 0, onComplete: { user in
            (UIApplication.shared.delegate as! AppDelegate).currentUser = user!
        })
        sData.getVlogs(onComplete: {vlogs in
            for vlog in vlogs! {
                self.vlogViewControllers.append(VlogPageViewController(vlog: vlog))
            }
            self.setViewControllers([self.vlogViewControllers.first!], direction: .forward, animated: true, completion: nil)
        })
        
    }
    
    @objc func showCamera() {
        show(VlogStreamViewController(), sender: nil)
    }
}

extension TimelineViewController : UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // MARK: UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vlogViewControllers.firstIndex(of: viewController as! VlogPageViewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return vlogViewControllers.last
        }
        
        guard vlogViewControllers.count > previousIndex else {
            return nil
        }
        
        return vlogViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vlogViewControllers.firstIndex(of: viewController as! VlogPageViewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let vlogViewControllersCount = vlogViewControllers.count
        
        guard vlogViewControllersCount != nextIndex else {
            return vlogViewControllers.first
        }
        
        guard vlogViewControllersCount > nextIndex else {
            return nil
        }
        
        return vlogViewControllers[nextIndex]
    }
    
    
}
