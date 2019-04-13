//
//  ActionSheetTransitioning.swift
//  Days
//
//  Created by Tamas Bara on 12.04.19.
//  Copyright © 2019 Tamas Bara. All rights reserved.
//

import UIKit

class ActionSheetTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let targetViewController = transitionContext.viewController(forKey: .to) else {return}
        if targetViewController.isBeingPresented {
            if let datePickerVC = targetViewController as? DatePickerViewController {
                transitionContext.containerView.addSubview(datePickerVC.view)
                datePickerVC.view.layoutIfNeeded()
                datePickerVC.bottomConstraint.constant = 0
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    datePickerVC.dimView.alpha = 0.5
                    datePickerVC.view.layoutIfNeeded()
                }, completion: { _ in
                    transitionContext.completeTransition(true)
                })
            }
        } else if let datePickerVC = transitionContext.viewController(forKey: .from) as? DatePickerViewController {
            transitionContext.containerView.addSubview(datePickerVC.view)
            datePickerVC.view.layoutIfNeeded()
            datePickerVC.bottomConstraint.constant = 260
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                datePickerVC.dimView.alpha = 0
                datePickerVC.view.layoutIfNeeded()
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        }
    }
}
