////
////  ThumbnailZoomTransitionAnimator.swift
////  YoYo_Cinema
////
////  Created by Nicolai Harbo on 18/05/2018.
////  Copyright © 2018 nicoware. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class ZoomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
//    
//    private let duration: TimeInterval = 0.5
//    var operation: UINavigationControllerOperation = .push
//    var thumbnailFrame = CGRect.zero
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return duration
//    }
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let presenting = operation == .push
//        
//        // Determine which is the master view and which is the detail view that we're navigating to and from. The container view will house the views for transition animation.
//        let containerView = transitionContext.containerView
//        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
//        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
//        let feedView = presenting ? fromView : toView
//        let detailView = presenting ? toView : fromView
//        
//        // Determine the starting frame of the detail view for the animation. When we're presenting, the detail view will grow out of the thumbnail frame. When we're dismissing, the detail view will shrink back into that same thumbnail frame.
//        var initialFrame = presenting ? thumbnailFrame : detailView.frame
//        let finalFrame = presenting ? detailView.frame : thumbnailFrame
//        
//        // Resize the detail view to fit within the thumbnail's frame at the beginning of the push animation and at the end of the pop animation while maintaining it's inherent aspect ratio.
//        let initialFrameAspectRatio = initialFrame.width / initialFrame.height
//        let detailAspectRatio = detailView.frame.width / detailView.frame.height
//        if initialFrameAspectRatio > detailAspectRatio {
//            initialFrame.size = CGSize(width: initialFrame.height * detailAspectRatio, height: initialFrame.height)
//        }
//        else {
//            initialFrame.size = CGSize(width: initialFrame.width, height: initialFrame.width / detailAspectRatio)
//        }
//        
//        let finalFrameAspectRatio = finalFrame.width / finalFrame.height
//        var resizedFinalFrame = finalFrame
//        if finalFrameAspectRatio > detailAspectRatio {
//            resizedFinalFrame.size = CGSize(width: finalFrame.height * detailAspectRatio, height: finalFrame.height)
//        }
//        else {
//            resizedFinalFrame.size = CGSize(width: finalFrame.width, height: finalFrame.width / detailAspectRatio)
//        }
//        
//        // Determine how much the detail view needs to grow or shrink.
//        let scaleFactor = resizedFinalFrame.width / initialFrame.width
//        let growScaleFactor = presenting ? scaleFactor: 1/scaleFactor
//        let shrinkScaleFactor = 1/growScaleFactor
//        
//        if presenting {
//            // Shrink the detail view for the initial frame. The detail view will be scaled to CGAffineTransformIdentity below.
//            detailView.transform = CGAffineTransform(scaleX: shrinkScaleFactor, y: shrinkScaleFactor)
//            detailView.center = CGPoint(x: thumbnailFrame.midX, y: thumbnailFrame.midY)
//            detailView.clipsToBounds = true
//        }
//        
//        // Set the initial state of the alpha for the master and detail views so that we can fade them in and out during the animation.
//        detailView.alpha = presenting ? 0 : 1
//        detailView.alpha = presenting ? 1 : 0
//        
//        // Add the view that we're transitioning to to the container view that houses the animation.
//        containerView.addSubview(toView)
//        containerView.bringSubview(toFront: detailView)
//        
//        // Animate the transition.
//        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: [.curveEaseInOut], animations: {
//            // Fade the master and detail views in and out.
//            detailView.alpha = presenting ? 1 : 0
//            feedView.alpha = presenting ? 0 : 1
//            
//            if presenting {
//                // Scale the master view in parallel with the detail view (which will grow to its inherent size). The translation gives the appearance that the anchor point for the zoom is the center of the thumbnail frame.
////                let scale = CGAffineTransform(scaleX: growScaleFactor, y: growScaleFactor)
////                let translate = feedView.transform.translatedBy(x: feedView.frame.midX - self.thumbnailFrame.midX, y: feedView.frame.midY - self.thumbnailFrame.midY)
////                feedView.transform = translate.concatenating(scale)
////                detailView.transform = .identity
//                
//                let scale = CGAffineTransform(scaleX: growScaleFactor, y: growScaleFactor)
//                let translate = CGAffineTransform(scaleX: feedView.frame.midX - self.thumbnailFrame.midX, y: feedView.frame.midY - self.thumbnailFrame.midY)
////                let translate = CGAffineTransform.translatedBy(CGAffineTransform(scaleX: feedView.frame.midX - self.thumbnailFrame.midX, y: feedView.frame.midY - self.thumbnailFrame.midY))
//                feedView.transform = translate.concatenating(scale)
//                detailView.transform = .identity
////                let scale = CGAffineTransformMakeScale(growScaleFactor, growScaleFactor)
////                let translate = CGAffineTransformTranslate(storyFeedView.transform, storyFeedView.frame.midX - self.thumbnailFrame.midX, storyFeedView.frame.midY - self.thumbnailFrame.midY)
////                storyFeedView.transform = CGAffineTransformConcat(translate, scale)
////                storyDetailView.transform = CGAffineTransformIdentity
//            }
//            else {
//                // Return the master view to its inherent size and position and shrink the detail view.
//                feedView.transform = .identity
//                detailView.transform = CGAffineTransform(scaleX: shrinkScaleFactor, y: shrinkScaleFactor)
//                
////                storyFeedView.transform = CGAffineTransformIdentity
////                storyDetailView.transform = CGAffineTransformMakeScale(shrinkScaleFactor, shrinkScaleFactor)
//            }
//            
//            // Move the detail view to the final frame position.
//            detailView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
//        }) { finished in
//            transitionContext.completeTransition(finished)
//        }
//    }
//    
//}
