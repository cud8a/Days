//
//  DatePickerViewController.swift
//  Days
//
//  Created by Tamas Bara on 11.04.19.
//  Copyright © 2019 Tamas Bara. All rights reserved.
//

import UIKit

protocol DatePickerViewControllerDelegate: class {
    func datePickerViewController(_ controller: DatePickerViewController, didSelectDate date: Date)
}

class DatePickerViewController: UIViewController {

    private let containerHeight: CGFloat = 260
    
    private var animator: UIViewPropertyAnimator?
    private var animationProgressWhenInterrupted: CGFloat = 0

    weak var delegate: DatePickerViewControllerDelegate?
    
    var date: Date?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitioningDelegate = self
        datePicker.date = date ?? Date()
    }
    
    @IBAction func set() {
        delegate?.datePickerViewController(self, didSelectDate: datePicker.date)
        dismiss(animated: true)
    }
    
    @IBAction func cancel() {
        dismiss(animated: true)
    }
    
    @IBAction func pan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition()
        case .changed:
            let translation = recognizer.translation(in: containerView)
            let fractionComplete = translation.y / containerHeight
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    func startInteractiveTransition() {
        
        guard animator == nil else {return}
        
        view.layoutIfNeeded()
        bottomConstraint.constant = containerHeight
        animator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1) {
            self.dimView.alpha = 0
            self.view.layoutIfNeeded()
        }
        
        animator?.addCompletion { _ in
            if self.animator?.isReversed == true {
                self.animator = nil
                self.bottomConstraint.constant = 0
            } else {
                self.dismiss(animated: false)
            }
        }
        
        animator?.startAnimation()
        animator?.pauseAnimation()
        animationProgressWhenInterrupted = animator?.fractionComplete ?? 0
    }
    
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        animator?.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
    }
    
    func continueInteractiveTransition() {
        if animator?.fractionComplete ?? 0 < 0.15 {
            animator?.isReversed = true
        }
        
        animator?.continueAnimation(withTimingParameters: nil, durationFactor: 1)
    }

}

// MARK: - UIViewControllerTransitioningDelegate
extension DatePickerViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ActionSheetTransitioning()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ActionSheetTransitioning()
    }
}
