//
//  ReviewViewController.swift
//  FoodApp
//
//  Created by Daniil Davydik  on 18.04.17.
//  Copyright © 2017 DavydzikInc. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    @IBOutlet var backgroundImg: UIImageView?
    @IBOutlet var containerView:UIView!
    var restaurant:RestaurantMO?

       override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect:blurEffect)
        blurView.frame = view.bounds
        backgroundImg?.addSubview(blurView)
        let transform1 = CGAffineTransform(scaleX: 0 , y: 0)
        let transform2 = CGAffineTransform.init(translationX: 0, y: -1000)
        let transform3 = transform1.concatenating(transform2)
        self.containerView.transform = transform3
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            self.containerView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
