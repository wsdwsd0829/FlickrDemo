//
//  PageViewController.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/29/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import "PageViewController.h"
#import "DetailViewController.h"

@interface PageViewController ()
@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//can put in a Category
//Mark: Page Navigation
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if(![viewController isKindOfClass: [DetailViewController class]]) {
        return nil;
    }
    DetailViewController* oldVC = (DetailViewController*)viewController;
    DetailViewController* dvc = [self createDetailPage];
    dvc.photo = [self.viewModel previousPhotoFor:oldVC.photo];
    return dvc.photo ? dvc: nil;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if(![viewController isKindOfClass: [DetailViewController class]]) {
        return nil;
    }
    DetailViewController* oldVC = (DetailViewController*)viewController;
    DetailViewController* dvc = [self createDetailPage];
    dvc.photo = [self.viewModel nextPhotoFor: oldVC.photo];
    return dvc.photo ? dvc: nil;
}

-(DetailViewController*) createDetailPage {
    DetailViewController* dvc = [Utils viewControllerWithIdentifier:@"DetailViewController" fromStoryBoardNamed: @"Main"];
    dvc.navigationItem.title=@"Gallery";
    dvc.navigationController.navigationBar.topItem.title = @"gallery";
    //create create New viewModel for Detail, here for simplicity;
    dvc.viewModel = self.viewModel;
    
    return dvc;
}

@end
