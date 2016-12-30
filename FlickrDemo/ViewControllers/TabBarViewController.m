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
#import "PereferenceService.h"
#import "Utils.h"
#import "Utils+DDHUI.h"
@interface TabBarViewController () {
    id<PereferenceServiceProtocol> pereferenceService;
}

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pereferenceService = [[PereferenceService alloc] init];
    [self setupViewControllers];
    [self recoverUserPereference];
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
}

-(void) recoverUserPereference {
    ImageListType type = [pereferenceService lastBrowsedImageListType];
    self.selectedIndex = type;
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
