//
//  Utils+DDHUI.h
//  DemoProject
//
//  Created by MAX on 12/17/16.
//  Copyright © 2016 MAX. All rights reserved.
//

#import "Utils.h"

@interface Utils (DDHUI)
    ///instantiate viewController with identifier and storyboard name
    +(id) viewControllerWithIdentifier: (NSString*) identifier fromStoryBoardNamed: (NSString*) storyboardName;
@end
