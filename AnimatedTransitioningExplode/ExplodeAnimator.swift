//
//  ExplodeAnimator.swift
//  AnimatedTransitioningExplode
//
//  Created by 成璐飞 on 16/8/6.
//  Copyright © 2016年 成璐飞. All rights reserved.
//

import UIKit


class ExplodeAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {

    /**
     设置转场动画
     
     - parameter transitionContext: 可以通过这个参数获得动画所需的 view 等属性
     
     - returns: 返回动画时间
     */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.75
    }
    /**
     执行转场动画
     
     - parameter transitionContext: 常用 key 值: 1.UITransitionContextFromViewKey
                                                2.UITransitionContextToViewKey    -----方法: viewForKey:
                                                3.containerView()
                                                4.transitionWasCancelled()
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey), toView = transitionContext.viewForKey(UITransitionContextToViewKey), containerView = transitionContext.containerView() else {
            transitionContext.completeTransition(true)
            return
        }
        
        // 将要转场到的 View 加到转场动画的底层
        containerView.insertSubview(toView, atIndex: 0)
        
        let size = toView.frame.size
        var snapshots = [UIView]()
        let xFactor: CGFloat = 8.0
        let yFactor = xFactor * size.height / size.width
        
        // 获取 fromView 的快照
        let fromViewSnapshot = fromView.snapshotViewAfterScreenUpdates(false)
        
        // 将快照剪切成小块加到 containerView 上
        for x in 0.0.stride(to: Double(size.width), by: Double(size.width / xFactor)) {
            for y in 0.0.stride(to: Double(size.height), by: Double(size.height / yFactor)) {
                let snapshotRegion = CGRect(x: CGFloat(x), y: CGFloat(y), width: size.width / xFactor, height: size.height / yFactor)
                
                // 按所给区域获得快照的小块
                let snapshot = fromViewSnapshot.resizableSnapshotViewFromRect(snapshotRegion, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
                // 主要是设置位置
                snapshot.frame = snapshotRegion
                // 将拼成的 fromView 快照加到 containerView的最顶层
                containerView.addSubview(snapshot)
                snapshots.append(snapshot)
            }
        }
        
        // 将 fromView 隐藏
        containerView.sendSubviewToBack(fromView)
        
        UIView.animateWithDuration(0.75, animations: {
            
            snapshots.forEach({ (view) in
                let xOffset = self.randomFloatBetween(lower: -100.0, upper: 100.0)
                let yOffset = self.randomFloatBetween(lower: -100.0, upper: 100.0)
                let angle = self.randomFloatBetween(lower: -10.0, upper: 10.0)
                
                let translateTransform = CGAffineTransformMakeTranslation(view.frame.origin.x - xOffset, view.frame.origin.y - yOffset)
                let angleTransform = CGAffineTransformRotate(translateTransform, angle)
                let scaleTransform = CGAffineTransformScale(angleTransform, 0.01, 0.01)
                
                view.transform = scaleTransform
                view.alpha = 0
            })
            
            }) { (_) in
                snapshots.forEach({ (view) in
                    view.removeFromSuperview()
                })
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
        
    }
    
    
    func randomFloatBetween(lower lower: CGFloat, upper: CGFloat) -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(upper - lower))) + lower
    }

}

