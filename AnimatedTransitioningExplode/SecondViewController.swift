//
//  SecondViewController.swift
//  AnimatedTransitioningExplode
//
//  Created by 成璐飞 on 16/8/6.
//  Copyright © 2016年 成璐飞. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    private var percentDrivenTransition: UIPercentDrivenInteractiveTransition?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.purpleColor()
        
        view.addSubview({
            let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
            lable.font = UIFont.boldSystemFontOfSize(40)
            lable.text = "Second"
            lable.textAlignment = .Center
            lable.center = self.view.center
            return lable
            }())
        
        view.addGestureRecognizer({
            let pan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(SecondViewController.pan(_:)))
            pan.edges = UIRectEdge.Left
            return pan
        }())
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController!.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pan(edgePan: UIScreenEdgePanGestureRecognizer) {
        
        let progress = edgePan.translationInView(self.view).x / self.view.bounds.width
        
        if edgePan.state == UIGestureRecognizerState.Began {
            self.percentDrivenTransition = UIPercentDrivenInteractiveTransition()
            self.navigationController?.popViewControllerAnimated(true)
        } else if edgePan.state == UIGestureRecognizerState.Changed {
            self.percentDrivenTransition?.updateInteractiveTransition(progress)
        } else if edgePan.state == UIGestureRecognizerState.Cancelled || edgePan.state == UIGestureRecognizerState.Ended {
            if progress > 0.5 {
                self.percentDrivenTransition?.finishInteractiveTransition()
            } else {
                self.percentDrivenTransition?.cancelInteractiveTransition()
            }
            self.percentDrivenTransition = nil
        }
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

extension SecondViewController: UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.Pop {
            return ExplodeAnimator()
        } else {
            return nil
        }
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController is ExplodeAnimator {
            return self.percentDrivenTransition
        } else {
            return nil
        }
    }
}
