//
//  OpenPageAnimator.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/31/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OpenSourceProtocol.h"


@interface OpenPageAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) BOOL presenting;

@property (nonatomic, weak) id<OpenSourceProtocol> delegate;

@end
