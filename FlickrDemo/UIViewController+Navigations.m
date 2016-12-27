//
//  UIViewController+Navigations.m
//  ViewControllerNavigation
//
//  Created by Sida Wang on 12/26/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import "UIViewController+Navigations.h"

@implementation UIViewController (Navigations)
- (BOOL)isModal {
    if([self presentingViewController])
        return YES;
    if([[[self navigationController] presentingViewController] presentedViewController] == [self navigationController])
        return YES;
    if([[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]])
        return YES;
    return NO;
}

-(UIViewController*) topVisibleViewController {
    if([self isKindOfClass: [UITabBarController class]]) {
        return [((UITabBarController*)self).selectedViewController topVisibleViewController];
    } else if([self isKindOfClass: [UINavigationController class]]) {
         return [((UINavigationController*)self).topViewController topVisibleViewController];
    } else if (self.presentedViewController) {
        return [self.presentedViewController topVisibleViewController];
    } else {
        return self;
    }
}

-(void)removeMyself {
    if([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* nvc = (UINavigationController*)self.parentViewController;
        if(nvc.childViewControllers.firstObject == self) {
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        } else {
            [nvc popViewControllerAnimated:YES];
        }
    } else if(self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

@end
