//
//  TabBarViewController.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/29/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import "TabBarViewController.h"
#import "ViewController.h"
#import "PhotosViewModel.h"
#import "Utils.h"
#import "Utils+DDHUI.h"
@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewControllers];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupViewControllers {
    ViewController* vcRecent = [Utils viewControllerWithIdentifier:@"ViewController" fromStoryBoardNamed:@"Main"];
    vcRecent.viewModel = [[PhotosViewModel alloc] initWithType:ImageListTypeRecent];
    UINavigationController* nvcRecent = [[UINavigationController alloc] initWithRootViewController:vcRecent];
    
    ViewController* vcInteresting = [Utils viewControllerWithIdentifier:@"ViewController" fromStoryBoardNamed:@"Main"];
    UINavigationController* nvcInteresting = [[UINavigationController alloc] initWithRootViewController:vcInteresting];
    vcInteresting.viewModel = [[PhotosViewModel alloc] initWithType:ImageListTypeInteresting];
    self.viewControllers = @[nvcRecent, nvcInteresting];
    
    self.tabBar.hidden = YES;
    [vcRecent.tabBarItem setTitle:@"Recent"];
    [vcInteresting.tabBarItem setTitle:@"Interesting"];
    [vcRecent.tabBarItem setImage:[UIImage imageNamed:@"placeholder"]];
    [vcInteresting.tabBarItem setImage:[UIImage imageNamed:@"placeholder"]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
