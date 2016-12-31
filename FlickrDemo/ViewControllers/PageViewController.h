//
//  PageViewController.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/29/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OpenSourceProtocol.h"
#import "PhotosViewModel.h"
#import "Utils+DDHUI.h"
#import "DetailViewController.h"

@interface PageViewController : UIPageViewController <OpenSourceProtocol,UIPageViewControllerDataSource>
@property (nonatomic) CGRect fromFrame;
@property (nonatomic) PhotosViewModel* viewModel; //the point to above that is serving
-(DetailViewController*) createDetailPage;
@end
