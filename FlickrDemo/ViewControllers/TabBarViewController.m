//
//  TabBarViewController.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/29/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import "TabBarViewController.h"
#import "HorizontalAnimator.h"
#import "ViewController.h"
#import "PhotosViewModel.h"

#import "Utils.h"
#import "Utils+DDHUI.h"
@interface TabBarViewController ()<UITabBarControllerDelegate> {
   

}
@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewControllers];
    self.delegate = self;
}

-(void)setupViewControllers {
    ViewController* vcRecent = [Utils viewControllerWithIdentifier:@"ViewController" fromStoryBoardNamed:@"Main"];
    vcRecent.viewModel = [[PhotosViewModel alloc] initWithType:ImageListTypeRecent];
    ViewController* vcInteresting = [Utils viewControllerWithIdentifier:@"ViewController" fromStoryBoardNamed:@"Main"];
    vcInteresting.viewModel = [[PhotosViewModel alloc] initWithType:ImageListTypeInteresting];
    self.viewControllers = @[vcRecent, vcInteresting];
    self.tabBar.hidden = YES;
}



-(id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if([toVC isKindOfClass: [ViewController class]]) {
        HorizontalAnimator* animator = [[HorizontalAnimator alloc] init];
        animator.direction = (SwipeDirection)self.selectedIndex;
        return animator;
    } else {
        return nil;
    }
}

@end
