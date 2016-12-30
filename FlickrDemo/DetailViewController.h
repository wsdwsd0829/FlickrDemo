//
//  PageViewController.h
//  iOSCodingChallenge
//
//  Created by Sida Wang on 12/28/16.
//  Copyright © 2016 Touch of Modern. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import "PhotosViewModel.h"
@interface DetailViewController: UIViewController

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView* imageView;

//dependencies
@property (nonatomic) Photo* photo;
@property (nonatomic) PhotosViewModel* viewModel;

@end
