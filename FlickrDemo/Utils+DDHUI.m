//
//  Utils+DDHUI.m
//  DemoProject
//
//  Created by MAX on 12/17/16.
//  Copyright © 2016 MAX. All rights reserved.
//

#import "Utils+DDHUI.h"
#import <UIKit/UIKit.h>
@implementation Utils (DDHUI)
    +(id) viewControllerWithIdentifier: (NSString*) identifier fromStoryBoardNamed: (NSString*) storyboardName {
       return [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:identifier];
    }
@end
