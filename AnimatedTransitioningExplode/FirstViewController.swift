//
//  FirstViewController.swift
//  AnimatedTransitioningExplode
//
//  Created by 成璐飞 on 16/8/6.
//  Copyright © 2016年 成璐飞. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBarHidden = true
        
        view.backgroundColor = UIColor.cyanColor()
        view.addSubview({
            let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
            lable.font = UIFont.boldSystemFontOfSize(40)
            lable.text = "First"
            lable.textAlignment = .Center
            lable.center = self.view.center
            return lable
            }())
        view.addGestureRecognizer({
            let tap = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.tap))
            return tap
        }())
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tap() {
        let secondVC = SecondViewController()
        navigationController?.pushViewController(secondVC, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension FirstViewController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.Push {
            return ExplodeAnimator()
        } else {
            return nil
        }
    }
}