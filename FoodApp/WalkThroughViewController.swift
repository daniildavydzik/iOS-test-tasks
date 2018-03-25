//
//  WalkThroughViewController.swift
//  FoodApp
//
//  Created by Daniil Davydik  on 26.04.17.
//  Copyright © 2017 DavydzikInc. All rights reserved.
//

import UIKit

class WalkThroughViewController: UIViewController {
    @IBOutlet var headingLabel : UILabel!
    @IBOutlet var bodyLabel : UILabel!
    @IBOutlet var imgView : UIImageView!
    @IBOutlet var pageControl : UIPageControl!
    @IBOutlet var nextButton : UIButton!
    @IBAction func nextButtonTapped(sender: UIButton){
    
        switch index {
        case 0...1:
        let parentVC = parent as? walkthroughPageViewController
            parentVC?.forward(index: index)
            
        case 2:
            UserDefaults.standard.set(true, forKey: "hasViewedWalkThrough")
            dismiss(animated: true, completion: nil)
            
        default:
            break
        }
    }
    var index = 0
    var heading = ""
    var content = ""
    var imageVIew = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headingLabel.text = heading
        self.bodyLabel.text = content
        self.imgView.image = UIImage(named: imageVIew)
        pageControl.currentPage = index
        
        switch index {
        case 0...1:
        self.nextButton.setTitle("Next", for: .normal)
        case 2:
        self.nextButton.setTitle("Done", for: .normal)
        default:
            break
        }
        
    }

    override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
        
    }
}
