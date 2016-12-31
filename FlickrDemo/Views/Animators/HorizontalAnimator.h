//
//  TabBarHorizontalAnimator.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/30/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SwipeDirection) {
    Left, Right
};

@interface HorizontalAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) SwipeDirection direction; //0 for presenting(toView) from right to left  1 for left to right

@end
