//
//  Extensions.swift
//  Fit 2
//
//  Created by Gopal Patel on 3/7/25.
//

import Foundation
import UIKit

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

extension UIViewController {
    func presentPopup(_ popupVC: UIViewController) {
        popupVC.modalPresentationStyle = .overFullScreen
        popupVC.modalTransitionStyle = .crossDissolve
        self.present(popupVC, animated: false) {
            popupVC.view.alpha = 0
            popupVC.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                popupVC.view.alpha = 1
                popupVC.view.transform = .identity
            })
        }
    }

    func dismissPopup() {
        UIView.animate(withDuration: 0.15, animations: {
            self.view.alpha = 0
            self.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.dismiss(animated: false)
        }
    }
    
    func dismissPopup(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.15, animations: {
            self.view.alpha = 0
            self.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.dismiss(animated: false)
            completion()
        }
    }
}


import UIKit

class SlideInFromRightAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to),
              let fromView = transitionContext.view(forKey: .from) else { return }

        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)

        if isPresenting {
            // ✅ Ensure the toView starts completely off-screen (to the right)
            let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
            toView.frame = finalFrame.offsetBy(dx: containerView.frame.width, dy: 0)
            containerView.addSubview(toView)

            UIView.animate(withDuration: duration, animations: {
                toView.frame = finalFrame // ✅ Move to correct final position
            }, completion: { finished in
                transitionContext.completeTransition(finished)
            })

        } else {
            // ✅ Ensure the fromView slides out completely
            UIView.animate(withDuration: duration, animations: {
                fromView.frame.origin.x = containerView.frame.width
            }, completion: { finished in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(finished)
            })
        }
    }
}


class SlideInFromRightTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideInFromRightAnimator(isPresenting: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideInFromRightAnimator(isPresenting: false)
    }
}

