//
//  TabBarHorizontalAnimator.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/30/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import "HorizontalAnimator.h"

@implementation HorizontalAnimator

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //common
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView* containerView = [transitionContext containerView];
    UIView* toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toVC];
    CGRect toViewStartFrame = toViewFinalFrame;
    if(self.direction == Left) {
    toViewStartFrame.origin.x = toViewFinalFrame.origin.x + toViewFinalFrame.size.width;
    }else {
         toViewStartFrame.origin.x = toViewFinalFrame.origin.x - toViewFinalFrame.size.width;
    }
    toView.frame = toViewStartFrame;
    [containerView addSubview:toView];
    
    [UIView animateWithDuration: [self transitionDuration:transitionContext] animations:^{
        toView.frame = toViewFinalFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
}
@end
