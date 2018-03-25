//
//  walkthroughPageViewController.swift
//  FoodApp
//
//  Created by Daniil Davydik  on 26.04.17.
//  Copyright © 2017 DavydzikInc. All rights reserved.
//

import UIKit

class walkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    var pageHeadings = ["Personalize", "Locate", "Discover"]
    var pageImages = ["foodpin-intro-1", "foodpin-intro-2", "foodpin-intro-3"]
    var pageContent = ["Pin your favorite restaurants and create your own food guide",
                       "Search and locate your favourite restaurant on Maps",
                       "Find restaurants pinned by your friends and other foodies around the world"]
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }

        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index  =  (viewController as! WalkThroughViewController).index
        
        index -= 1
        return contentViewController(at: index)
        
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index  =  (viewController as! WalkThroughViewController).index
       
        index += 1
        return contentViewController(at: index)
    }
    
    func contentViewController(at index: Int) -> WalkThroughViewController?{
    
        if index<0 || index>=pageHeadings.count  {
            return nil
        }
        
        if let contentVC = storyboard?.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkThroughViewController {
            contentVC.heading = pageHeadings[index]
            contentVC.content = pageContent [index]
            contentVC.imageVIew  =  pageImages[index]
            contentVC.index = index
            
            return contentVC
            
        }
        return nil
    }
    func forward(index: Int) {
        if let nextViewController = contentViewController(at: index + 1) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    

}
