//
//  PageViewController.m
//  iOSCodingChallenge
//
//  Created by Sida Wang on 12/28/16.
//  Copyright © 2016 Touch of Modern. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateUI];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    self.navigationController.navigationBar.topItem.title = @"Gallery";
}
-(void) updateUI {
    self.titleLabel.text = self.photo.title;
    if(!self.imageView.image){
        [self.viewModel loadImageWithUrlString: self.photo.originalImageUrlString withHandler:^(UIImage * image) {
            self.imageView.image = image;
        }];
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //NSLog(@"%f", [self.topLayoutGuide length]);
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
