//
//  ViewController.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
//vms
#import "PhotosViewModel.h"

@interface ViewController : UIViewController
@property (nonatomic) PhotosViewModel* viewModel; //the point to above that is serving

@end

